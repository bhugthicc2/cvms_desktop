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
  StreamSubscription? _violationHistorySub;
  StreamSubscription? _recentLogsSub;

  IndividualDashboardCubit({required this.vehicleId, required this.repository})
    : super(
        IndividualDashboardState(
          startDate: DateTime.now().subtract(const Duration(days: 6)),
          endDate: DateTime.now(),
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

    _watchVehicleLogsTrend();
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
          start: state.startDate,
          end: state.endDate,
          grouping: state.grouping,
        )
        .listen((data) {
          emit(state.copyWith(vehicleLogsTrend: data));
        });
  }

  // DATE FILTER UPDATE (PUBLIC API)
  void updateDateFilter({
    required DateTime start,
    required DateTime end,
    required TimeGrouping grouping,
  }) {
    emit(state.copyWith(startDate: start, endDate: end, grouping: grouping));

    // rebind ONLY the trend stream
    _watchVehicleLogsTrend();
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
    return super.close();
  }
}
