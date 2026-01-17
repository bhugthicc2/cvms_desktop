import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_state.dart';
import '../data/analytics_repository.dart';
import '../models/chart_data_model.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final AnalyticsRepository dataSource;

  // Stream subscriptions
  StreamSubscription<List<ChartDataModel>>? _vehicleDistributionSubscription;
  StreamSubscription<List<ChartDataModel>>? _topViolationsSubscription;
  StreamSubscription<List<ChartDataModel>>? _weeklyTrendSubscription;
  StreamSubscription<List<ChartDataModel>>? _topViolatorsSubscription;

  DashboardCubit({required this.dataSource}) : super(const DashboardState());

  Future<void> loadAll() async {
    if (isClosed) return;
    emit(state.copyWith(loading: true, error: null));

    try {
      // Cancel existing subscriptions
      await _cancelAllSubscriptions();

      // Set up new subscriptions
      _vehicleDistributionSubscription = dataSource
          .fetchVehicleDistribution()
          .listen(
            (data) {
              if (!isClosed) {
                emit(state.copyWith(loading: false, vehicleDistribution: data));
              }
            },
            onError: (error) {
              if (!isClosed) {
                emit(state.copyWith(loading: false, error: error.toString()));
              }
            },
          );

      _topViolationsSubscription = dataSource.fetchTopViolations().listen(
        (data) {
          if (!isClosed) {
            emit(state.copyWith(loading: false, topViolations: data));
          }
        },
        onError: (error) {
          if (!isClosed) {
            emit(state.copyWith(loading: false, error: error.toString()));
          }
        },
      );

      _weeklyTrendSubscription = dataSource.fetchWeeklyTrend().listen(
        (data) {
          if (!isClosed) {
            emit(state.copyWith(loading: false, weeklyTrend: data));
          }
        },
        onError: (error) {
          if (!isClosed) {
            emit(state.copyWith(loading: false, error: error.toString()));
          }
        },
      );

      _topViolatorsSubscription = dataSource.fetchTopViolators().listen(
        (data) {
          if (!isClosed) {
            emit(state.copyWith(loading: false, topViolators: data));
          }
        },
        onError: (error) {
          if (!isClosed) {
            emit(state.copyWith(loading: false, error: error.toString()));
          }
        },
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
      // Cancel existing trend subscription
      await _weeklyTrendSubscription?.cancel();

      // Set up new trend subscription based on time range
      _weeklyTrendSubscription = _fetchTrendData(timeRange).listen(
        (data) {
          if (!isClosed) {
            emit(state.copyWith(loading: false, weeklyTrend: data));
          }
        },
        onError: (error) {
          if (!isClosed) {
            emit(state.copyWith(loading: false, error: error.toString()));
          }
        },
      );
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Stream<List<ChartDataModel>> _fetchTrendData(TimeRange timeRange) {
    switch (timeRange) {
      case TimeRange.days7:
        return dataSource.fetchWeeklyTrend();
      case TimeRange.month:
        return dataSource.fetchMonthlyTrend();
      case TimeRange.year:
        return dataSource.fetchYearlyTrend();
    }
  }

  Future<void> _cancelAllSubscriptions() async {
    await _vehicleDistributionSubscription?.cancel();
    await _topViolationsSubscription?.cancel();
    await _weeklyTrendSubscription?.cancel();
    await _topViolatorsSubscription?.cancel();

    _vehicleDistributionSubscription = null;
    _topViolationsSubscription = null;
    _weeklyTrendSubscription = null;
    _topViolatorsSubscription = null;
  }

  @override
  Future<void> close() async {
    await _cancelAllSubscriptions();
    return super.close();
  }
}
