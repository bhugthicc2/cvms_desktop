part of 'pdf_editor_cubit.dart';

abstract class PdfEditorState extends Equatable {
  const PdfEditorState();

  @override
  List<Object> get props => [];
}

class PdfEditorInitial extends PdfEditorState {
  const PdfEditorInitial();
}

class PdfEditorPreviewMode extends PdfEditorState {
  const PdfEditorPreviewMode();

  @override
  List<Object> get props => [];
}

class PdfEditorEditMode extends PdfEditorState {
  const PdfEditorEditMode();

  @override
  List<Object> get props => [];
}
