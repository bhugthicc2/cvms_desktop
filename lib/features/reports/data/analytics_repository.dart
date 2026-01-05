import 'package:cvms_desktop/features/reports/models/chart_data_model.dart';

abstract class AnalyticsRepository {
  Future<List<ChartDataModel>> fetchVehicleDistribution();
  Future<List<ChartDataModel>> fetchTopViolations();
  Future<List<ChartDataModel>> fetchWeeklyTrend();
  Future<List<ChartDataModel>> fetchTopViolators();
}
