import 'package:cvms_desktop/features/report_and_analytics/models/chart_data_model.dart';

abstract class AnalyticsDataSource {
  Future<List<ChartDataModel>> fetchVehicleDistribution();
  Future<List<ChartDataModel>> fetchTopViolations();
  Future<List<ChartDataModel>> fetchMonthlyTrend();
  Future<List<ChartDataModel>> fetchTopViolators();
}
