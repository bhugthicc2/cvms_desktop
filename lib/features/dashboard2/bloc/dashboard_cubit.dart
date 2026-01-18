import 'dart:async';

import 'package:cvms_desktop/features/dashboard2/models/individual_vehicle_report.dart';
import 'package:cvms_desktop/features/dashboard2/repositories/dashboard_repositoty.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository repository; // Realtime implementation step 6
  StreamSubscription<int>? _logsSub; // Realtime implementation step 7
  DashboardCubit(
    this.repository, // Realtime implementation step 8
  ) : super(const DashboardState()) {
    _listenToVehicleLogs(); // Realtime implementation step 9
  }

  void _listenToVehicleLogs() {
    // Realtime implementation step 10

    _logsSub = repository.watchTotalEntriesExits().listen(
      (count) {
        // Realtime implementation step 11

        emit(
          // Realtime implementation step 12
          state.copyWith(
            // Realtime implementation step 13
            totalEntriesExits: count, // Realtime implementation step 14
          ),
        );
      },

      onError: (e) {
        // Realtime implementation step 15

        emit(
          state.copyWith(error: e.toString()),
        ); // Realtime implementation step 16
      },
    );
  }

  @override
  Future<void> close() {
    // Realtime implementation step 17

    _logsSub?.cancel();
    // Realtime implementation step 18

    return super.close();
    // Realtime implementation step 19
  }

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
