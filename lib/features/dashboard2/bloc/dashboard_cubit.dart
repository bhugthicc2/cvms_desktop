import 'package:cvms_desktop/features/dashboard2/models/individual_vehicle_report.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardState());

  // View mode navigation
  void showGlobalDashboard() {
    emit(state.copyWith(viewMode: DashboardViewMode.global));
  }

  void showIndividualReport({required IndividualVehicleReport vehicle}) {
    emit(
      state.copyWith(
        viewMode: DashboardViewMode.individual,
        selectedVehicle: vehicle,
      ),
    );
  }

  void showPdfPreview() {
    emit(
      state.copyWith(
        viewMode: DashboardViewMode.pdfPreview,
        previousViewMode: state.viewMode,
      ),
    );
  }

  void backToPreviousView() {
    final previousView = state.previousViewMode;
    if (previousView != null) {
      emit(state.copyWith(viewMode: previousView));
    } else {
      // Fallback to global if no previous view
      showGlobalDashboard();
    }
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
