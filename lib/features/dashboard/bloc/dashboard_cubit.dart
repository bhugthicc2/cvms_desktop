import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_state.dart';
import '../data/analytics_repository.dart';
import '../models/chart_data_model.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final AnalyticsRepository dataSource;

  DashboardCubit({required this.dataSource}) : super(const DashboardState());

  // View mode methods
  void showOverview() =>
      emit(state.copyWith(viewMode: DashboardViewMode.overview));
  void showEnteredVehicles() =>
      emit(state.copyWith(viewMode: DashboardViewMode.enteredVehicles));
  void showExitedVehicles() =>
      emit(state.copyWith(viewMode: DashboardViewMode.exitedVehicles));
  void showViolations() =>
      emit(state.copyWith(viewMode: DashboardViewMode.violations));
  void showAllVehicles() =>
      emit(state.copyWith(viewMode: DashboardViewMode.allVehicles));
  void showVehicleDistribution() =>
      emit(state.copyWith(viewMode: DashboardViewMode.vehicleDistribution));
  void showVehicleLogsTrend() =>
      emit(state.copyWith(viewMode: DashboardViewMode.vehicleLogsTrend));
  void showTopViolations() {
    emit(state.copyWith(viewMode: DashboardViewMode.topViolations));
    loadAllViolations();
  }

  void showTopViolators() {
    emit(state.copyWith(viewMode: DashboardViewMode.topViolators));
    loadAllViolators();
  }

  Future<void> loadAll() async {
    if (isClosed) return;
    emit(state.copyWith(loading: true, error: null));

    try {
      final results = await Future.wait([
        dataSource.fetchVehicleDistribution(),
        dataSource.fetchTopViolations(),
        _fetchTrendData(state.selectedTimeRange),
        dataSource.fetchTopViolators(),
      ]);
      if (isClosed) return;
      emit(
        state.copyWith(
          loading: false,
          vehicleDistribution: results[0],
          topViolations: results[1],
          weeklyTrend: results[2],
          topViolators: results[3],
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> loadAllViolations() async {
    if (isClosed) return;
    emit(state.copyWith(loading: true, error: null));

    try {
      final allViolations = await dataSource.fetchAllViolations();
      if (isClosed) return;
      emit(state.copyWith(loading: false, allViolations: allViolations));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> loadAllViolators() async {
    if (isClosed) return;
    emit(state.copyWith(loading: true, error: null));

    try {
      final allViolators = await dataSource.fetchAllViolators();
      if (isClosed) return;
      emit(state.copyWith(loading: false, allViolators: allViolators));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> changeTimeRange(TimeRange timeRange) async {
    if (state.selectedTimeRange == timeRange) return;

    emit(state.copyWith(selectedTimeRange: timeRange, loading: true));

    try {
      final trendData = await _fetchTrendData(timeRange);
      if (isClosed) return;
      emit(state.copyWith(loading: false, weeklyTrend: trendData));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<List<ChartDataModel>> _fetchTrendData(TimeRange timeRange) async {
    switch (timeRange) {
      case TimeRange.days7:
        return await dataSource.fetchWeeklyTrend();
      case TimeRange.month:
        return await dataSource.fetchMonthlyTrend();
      case TimeRange.year:
        return await dataSource.fetchYearlyTrend();
    }
  }
}
