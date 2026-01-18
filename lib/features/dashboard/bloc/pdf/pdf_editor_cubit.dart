import 'dart:typed_data';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard/dashboard_state.dart';
import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/models/fleet_summary.dart';
import 'package:file_selector/file_selector.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:cvms_desktop/features/dashboard/controllers/pdf_report_builder.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pdf_editor_state.dart';

class PdfEditorCubit extends Cubit<PdfEditorState> {
  final FleetSummary? _fleetSummary;
  final List<ChartDataModel>? _vehicleDistribution;
  final List<ChartDataModel>? _yearLevelBreakdown;
  final List<ChartDataModel>? _cityBreakdown;
  final List<ChartDataModel>? _studentWithMostViolations;
  final List<ChartDataModel> _logsData;
  final TimeRange _selectedTimeRange;

  final Uint8List? _vehicleDistributionChartBytes;
  final Uint8List? _yearLevelBreakdownChartBytes;
  final Uint8List? _studentwithMostViolationChartBytes;
  final Uint8List? _cityBreakdownChartBytes;
  final Uint8List? _vehicleLogsDistributionChartBytes;
  final Uint8List? _violationDistributionPerCollegeChartBytes;
  final Uint8List? _top5ViolationByTypeChartBytes;
  final Uint8List? _fleetLogsChartBytes;

  bool _isChart = true;
  bool _isFitToWidth = true;

  PdfEditorCubit({
    FleetSummary? fleetSummary,
    List<ChartDataModel>? vehicleDistribution,
    List<ChartDataModel>? yearLevelBreakdown,
    List<ChartDataModel>? cityBreakdown,
    List<ChartDataModel>? studentWithMostViolations,
    List<ChartDataModel> logsData = const [],
    TimeRange selectedTimeRange = TimeRange.days7,
    Uint8List? vehicleDistributionChartBytes,
    Uint8List? yearLevelBreakdownChartBytes,
    Uint8List? studentwithMostViolationChartBytes,
    Uint8List? cityBreakdownChartBytes,
    Uint8List? vehicleLogsDistributionChartBytes,
    Uint8List? violationDistributionPerCollegeChartBytes,
    Uint8List? top5ViolationByTypeChartBytes,
    Uint8List? fleetLogsChartBytes,
  }) : _fleetSummary = fleetSummary,
       _vehicleDistribution = vehicleDistribution,
       _yearLevelBreakdown = yearLevelBreakdown,
       _cityBreakdown = cityBreakdown,
       _studentWithMostViolations = studentWithMostViolations,
       _logsData = logsData,
       _selectedTimeRange = selectedTimeRange,
       _vehicleDistributionChartBytes = vehicleDistributionChartBytes,
       _yearLevelBreakdownChartBytes = yearLevelBreakdownChartBytes,
       _studentwithMostViolationChartBytes = studentwithMostViolationChartBytes,
       _cityBreakdownChartBytes = cityBreakdownChartBytes,
       _vehicleLogsDistributionChartBytes = vehicleLogsDistributionChartBytes,
       _violationDistributionPerCollegeChartBytes =
           violationDistributionPerCollegeChartBytes,
       _top5ViolationByTypeChartBytes = top5ViolationByTypeChartBytes,
       _fleetLogsChartBytes = fleetLogsChartBytes,

       super(const PdfEditorInitial());

  void toggleEditMode() {
    if (state is PdfEditorPreviewMode) {
      final previewState = state as PdfEditorPreviewMode;
      emit(PdfEditorEditMode(previewState.pdfBytes));
    } else if (state is PdfEditorEditMode) {
      final editState = state as PdfEditorEditMode;
      emit(PdfEditorPreviewMode(editState.pdfBytes));
    }
  }

  void toggleChartTableMode() {
    _isChart = !_isChart;
    generatePdf();
  }

  void toggleFitMode() {
    _isFitToWidth = !_isFitToWidth;
  }

  bool get isChart => _isChart;
  bool get isFitToWidth => _isFitToWidth;

  Future<void> generatePdf() async {
    emit(PdfLoading());
    try {
      final bytes = await PdfReportBuilder.buildVehicleReport(
        isChart: _isChart,
        globalData: {
          'fleetSummary': _fleetSummary,
          'vehicleDistribution': _vehicleDistribution,
          'yearLevelBreakdown': _yearLevelBreakdown,
          'cityBreakdown': _cityBreakdown,
          'studentWithMostViolations': _studentWithMostViolations,
          'logsData': _logsData,
          'selectedTimeRange': _selectedTimeRange,
          'vehicleDistributionChartBytes': _vehicleDistributionChartBytes,
          'yearLevelBreakdownChartBytes': _yearLevelBreakdownChartBytes,
          'studentwithMostViolationChartBytes':
              _studentwithMostViolationChartBytes,
          'cityBreakdownChartBytes': _cityBreakdownChartBytes,
          'vehicleLogsDistributionChartBytes':
              _vehicleLogsDistributionChartBytes,
          'violationDistributionPerCollegeChartBytes':
              _violationDistributionPerCollegeChartBytes,
          'top5ViolationByTypeChartBytes': _top5ViolationByTypeChartBytes,
          'fleetLogsChartBytes': _fleetLogsChartBytes,
        },
      );
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
