part of 'pdf_editor_cubit.dart';

abstract class PdfEditorState extends Equatable {
  const PdfEditorState();

  @override
  List<Object?> get props => [];
}

class PdfEditorInitial extends PdfEditorState {
  const PdfEditorInitial();
}

class PdfLoading extends PdfEditorState {}

class PdfSaving extends PdfEditorState {}

class PdfPrinting extends PdfEditorState {}

class PdfSaveSuccess extends PdfModeState {
  final String message;
  const PdfSaveSuccess(super.pdfBytes, this.message);

  @override
  List<Object?> get props => [pdfBytes, message];
}

class PdfError extends PdfEditorState {
  final String message;
  const PdfError(this.message);

  @override
  List<Object> get props => [message];
}

abstract class PdfModeState extends PdfEditorState {
  final Uint8List? pdfBytes;
  const PdfModeState(this.pdfBytes);

  @override
  List<Object?> get props => [pdfBytes];
}

class PdfEditorPreviewMode extends PdfModeState {
  const PdfEditorPreviewMode(super.pdfBytes);
}

class PdfEditorEditMode extends PdfModeState {
  const PdfEditorEditMode(super.pdfBytes);
}
