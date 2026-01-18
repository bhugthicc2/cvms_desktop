import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardState());

  // View mode navigation
  void showGlobalDashboard() {
    emit(state.copyWith(viewMode: DashboardViewMode.global));
  }

  void showIndividualReport() {
    emit(state.copyWith(viewMode: DashboardViewMode.individual));
  }

  void showPdfPreview() {
    emit(state.copyWith(viewMode: DashboardViewMode.pdfPreview));
  }

  void backToGlobal() {
    showGlobalDashboard();
  }

  // Error handling
  void clearError() {
    emit(state.copyWith(error: null));
  }

  void setError(String error) {
    emit(state.copyWith(error: error));
  }

  // Loading states
  void setLoading(bool loading) {
    emit(state.copyWith(loading: loading));
  }
}
