import 'package:flutter_bloc/flutter_bloc.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit() : super(const ReportsState());

  void showPdfPreview() {
    if (isClosed) return;
    emit(state.copyWith(showPdfPreview: true));
  }

  void hidePdfPreview() {
    if (isClosed) return;
    emit(state.copyWith(showPdfPreview: false));
  }

  void togglePdfPreview() {
    if (isClosed) return;
    emit(state.copyWith(showPdfPreview: !state.showPdfPreview));
  }

  void setLoading(bool loading) {
    if (isClosed) return;
    emit(state.copyWith(loading: loading));
  }

  void setError(String? error) {
    if (isClosed) return;
    emit(state.copyWith(error: error));
  }

  void clearError() {
    if (isClosed) return;
    emit(state.copyWith(error: null));
  }
}
