import 'dart:async';

import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard2/models/individual_vehicle_report.dart';
import 'package:cvms_desktop/features/dashboard2/repositories/dashboard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository repository; // Realtime implementation step 6
  StreamSubscription<int>? _logsSub; // Realtime implementation step 7
  StreamSubscription<int>? _vehicleSub;
  StreamSubscription<int>? _violationSub;
  StreamSubscription<int>?
  _totalPendingViolationSub; //realtime data retrieval based on collection field step 9
  StreamSubscription<List<ChartDataModel>>?
  _vehicleDistributionSub; //real time grouped aggregation impl step 7
  DashboardCubit(
    this.repository, // Realtime implementation step 8
  ) : super(const DashboardState()) {
    _listenToVehicleLogs(); // Realtime implementation step 9
    _listenToVehicles();
    _listenToViolations();
    _listenToTotalPendingViolations(); //realtime data retrieval based on collection field step 10
    _listenToVehicleDistribution(); //real time grouped aggregation impl step 8
  }
  void _listenToVehicles() {
    _vehicleSub = repository.watchTotalVehicles().listen(
      (count) {
        emit(state.copyWith(totalVehicles: count));
      },

      onError: (e) {
        emit(state.copyWith(error: e.toString()));
      },
    );
  }

  //real time grouped aggregation impl step 9
  void _listenToVehicleDistribution() {
    _vehicleDistributionSub = repository
        .watchVehicleDistributionByDepartment()
        .listen(
          (data) {
            emit(state.copyWith(vehicleDistribution: data));
          },
          onError: (e) {
            emit(state.copyWith(error: e.toString()));
          },
        );
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

  void _listenToViolations() {
    _violationSub = repository.watchTotalViolations().listen(
      (count) {
        emit(state.copyWith(totalViolations: count));
      },
      onError: (e) {
        emit(state.copyWith(error: e.toString()));
      },
    );
  }

  //realtime data retrieval based on collection field step 11
  void _listenToTotalPendingViolations() {
    _totalPendingViolationSub = repository.watchTotalPendingViolations().listen(
      (count) {
        emit(state.copyWith(totalPendingViolations: count));
      },
      onError: (e) {
        emit(state.copyWith(error: e.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    // Realtime implementation step 17

    _logsSub?.cancel();
    // Realtime implementation step 18
    _vehicleSub?.cancel();
    _violationSub?.cancel();
    _totalPendingViolationSub
        ?.cancel(); //realtime data retrieval based on collection field step 12
    _vehicleDistributionSub
        ?.cancel(); //real time grouped aggregation impl step 10

    return super.close();
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
