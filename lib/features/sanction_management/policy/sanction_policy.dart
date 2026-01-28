import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sanction_decision.dart';
import '../models/sanction_enums.dart';
import '../../vehicle_management/models/vehicle_status.dart';

class SanctionPolicy {
  static SanctionDecision decide(int offenseNumber) {
    final now = DateTime.now();

    switch (offenseNumber) {
      case 1:
        return const SanctionDecision(
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
        return const SanctionDecision(
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
      if (date.weekday < DateTime.saturday) added++;
    }

    return Timestamp.fromDate(date);
  }
}
