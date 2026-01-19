// DASHBOARD SEARCH FUNCTIONALITY STEP 3
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/core/utils/registration_expiry_utils.dart';

class IndividualVehicleReport {
  final String plateNumber;
  final String ownerName;
  final String vehicleType;
  final String department;
  final String status;
  final String vehicleModel;
  final DateTime? createdAt;
  final DateTime? expiryDate;

  // MVP Progress fields
  final double mvpProgress;
  final DateTime? mvpRegisteredDate;
  final DateTime? mvpExpiryDate;
  final String mvpStatusText;

  IndividualVehicleReport({
    required this.plateNumber,
    required this.ownerName,
    required this.vehicleType,
    this.department = '',
    this.status = '',
    this.vehicleModel = '',
    this.createdAt,
    this.expiryDate,
    this.mvpProgress = 0.0,
    this.mvpRegisteredDate,
    this.mvpExpiryDate,
    this.mvpStatusText = 'Not Set',
  });

  factory IndividualVehicleReport.fromFirestore(Map<String, dynamic> data) {
    final createdAt =
        data['createdAt'] != null
            ? (data['createdAt'] as Timestamp).toDate()
            : null;
    // Calculate expiry date using RegistrationExpiryUtils
    final expiryDate =
        createdAt != null
            ? RegistrationExpiryUtils.computeExpiryDate(createdAt)
            : null;

    // Calculate MVP progress
    double mvpProgress = 0.0;
    String mvpStatusText = 'Not Set';

    if (createdAt != null && expiryDate != null) {
      final now = DateTime.now();
      if (now.isBefore(createdAt)) {
        mvpStatusText = 'Not Started';
      } else if (now.isAfter(expiryDate) || now.isAtSameMomentAs(expiryDate)) {
        mvpStatusText = 'Expired';
        mvpProgress = 1.0;
      } else {
        mvpStatusText = 'Valid';
        final totalDuration = expiryDate.difference(createdAt);
        final elapsedDuration = now.difference(createdAt);
        mvpProgress = (elapsedDuration.inMilliseconds /
                totalDuration.inMilliseconds)
            .clamp(0.0, 1.0);
      }
    }

    return IndividualVehicleReport(
      plateNumber: data['plateNumber'] ?? '',
      ownerName: data['ownerName'] ?? '',
      vehicleType: data['vehicleType'] ?? '',
      department: data['department'] ?? '',
      status: data['status'] ?? '',
      vehicleModel: data['vehicleModel'] ?? '',
      createdAt: createdAt,
      expiryDate: expiryDate,
      mvpProgress: mvpProgress,
      mvpRegisteredDate: createdAt,
      mvpExpiryDate: expiryDate,
      mvpStatusText: mvpStatusText,
    );
  }
}
