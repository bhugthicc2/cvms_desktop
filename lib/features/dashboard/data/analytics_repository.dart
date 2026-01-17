import 'dart:async';
import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';

abstract class AnalyticsRepository {
  Stream<List<ChartDataModel>> fetchVehicleDistribution();
  Stream<List<ChartDataModel>> fetchTopViolations();
  Stream<List<ChartDataModel>> fetchWeeklyTrend();
  Stream<List<ChartDataModel>> fetchMonthlyTrend();
  Stream<List<ChartDataModel>> fetchYearlyTrend();
  Stream<List<ChartDataModel>> fetchTopViolators();
}
