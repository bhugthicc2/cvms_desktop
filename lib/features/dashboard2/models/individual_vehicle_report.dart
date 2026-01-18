import 'package:equatable/equatable.dart';
import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';

class IndividualVehicleReport extends Equatable {
  final String vehicleId;
  final String plateNumber;
  final String vehicleType;
  final String ownerName;
  final DateTime registeredDate;
  final DateTime? expiryDate;
  final int totalViolations;
  final int activeViolations;
  final int totalEntriesExits;
  final List<ChartDataModel> violationsByType;
  final List<ChartDataModel> vehicleLogs;

  const IndividualVehicleReport({
    required this.vehicleId,
    required this.plateNumber,
    required this.vehicleType,
    required this.ownerName,
    required this.registeredDate,
    this.expiryDate,
    required this.totalViolations,
    required this.activeViolations,
    required this.totalEntriesExits,
    required this.violationsByType,
    required this.vehicleLogs,
  });

  int get daysUntilExpiration {
    if (expiryDate == null) return 0;
    return expiryDate!.difference(DateTime.now()).inDays;
  }

  @override
  List<Object?> get props => [
    vehicleId,
    plateNumber,
    vehicleType,
    ownerName,
    registeredDate,
    expiryDate,
    totalViolations,
    activeViolations,
    totalEntriesExits,
    violationsByType,
    vehicleLogs,
  ];
}
