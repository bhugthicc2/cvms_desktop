import 'dart:math';
import 'analytics_data_source.dart';
import '../models/chart_data_model.dart';

class MockAnalyticsDataSource implements AnalyticsDataSource {
  @override
  Future<List<ChartDataModel>> fetchVehicleDistribution() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      ChartDataModel(category: 'CCS', value: 28),
      ChartDataModel(category: 'CTED', value: 42),
      ChartDataModel(category: 'CAF-SOE', value: 22),
      ChartDataModel(category: 'SCJE', value: 15),
    ];
  }

  @override
  Future<List<ChartDataModel>> fetchTopViolations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      ChartDataModel(category: 'Improper parking', value: 40),
      ChartDataModel(category: 'No MVP Sticker', value: 25),
      ChartDataModel(category: 'No helmet', value: 15),
      ChartDataModel(category: 'Loud pipe/muffler', value: 20),
    ];
  }

  @override
  Future<List<ChartDataModel>> fetchMonthlyTrend() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final random = Random();
    final months = List.generate(
      12,
      (i) => DateTime(DateTime.now().year, i + 1, 1),
    );
    return months
        .map(
          (m) => ChartDataModel(
            category: m.month.toString(),
            value: (15 + (m.month * 2) + random.nextInt(10) - 5).toDouble(),
            date: m,
          ),
        )
        .toList();
  }

  @override
  Future<List<ChartDataModel>> fetchTopViolators() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      ChartDataModel(category: 'Vincent Jay Belonghilot', value: 40),
      ChartDataModel(category: 'Jesie Gapol', value: 10),
      ChartDataModel(category: 'Jessa Pagat', value: 20),
      ChartDataModel(category: 'Venus Medija', value: 30),
    ];
  }
}
