import 'package:cvms_desktop/features/dashboard2/models/individual_vehicle_report.dart';
import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';

class MockIndividualData {
  static IndividualVehicleReport get sampleReport => IndividualVehicleReport(
    vehicleId: 'VH001',
    plateNumber: 'ABC-1234',
    vehicleType: 'Motorcycle',
    ownerName: 'Juan Dela Cruz',
    registeredDate: DateTime(2024, 1, 15),
    expiryDate: DateTime(2025, 1, 15),
    totalViolations: 8,
    activeViolations: 2,
    totalEntriesExits: 156,
    violationsByType: [
      ChartDataModel(category: 'No Helmet', value: 3),
      ChartDataModel(category: 'No License', value: 2),
      ChartDataModel(category: 'Overloading', value: 1),
      ChartDataModel(category: 'No Parking', value: 1),
      ChartDataModel(category: 'Speeding', value: 1),
    ],
    vehicleLogs: [
      ChartDataModel(category: 'Mon', value: 12),
      ChartDataModel(category: 'Tue', value: 8),
      ChartDataModel(category: 'Wed', value: 15),
      ChartDataModel(category: 'Thu', value: 6),
      ChartDataModel(category: 'Fri', value: 10),
      ChartDataModel(category: 'Sat', value: 4),
      ChartDataModel(category: 'Sun', value: 2),
    ],
  );

  static List<IndividualVehicleReport> get searchResults => [
    sampleReport,
    IndividualVehicleReport(
      vehicleId: 'VH002',
      plateNumber: 'XYZ-5678',
      vehicleType: 'Car',
      ownerName: 'Maria Santos',
      registeredDate: DateTime(2023, 6, 20),
      expiryDate: DateTime(2024, 6, 20),
      totalViolations: 3,
      activeViolations: 1,
      totalEntriesExits: 89,
      violationsByType: [
        ChartDataModel(category: 'No Parking', value: 2),
        ChartDataModel(category: 'Speeding', value: 1),
      ],
      vehicleLogs: [
        ChartDataModel(category: 'Mon', value: 8),
        ChartDataModel(category: 'Tue', value: 6),
        ChartDataModel(category: 'Wed', value: 9),
        ChartDataModel(category: 'Thu', value: 4),
        ChartDataModel(category: 'Fri', value: 7),
        ChartDataModel(category: 'Sat', value: 3),
        ChartDataModel(category: 'Sun', value: 1),
      ],
    ),
  ];
}
