import 'package:cvms_desktop/features/dashboard2/models/vehicle_info.dart';
import 'package:flutter/material.dart';

class VehicleInfoService {
  // Pure data transformation logic
  static String getVehicleTypeIcon(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'two-wheeled':
        return 'assets/icons/vehicle_logs.png';
      case 'four-wheeled':
        return 'assets/icons/windows/vehicle.png';

      default:
        return 'assets/icons/vehicle_logs.png';
    }
  }

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.grey;
      case 'suspended':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  static Color getMvpStatusColor(VehicleInfo vehicle) {
    if (vehicle.isMvpExpired) return Colors.red;
    if (vehicle.isMvpExpiringSoon) return Colors.orange;
    return Colors.green;
  }

  static Color getMvpProgressColor(
    double progress,
    DateTime? registeredDate,
    DateTime? expiryDate,
  ) {
    if (expiryDate == null) return Colors.grey;
    if (DateTime.now().isAfter(expiryDate)) return Colors.red;
    if (progress < 0.3) return Colors.red;
    if (progress < 0.6) return Colors.orange;
    return Colors.green;
  }

  static String formatDate(DateTime? date, String prefix) {
    if (date == null) return '';
    return '$prefix${date.day}/${date.month}/${date.year}';
  }
}
