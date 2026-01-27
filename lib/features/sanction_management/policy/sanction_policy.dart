import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/sanction_management/models/sanction_enums.dart';
import 'package:cvms_desktop/features/vehicle_management/models/vehicle_status.dart';

class SanctionDecision {
  final SanctionType type;
  final VehicleStatus vehicleStatus;
  final Timestamp? endsAt;

  const SanctionDecision({
    required this.type,
    required this.vehicleStatus,
    this.endsAt,
  });
}

class SanctionPolicy {
  static SanctionDecision decide(int offenseNumber) {
    final now = DateTime.now();

    switch (offenseNumber) {
      case 1:
        return SanctionDecision(
          type: SanctionType.warning,
          vehicleStatus: VehicleStatus.active,
          endsAt: null,
        );

      case 2:
        return SanctionDecision(
          type: SanctionType.suspension,
          vehicleStatus: VehicleStatus.suspended,
          endsAt: _addWorkingDays(now, 30),
        );

      default:
        return SanctionDecision(
          type: SanctionType.revocation,
          vehicleStatus: VehicleStatus.revoked,
          endsAt: null,
        );
    }
  }

  static Timestamp _addWorkingDays(DateTime start, int days) {
    var date = start;
    var added = 0;

    while (added < days) {
      date = date.add(const Duration(days: 1));

      if (date.weekday != DateTime.saturday &&
          date.weekday != DateTime.sunday) {
        added++;
      }
    }

    return Timestamp.fromDate(date);
  }
}
