import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';

class ReportMockData {
  // Individual violations bar
  static List<ChartDataModel> get violationTypeData => [
    ChartDataModel(category: 'Speeding', value: 100),
    ChartDataModel(category: 'Horn', value: 200),
    ChartDataModel(category: 'Muffler', value: 92),
    ChartDataModel(category: 'Over Speed', value: 30),
    ChartDataModel(category: 'Illegal Parking', value: 140),
    ChartDataModel(category: 'No License', value: 15),
  ];

  // Individual logs line
  static List<ChartDataModel> get vehicleLogsData => [
    ChartDataModel(category: 'Mon', value: 120, date: DateTime(2026, 1, 1)),
    ChartDataModel(category: 'Tue', value: 150, date: DateTime(2026, 1, 2)),
    ChartDataModel(category: 'Wed', value: 90, date: DateTime(2026, 1, 3)),
    ChartDataModel(category: 'Thu', value: 170, date: DateTime(2026, 1, 4)),
    ChartDataModel(category: 'Fri', value: 200, date: DateTime(2026, 1, 5)),
    ChartDataModel(category: 'Sat', value: 140, date: DateTime(2026, 1, 6)),
    ChartDataModel(category: 'Sun', value: 110, date: DateTime(2026, 1, 7)),
  ];

  // Donut fallback (if no real dept data)
  static List<ChartDataModel> get vehicleLogsCollegeData => [
    ChartDataModel(category: 'CAF-SOE', value: 245),
    ChartDataModel(category: 'CTE', value: 189),
    ChartDataModel(category: 'CCJ', value: 156),
    ChartDataModel(category: 'CON', value: 134),
    ChartDataModel(category: 'CME', value: 98),
    ChartDataModel(category: 'CAS', value: 87),
  ];
}
