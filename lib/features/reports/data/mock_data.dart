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

  static List<ChartDataModel> get studentViolationData => [
    ChartDataModel(category: 'Jesie Gapol', value: 200),
    ChartDataModel(category: 'Jessa Pagat', value: 92),
    ChartDataModel(category: 'Vincent Jay Lumacad', value: 30),
    ChartDataModel(category: 'Venus Medija', value: 140),
    ChartDataModel(category: 'Sarah Discaya', value: 15),
  ];

  static List<ChartDataModel> get cityBreakdownData => [
    ChartDataModel(category: 'Dipolog City', value: 200),
    ChartDataModel(category: 'Katipunan', value: 92),
    ChartDataModel(category: 'Polanco', value: 30),
    ChartDataModel(category: 'Sindangan', value: 140),
    ChartDataModel(category: 'Sergio Osmeña', value: 15),
  ];

  static List<ChartDataModel> get yearLevelBreakdownData => [
    ChartDataModel(category: '1st year', value: 200),
    ChartDataModel(category: 'Second year', value: 92),
    ChartDataModel(category: 'Third year', value: 30),
    ChartDataModel(category: 'Fourth year', value: 140),
    ChartDataModel(category: 'Junior HS', value: 15),
  ];

  // Mock vehicle data
  static final searchMockData = [
    'WXY-9012 - Toyota Avanza - Mila Hernandez',
    'ABC-1234 - Honda Civic - John Doe',
    'XYZ-5678 - Mitsubishi Montero - Jane Smith',
    'DEF-9012 - Ford Ranger - Robert Johnson',
    'GHI-3456 - Toyota Vios - Maria Santos',
    'JKL-7890 - Nissan Sentra - Carlos Reyes',
    'MNO-2345 - Isuzu D-Max - Anna Cruz',
    'PQR-6789 - Hyundai Accent - David Lee',
    'STU-0123 - Kia Picanto - Sarah Kim',
    'VWX-4567 - Mazda 3 - Michael Brown',
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
