import 'dart:typed_data';
import 'package:file_selector/file_selector.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:cvms_desktop/features/reports/controllers/pdf_report_builder.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pdf_editor_state.dart';

class PdfEditorCubit extends Cubit<PdfEditorState> {
  PdfEditorCubit() : super(const PdfEditorInitial());

  void toggleEditMode() {
    if (state is PdfEditorPreviewMode) {
      final previewState = state as PdfEditorPreviewMode;
      emit(PdfEditorEditMode(previewState.pdfBytes));
    } else if (state is PdfEditorEditMode) {
      final editState = state as PdfEditorEditMode;
      emit(PdfEditorPreviewMode(editState.pdfBytes));
    }
  }

  Future<void> generatePdf() async {
    emit(PdfLoading());
    try {
      final bytes = await PdfReportBuilder.buildVehicleReport();
      emit(PdfEditorPreviewMode(bytes));
    } catch (e) {
      emit(PdfError(e.toString()));
    }
  }

  Future<void> savePdfToFile() async {
    final currentPdfBytes = pdfBytes;
    if (currentPdfBytes == null) {
      emit(const PdfError('No PDF data available to save'));
      return;
    }

    emit(PdfSaving());
    try {
      // Generate filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'vehicle_report_$timestamp.pdf';

      // Use file_selector to pick save location
      final result = await getSaveLocation(
        acceptedTypeGroups: [
          const XTypeGroup(
            label: 'PDF files',
            extensions: ['pdf'],
            mimeTypes: ['application/pdf'],
          ),
        ],
        suggestedName: fileName,
      );

      if (result != null) {
        final file = XFile.fromData(
          currentPdfBytes,
          name: fileName,
          mimeType: 'application/pdf',
        );
        await file.saveTo(result.path);

        // Emit success state for UI to show success message
        emit(
          PdfSaveSuccess(
            currentPdfBytes,
            'PDF saved successfully to ${result.path}',
          ),
        );
      } else {
        // User cancelled - return to previous state
        if (isEditMode) {
          emit(PdfEditorEditMode(currentPdfBytes));
        } else {
          emit(PdfEditorPreviewMode(currentPdfBytes));
        }
      }
    } catch (e) {
      emit(PdfError('Failed to save PDF: ${e.toString()}'));
    }
  }

  Future<void> printPdf() async {
    final currentPdfBytes = pdfBytes;
    if (currentPdfBytes == null) {
      emit(const PdfError('No PDF data available to print'));
      return;
    }

    emit(PdfPrinting());
    try {
      // Use printing package to show print dialog and print
      await Printing.layoutPdf(
        onLayout: (format) => currentPdfBytes,
        name: 'Vehicle Report',
        format: PdfPageFormat.legal,
      );

      // Return to previous state after print dialog
      if (isEditMode) {
        emit(PdfEditorEditMode(currentPdfBytes));
      } else {
        emit(PdfEditorPreviewMode(currentPdfBytes));
      }
    } catch (e) {
      emit(PdfError('Failed to print PDF: ${e.toString()}'));
    }
  }

  void returnToPreviewMode() {
    final currentBytes = pdfBytes;
    if (currentBytes != null) {
      emit(PdfEditorPreviewMode(currentBytes));
    }
  }

  bool get isEditMode => state is PdfEditorEditMode;
  bool get isPreviewMode => state is PdfEditorPreviewMode;
  bool get isSuccess => state is PdfSaveSuccess;
  bool get isPrinting => state is PdfPrinting;

  Uint8List? get pdfBytes {
    if (state is PdfEditorPreviewMode) {
      return (state as PdfEditorPreviewMode).pdfBytes;
    } else if (state is PdfEditorEditMode) {
      return (state as PdfEditorEditMode).pdfBytes;
    } else if (state is PdfSaveSuccess) {
      return (state as PdfSaveSuccess).pdfBytes;
    }
    return null;
  }
}
