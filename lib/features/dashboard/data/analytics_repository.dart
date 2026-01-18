import 'package:cvms_desktop/features/dashboard/data/chart_data_model.dart';

abstract class AnalyticsRepository {
  Future<List<ChartDataModel>> fetchVehicleDistribution();
  Future<List<ChartDataModel>> fetchTopViolations();
  Future<List<ChartDataModel>> fetchAllViolations();
  Future<List<ChartDataModel>> fetchWeeklyTrend();
  Future<List<ChartDataModel>> fetchMonthlyTrend();
  Future<List<ChartDataModel>> fetchYearlyTrend();
  Future<List<ChartDataModel>> fetchTopViolators();
  Future<List<ChartDataModel>> fetchAllViolators();
}
