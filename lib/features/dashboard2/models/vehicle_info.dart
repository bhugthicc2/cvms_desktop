import 'package:equatable/equatable.dart';

class VehicleInfo extends Equatable {
  final String vehicleModel;
  final String plateNumber;
  final String vehicleType;
  final String ownerName;
  final String department;
  final String status;
  final double mvpProgress;
  final DateTime? mvpRegisteredDate;
  final DateTime? mvpExpiryDate;

  const VehicleInfo({
    required this.vehicleModel,
    required this.plateNumber,
    required this.vehicleType,
    required this.ownerName,
    required this.department,
    required this.status,
    required this.mvpProgress,
    this.mvpRegisteredDate,
    this.mvpExpiryDate,
  });

  // Computed properties - pure data logic
  String get mvpStatusText {
    if (mvpExpiryDate == null) return 'Not Registered';
    final now = DateTime.now();
    if (now.isAfter(mvpExpiryDate!)) return 'Expired';
    if (now.isAfter(mvpExpiryDate!.subtract(const Duration(days: 30)))) {
      return 'Expiring Soon';
    }
    return 'Valid';
  }

  bool get isMvpExpired =>
      mvpExpiryDate != null && DateTime.now().isAfter(mvpExpiryDate!);
  bool get isMvpExpiringSoon =>
      mvpExpiryDate != null &&
      DateTime.now().isAfter(
        mvpExpiryDate!.subtract(const Duration(days: 30)),
      ) &&
      !isMvpExpired;

  @override
  List<Object?> get props => [
    vehicleModel,
    plateNumber,
    vehicleType,
    ownerName,
    department,
    status,
    mvpProgress,
    mvpRegisteredDate,
    mvpExpiryDate,
  ];
}
