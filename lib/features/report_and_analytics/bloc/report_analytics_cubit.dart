import 'package:flutter_bloc/flutter_bloc.dart';
import 'report_analytics_state.dart';
import '../data/analytics_data_source.dart';

class ReportAnalyticsCubit extends Cubit<ReportAnalyticsState> {
  final AnalyticsDataSource dataSource;

  ReportAnalyticsCubit({required this.dataSource})
    : super(const ReportAnalyticsState());

  Future<void> loadAll() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final results = await Future.wait([
        dataSource.fetchVehicleDistribution(),
        dataSource.fetchTopViolations(),
        dataSource.fetchMonthlyTrend(),
        dataSource.fetchTopViolators(),
      ]);
      emit(
        state.copyWith(
          loading: false,
          vehicleDistribution: results[0],
          topViolations: results[1],
          monthlyTrend: results[2],
          topViolators: results[3],
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
