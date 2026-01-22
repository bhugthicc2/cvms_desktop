import 'dart:async';
import 'package:cvms_desktop/features/dashboard/models/dashboard/time_grouping.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'individual_dashboard_state.dart';
import '../../../repositories/dashboard/individual_dashboard_repository.dart';

class IndividualDashboardCubit extends Cubit<IndividualDashboardState> {
  final IndividualDashboardRepository repository;
  final String vehicleId;

  StreamSubscription? _totalViolationsSub;
  StreamSubscription? _pendingViolationsSub;
  StreamSubscription? _vehicleLogsSub;
  StreamSubscription? _violationTypeSub;
  StreamSubscription? _vehicleLogsTrendSub;
  StreamSubscription? _violationTrendSub;

  StreamSubscription? _violationHistorySub;
  StreamSubscription? _recentLogsSub;

  IndividualDashboardCubit({required this.vehicleId, required this.repository})
    : super(
        IndividualDashboardState(
          vehicleLogstartDate: DateTime.now().subtract(const Duration(days: 6)),
          vehicleLogsEndDate: DateTime.now(),
          violationTrendStartDate: DateTime.now().subtract(
            const Duration(days: 6),
          ),
          violationTrendEndDate: DateTime.now(),
          grouping: TimeGrouping.day,
        ),
      ) {
    _init();
  }

  void _init() {
    emit(state.copyWith(loading: true));

    _totalViolationsSub = repository.watchTotalViolations(vehicleId).listen((
      count,
    ) {
      emit(state.copyWith(totalViolations: count));
    });

    _pendingViolationsSub = repository.watchPendingViolations(vehicleId).listen(
      (count) {
        emit(state.copyWith(totalPendingViolations: count));
      },
    );

    _vehicleLogsSub = repository.watchTotalVehicleLogs(vehicleId).listen((
      count,
    ) {
      emit(state.copyWith(totalVehicleLogs: count));
    });

    _violationTypeSub = repository.watchViolationByType(vehicleId).listen((
      data,
    ) {
      emit(state.copyWith(violationDistribution: data));
    });

    _watchVehicleLogsTrend(); //ISSUE: doesn't update on load
    _watchViolationTrend();
    _watchViolationHistory();
    _watchRecentVehicleLogs();

    // Set loading to false after initial data is loaded
    Future.delayed(const Duration(seconds: 1), () {
      emit(state.copyWith(loading: false));
    });
  }

  void _watchVehicleLogsTrend() {
    _vehicleLogsTrendSub?.cancel();

    _vehicleLogsTrendSub = repository
        .watchVehicleLogsTrend(
          vehicleId: vehicleId,
          start: state.vehicleLogstartDate,
          end: state.vehicleLogsEndDate,
          grouping: state.grouping,
        )
        .listen((data) {
          emit(state.copyWith(vehicleLogsTrend: data));
        });
  }

  void _watchViolationTrend() {
    _violationTrendSub?.cancel();

    _violationTrendSub = repository
        .watchViolationTrend(
          vehicleId: vehicleId,
          start: state.violationTrendStartDate,
          end: state.violationTrendEndDate,
          grouping: state.grouping,
        )
        .listen((data) {
          emit(state.copyWith(violationTrend: data));
        });
  }

  void updateVehicleLogsDateFilter({
    required DateTime start,
    required DateTime end,
    required TimeGrouping grouping,
    String? vehicleLogsCurrentTimeRange,
  }) {
    emit(
      state.copyWith(
        vehicleLogstartDate: start,
        vehicleLogsEndDate: end,
        grouping: grouping,
        vehicleLogsCurrentTimeRange: vehicleLogsCurrentTimeRange,
      ),
    );

    _watchVehicleLogsTrend();
  }

  void updateViolationDateFilter({
    required DateTime start,
    required DateTime end,
    required TimeGrouping grouping,
    String? violationTrendCurrentTimeRange,
  }) {
    emit(
      state.copyWith(
        violationTrendStartDate: start,
        violationTrendEndDate: end,
        grouping: grouping,
        violationTrendCurrentTimeRange: violationTrendCurrentTimeRange,
      ),
    );

    _watchViolationTrend();
  }

  //VIOLATION HISTORY
  void _watchViolationHistory() {
    _violationHistorySub = repository
        .watchViolationHistory(vehicleId: vehicleId)
        .listen((entries) {
          emit(state.copyWith(violationHistory: entries));
        });
  }

  //RECENT LOGS
  void _watchRecentVehicleLogs() {
    _recentLogsSub = repository
        .watchRecentVehicleLogs(vehicleId: vehicleId)
        .listen((logs) {
          emit(state.copyWith(recentLogs: logs));
        });
  }

  @override
  Future<void> close() {
    _totalViolationsSub?.cancel();
    _pendingViolationsSub?.cancel();
    _vehicleLogsSub?.cancel();
    _violationTypeSub?.cancel();
    _vehicleLogsTrendSub?.cancel();
    _violationHistorySub?.cancel();
    _recentLogsSub?.cancel();
    _violationTrendSub?.cancel();
    return super.close();
  }
}
