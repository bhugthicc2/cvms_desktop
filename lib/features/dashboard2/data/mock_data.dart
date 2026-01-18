import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';

class MockDashboardData {
  static List<ChartDataModel> get violationDistributionPerCollege => [
    ChartDataModel(category: 'Engineering', value: 45),
    ChartDataModel(category: 'Business', value: 32),
    ChartDataModel(category: 'Arts', value: 28),
  ];

  static List<ChartDataModel> get vehicleLogsDistributionPerCollege => [
    ChartDataModel(category: 'Engineering', value: 45),
    ChartDataModel(category: 'Business', value: 32),
    ChartDataModel(category: 'Arts', value: 28),
  ];

  static List<ChartDataModel> get vehicleDistribution => [
    ChartDataModel(category: 'SCJE', value: 45),
    ChartDataModel(category: 'CCS', value: 32),
    ChartDataModel(category: 'CBA', value: 28),
    ChartDataModel(category: 'CAF-SOE', value: 25),
    ChartDataModel(category: 'LHS', value: 26),
  ];

  static List<ChartDataModel> get yearLevelBreakdown => [
    ChartDataModel(category: '1st Year', value: 35),
    ChartDataModel(category: '2nd Year', value: 40),
    ChartDataModel(category: '3rd Year', value: 38),
    ChartDataModel(category: '4th Year', value: 43),
  ];

  static List<ChartDataModel> get top5studentsWithMostViolations => [
    ChartDataModel(category: 'Student A', value: 12),
    ChartDataModel(category: 'Student B', value: 8),
    ChartDataModel(category: 'Student C', value: 6),
    ChartDataModel(category: 'Student D', value: 4),
    ChartDataModel(category: 'Student E', value: 3),
  ];

  static List<ChartDataModel> get cityBreakdown => [
    ChartDataModel(category: 'Zamboanga City', value: 89),
    ChartDataModel(category: 'Dipolog City', value: 34),
    ChartDataModel(category: 'Dapitan City', value: 21),
    ChartDataModel(category: 'Pagadian City', value: 18),
    ChartDataModel(category: 'Ipil', value: 12),
  ];

  static List<ChartDataModel> get violationTypeDistribution => [
    ChartDataModel(category: 'Reckless Driving', value: 23),
    ChartDataModel(category: 'Speeding', value: 18),
    ChartDataModel(category: 'Drunk Driving', value: 5),
  ];

  static List<ChartDataModel> get top5ViolationByType => [
    ChartDataModel(category: 'No Helmet', value: 25),
    ChartDataModel(category: 'No License', value: 18),
    ChartDataModel(category: 'Overloading', value: 15),
    ChartDataModel(category: 'No Parking', value: 12),
    ChartDataModel(category: 'Speeding', value: 8),
  ];

  static List<ChartDataModel> get fleetLogsData => [
    ChartDataModel(category: 'Mon', value: 45),
    ChartDataModel(category: 'Tue', value: 52),
    ChartDataModel(category: 'Wed', value: 38),
    ChartDataModel(category: 'Thu', value: 65),
    ChartDataModel(category: 'Fri', value: 72),
    ChartDataModel(category: 'Sat', value: 28),
    ChartDataModel(category: 'Sun', value: 15),
  ];
}
