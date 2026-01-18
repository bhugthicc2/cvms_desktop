import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';

class MockChartData {
  /// Mock violation distribution data for bar chart
  static List<ChartDataModel> getViolationDistribution() {
    return [
      ChartDataModel(category: 'Speeding', value: 15, date: null),
      ChartDataModel(category: 'Illegal Parking', value: 12, date: null),
      ChartDataModel(category: 'No Permit', value: 8, date: null),
      ChartDataModel(category: 'Wrong Lane', value: 5, date: null),
      ChartDataModel(category: 'Expired Registration', value: 2, date: null),
    ];
  }

  /// Mock vehicle logs data for line chart
  static List<ChartDataModel> getVehicleLogs() {
    final now = DateTime.now();
    return [
      ChartDataModel(
        category: _formatDate(now.subtract(const Duration(days: 30))),
        value: 25,
        date: now.subtract(const Duration(days: 30)),
      ),
      ChartDataModel(
        category: _formatDate(now.subtract(const Duration(days: 25))),
        value: 31,
        date: now.subtract(const Duration(days: 25)),
      ),
      ChartDataModel(
        category: _formatDate(now.subtract(const Duration(days: 20))),
        value: 19,
        date: now.subtract(const Duration(days: 20)),
      ),
      ChartDataModel(
        category: _formatDate(now.subtract(const Duration(days: 15))),
        value: 35,
        date: now.subtract(const Duration(days: 15)),
      ),
      ChartDataModel(
        category: _formatDate(now.subtract(const Duration(days: 10))),
        value: 43,
        date: now.subtract(const Duration(days: 10)),
      ),
      ChartDataModel(
        category: _formatDate(now.subtract(const Duration(days: 5))),
        value: 28,
        date: now.subtract(const Duration(days: 5)),
      ),
      ChartDataModel(category: _formatDate(now), value: 33, date: now),
    ];
  }

  /// Get mock data for specific vehicle
  static List<ChartDataModel> getViolationDistributionForVehicle(
    String vehicleId,
  ) {
    // In real implementation, this would filter by vehicleId
    return getViolationDistribution();
  }

  static List<ChartDataModel> getVehicleLogsForVehicle(String vehicleId) {
    // In real implementation, this would filter by vehicleId
    return getVehicleLogs();
  }

  /// Format date for chart display
  static String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }
}
