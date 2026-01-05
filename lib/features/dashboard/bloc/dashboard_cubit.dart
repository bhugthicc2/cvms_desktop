import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_state.dart';
import '../data/analytics_repository.dart';

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
        dataSource.fetchWeeklyTrend(),
        dataSource.fetchTopViolators(),
      ]);
      if (isClosed) return;
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
      if (isClosed) return;
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
