import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_state.dart';
import '../data/analytics_repository.dart';
import '../models/chart_data_model.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final AnalyticsRepository dataSource;

  DashboardCubit({required this.dataSource}) : super(const DashboardState());

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
