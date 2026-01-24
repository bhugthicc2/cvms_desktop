import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/individual_vehicle_info.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/time_grouping.dart';
import 'package:cvms_desktop/features/dashboard/models/report/date_range.dart';
import 'package:cvms_desktop/features/dashboard/repositories/dashboard/global_dashboard_repository.dart';
import 'package:cvms_desktop/features/dashboard/repositories/dashboard/vehicle_search_repository.dart';
import 'package:cvms_desktop/features/dashboard/services/vehicle_search_service.dart';
import 'package:cvms_desktop/features/dashboard/use_cases/pdf/global_pdf_export_usecase.dart';
import 'package:cvms_desktop/features/dashboard/use_cases/pdf/individual_pdf_export_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'global_dashboard_state.dart';

class GlobalDashboardCubit extends Cubit<GlobalDashboardState> {
  // ----GLOBAL-----
  final GlobalDashboardRepository repository; // Realtime implementation step 6
  StreamSubscription<int>? _logsSub; // Realtime implementation step 7
  StreamSubscription<int>? _vehicleSub;
  StreamSubscription<int>? _violationSub;
  StreamSubscription<int>?
  _totalPendingViolationSub; //realtime data retrieval based on collection field step 9
  StreamSubscription<List<ChartDataModel>>?
  _vehicleDistributionSub; //real time grouped aggregation impl step 7
  StreamSubscription<List<ChartDataModel>>? _yearLevelSub; // step 14
  StreamSubscription<List<ChartDataModel>>? _topStudentsSub; // step 11
  StreamSubscription<List<ChartDataModel>>? _cityBreakdownSub; // step 13
  StreamSubscription<List<ChartDataModel>>? _vehicleLogsByCollegeSub; // step 11
  StreamSubscription<List<ChartDataModel>>? _violationByCollegeSub; // step 11
  StreamSubscription<List<ChartDataModel>>? _violationTypeSub; // step 14
  StreamSubscription<List<ChartDataModel>>? _fleetLogsSub;
  StreamSubscription<List<ChartDataModel>>? _violationTrendSub;
  StreamSubscription<List<ChartDataModel>>? _allViolationsByStudentsSub;

  // Initialization tracking
  //for loafing state
  int _readyStreams = 0;
  static const int _requiredStreams = 11; // Total number of streams to wait for

  //vehicle id
  final String? currentVehicleId;

  //pdf
  final GlobalPdfExportUseCase globalPdfExportUseCase;
  final IndividualPdfExportUseCase individualPdfExportUseCase;

  GlobalDashboardCubit(
    this.currentVehicleId,
    this.repository, // Realtime implementation step 8
    this.globalPdfExportUseCase,
    this.individualPdfExportUseCase,
  ) : super(const GlobalDashboardState()) {
    // ----GLOBAL-----
    _listenToVehicleLogs(); // Realtime implementation step 9
    _listenToVehicles();
    _listenToViolations();
    _listenToTotalPendingViolations(); //realtime data retrieval based on collection field step 10
    _listenToVehicleDistribution(); //real time grouped aggregation impl step 8
    _listenToYearLevelBreakdown(); // step 15
    _listenToTopStudents(); // step 12
    _listenToCityBreakdown(); // step 14
    _listenToVehicleLogsDistributionPerCollege(); // step 12
    _listenToViolationDistributionPerCollege(); // step 12
    _listenToViolationTypeDistribution(); // step 15
    _listenToAllViolationByStudent();
  }

  // ----GLOBAL-----
  void _markReady() {
    _readyStreams++;
    if (_readyStreams == _requiredStreams) {
      emit(state.copyWith(initialized: true));
    }
  } //for loading state

  void _listenToVehicles() {
    _vehicleSub = repository.watchTotalVehicles().listen(
      // ignore: avoid_types_as_parameter_names
      (count) {
        emit(state.copyWith(totalVehicles: count));
        _markReady();
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
            _markReady();
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
        _markReady();
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
        _markReady();
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
        _markReady();
      },
      onError: (e) {
        emit(state.copyWith(error: e.toString()));
      },
    );
  }

  // realtime implementation step 16:
  // Updates year-level chart data whenever vehicles change
  void _listenToYearLevelBreakdown() {
    _yearLevelSub = repository.watchYearLevelBreakdown().listen((data) {
      emit(
        state.copyWith(
          yearLevelBreakdown: data, // step 16
        ),
      );
      _markReady();
    });
  }

  // realtime implementation step 13:
  // Updates top students chart when violations or vehicles change
  void _listenToTopStudents() {
    _topStudentsSub = repository
        .watchTopStudentsWithMostViolations(limit: 5)
        .listen((data) {
          emit(state.copyWith(topStudentsWithMostViolations: data));
          _markReady();
        });
  }

  void _listenToAllViolationByStudent() {
    _allViolationsByStudentsSub = repository
        .watchAllTopStudentsWithMostViolations()
        .listen((data) {
          emit(state.copyWith(allStudentsWithMostViolations: data));
          _markReady();
        });
  }

  // realtime implementation step 15:
  // Emits updated city breakdown whenever vehicles change
  void _listenToCityBreakdown() {
    _cityBreakdownSub = repository.watchCityBreakdown().listen((data) {
      emit(
        state.copyWith(
          cityBreakdown: data, // step 16
        ),
      );
      _markReady();
    });
  }

  // realtime implementation step 13:
  // Updates vehicle logs distribution per college in real time
  void _listenToVehicleLogsDistributionPerCollege() {
    _vehicleLogsByCollegeSub = repository
        .watchVehicleLogsDistributionPerCollege(limit: 5)
        .listen((data) {
          emit(
            state.copyWith(
              vehicleLogsDistributionPerCollege: data, // step 14
            ),
          );
          _markReady();
        });
  }

  // realtime implementation step 13:
  // Updates violation distribution per college in real time
  void _listenToViolationDistributionPerCollege() {
    _violationByCollegeSub = repository
        .watchViolationDistributionPerCollege(limit: 5)
        .listen((data) {
          emit(
            state.copyWith(
              violationDistributionPerCollege: data, // step 14
            ),
          );
          _markReady();
        });
  }

  // realtime implementation step 16:
  // Updates violation type distribution in real time
  void _listenToViolationTypeDistribution() {
    _violationTypeSub = repository
        .watchViolationTypeDistribution(limit: 5)
        .listen((data) {
          emit(
            state.copyWith(
              violationTypeDistribution: data, // step 17
            ),
          );
          _markReady();
        });
  }

  void watchFleetLogsTrend({
    required DateTime start, // step 4: start date
    required DateTime end, // step 5: end date
    required TimeGrouping grouping, // step 6: day/week/month/year
  }) {
    _fleetLogsSub?.cancel(); // step 7: prevent multiple listeners

    emit(state.copyWith(loading: true)); // step 8: notify UI loading

    _fleetLogsSub = repository
        .watchFleetLogsTrend(
          start: start, // step 9
          end: end, // step 10
          grouping: grouping, // step 11
        )
        .listen(
          (data) {
            emit(
              state.copyWith(
                fleetLogsData: data, // step 12: update chart
                loading: false, // step 13: stop loading
              ),
            );
            _markReady();
          },
          onError: (e) {
            emit(
              state.copyWith(
                error: e.toString(), // step 14: capture error
                loading: false, // step 15
              ),
            );
          },
        );
  }

  void watchViolationTrend({
    required DateTime start,
    required DateTime end,
    required TimeGrouping grouping,
  }) {
    _violationTrendSub?.cancel(); // prevent duplicate listeners

    emit(state.copyWith(loading: true));

    _violationTrendSub = repository
        .watchViolationsTrend(start: start, end: end, grouping: grouping)
        .listen(
          (data) {
            emit(state.copyWith(violationTrendData: data, loading: false));
          },
          onError: (e) {
            emit(state.copyWith(error: e.toString(), loading: false));
          },
        );
  }

  //for individual report nav
  Future<void> showIndividualReport(String vehicleId) async {
    emit(state.copyWith(loading: true));

    final service = VehicleSearchService(
      VehicleSearchRepository(FirebaseFirestore.instance),
    );

    final vehicleInfo = await service.getIndividualReport(vehicleId);

    if (vehicleInfo == null) {
      emit(state.copyWith(loading: false));
      return;
    }

    emit(
      state.copyWith(
        selectedVehicle: vehicleInfo, // STATIC INFO ONLY
        viewMode: DashboardViewMode.individual,
        loading: false,
      ),
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
    _yearLevelSub?.cancel(); // step 17
    _topStudentsSub?.cancel(); // step 14
    _cityBreakdownSub?.cancel(); // step 17
    _vehicleLogsByCollegeSub?.cancel(); // step 14
    _violationByCollegeSub?.cancel(); // step 15
    _violationTypeSub?.cancel(); // step 18
    _fleetLogsSub?.cancel();
    _violationTrendSub?.cancel();
    _allViolationsByStudentsSub?.cancel();
    return super.close();
  }

  // View mode navigation
  void showGlobalDashboard() {
    emit(state.copyWith(viewMode: DashboardViewMode.global));
  }

  Future<void> generateReport({required DateRange range}) async {
    emit(state.copyWith(loading: true));

    try {
      Uint8List pdfBytes;

      if (state.viewMode == DashboardViewMode.global) {
        pdfBytes = await globalPdfExportUseCase.generatePdfReport(range: range);
      } else if (state.viewMode == DashboardViewMode.individual) {
        if (state.selectedVehicle == null) {
          throw StateError('No vehicle selected for individual report');
        }

        pdfBytes = await individualPdfExportUseCase.export(
          vehicleId: state.selectedVehicle!.vehicleId,
          range: range,
        );
      } else {
        throw StateError('Invalid dashboard view mode for export');
      }

      emit(
        state.copyWith(
          pdfBytes: pdfBytes,
          previousViewMode: state.viewMode,
          viewMode: DashboardViewMode.pdfPreview,
          loading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void updateTimeRange(String timeRange) {
    emit(state.copyWith(currentTimeRange: timeRange));
  }

  void updateVehicleLogsTimeRange(String timeRange) {
    emit(state.copyWith(vehicleLogsTimeRange: timeRange));
  }

  void updateViolationTrendTimeRange(String timeRange) {
    emit(state.copyWith(violationTrendTimeRange: timeRange));
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

  // Violation view navigation
  void showViolationView() {
    emit(
      state.copyWith(
        viewMode: DashboardViewMode.violationView,
        previousViewMode: state.viewMode,
      ),
    );
  }

  // Pending Violation view navigation
  void showPendingViolationView() {
    emit(
      state.copyWith(
        viewMode: DashboardViewMode.pendingViolationView,
        previousViewMode: state.viewMode,
      ),
    );
  }

  // Vehicles view navigation
  void showAllVehiclesView() {
    emit(
      state.copyWith(
        viewMode: DashboardViewMode.allVehiclesView,
        previousViewMode: state.viewMode,
      ),
    );
  }

  // Vehicle Logs view navigation
  void showVehicleLogsView() {
    emit(
      state.copyWith(
        viewMode: DashboardViewMode.vehicleLogsView,
        previousViewMode: state.viewMode,
      ),
    );
  }

  // Vehicle by Department/College View
  void showVehicleByCollegeView() {
    emit(
      state.copyWith(
        viewMode: DashboardViewMode.vehicleByCollegeView,
        previousViewMode: state.viewMode,
      ),
    );
  }

  // Vehicle by Year Level View
  void showVehicleByYearLevelView() {
    emit(
      state.copyWith(
        viewMode: DashboardViewMode.vehiclesByYearLevel,
        previousViewMode: state.viewMode,
      ),
    );
  }

  // Violation by Student View
  void showViolationByStudentView() {
    emit(
      state.copyWith(
        viewMode: DashboardViewMode.violationsByStudent,
        previousViewMode: state.viewMode,
      ),
    );
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
