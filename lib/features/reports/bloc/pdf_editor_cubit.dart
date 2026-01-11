import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pdf_editor_state.dart';

class PdfEditorCubit extends Cubit<PdfEditorState> {
  PdfEditorCubit() : super(const PdfEditorPreviewMode());

  void toggleEditMode() {
    if (state is PdfEditorPreviewMode) {
      emit(const PdfEditorEditMode());
    } else {
      emit(const PdfEditorPreviewMode());
    }
  }

  bool get isEditMode => state is PdfEditorEditMode;
  bool get isPreviewMode => state is PdfEditorPreviewMode;
}
