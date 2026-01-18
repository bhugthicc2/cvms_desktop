import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'mvp_progress_calculator.dart';

class VehicleInfoHelpers {
  static Color getMvpProgressColor(
    double progress,
    DateTime? registeredDate,
    DateTime? expiryDate,
  ) {
    final colorName = MvpProgressCalculator.getProgressColor(
      progress: progress,
      registeredDate: registeredDate,
      expiryDate: expiryDate,
    );
    switch (colorName) {
      case 'red':
        return Colors.redAccent;
      case 'orange':
        return Colors.green;
      case 'blue':
        return Colors.orangeAccent;
      default:
        return Colors.blueAccent;
    }
  }

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'onsite':
        return Colors.green;
      case 'offsite':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  static String getVehicleTypeIcon(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'two-wheeled':
        return 'assets/images/two_wheeled.png';
      case 'four-wheeled':
        return 'assets/images/four_wheeled.png';
      default:
        return 'assets/images/two_wheeled.png';
    }
  }

  static String formatDate(DateTime? date, String prefix) {
    if (date == null) return '${prefix}Not set';
    final formatter = DateFormat('MMMM d, y');
    return '$prefix${formatter.format(date)}';
  }

  static String getMvpStatusText(
    DateTime? registeredDate,
    DateTime? expiryDate,
  ) {
    return MvpProgressCalculator.getMvpStatus(
      registeredDate: registeredDate,
      expiryDate: expiryDate,
    );
  }

  static Color getMvpStatusColor(
    DateTime? registeredDate,
    DateTime? expiryDate,
  ) {
    final status = getMvpStatusText(registeredDate, expiryDate);
    switch (status) {
      case 'Valid':
        return AppColors.chartGreen;
      case 'Expired':
        return Colors.redAccent;
      case 'Not Started':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
