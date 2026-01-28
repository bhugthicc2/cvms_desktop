import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/sanction_management/models/sanction_enums.dart';

class SanctionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> handleConfirmedViolation({
    required String violationId,
    required String vehicleId,
    required String confirmedByUserId,
  }) async {
    final now = DateTime.now();

    // 1️ Count confirmed violations for this vehicle
    final confirmedViolations =
        await _firestore
            .collection('violations')
            .where('vehicleId', isEqualTo: vehicleId)
            .where('status', isEqualTo: 'confirmed')
            .get();

    final offenseNumber = confirmedViolations.size;

    // 2️ Decide sanction
    if (offenseNumber == 1) {
      // Written warning → NO sanction record
      return;
    }

    if (offenseNumber == 2) {
      await _createSuspension(
        violationId: violationId,
        vehicleId: vehicleId,
        adminUserId: confirmedByUserId,
        startAt: now,
      );
      return;
    }

    if (offenseNumber >= 3) {
      await _createRevocation(
        violationId: violationId,
        vehicleId: vehicleId,
        adminUserId: confirmedByUserId,
        startAt: now,
      );
    }
  }

  // ---------------- PRIVATE HELPERS ----------------

  Future<void> _createSuspension({
    required String violationId,
    required String vehicleId,
    required String adminUserId,
    required DateTime startAt,
  }) async {
    final endAt = _addWorkingDays(startAt, 30);

    final batch = _firestore.batch();

    final sanctionRef = _firestore.collection('sanctions').doc();
    final vehicleRef = _firestore.collection('vehicles').doc(vehicleId);

    batch.set(sanctionRef, {
      'vehicleId': vehicleId,
      'violationId': violationId,
      'type': SanctionType.suspension.value,
      'status': SanctionStatus.active.value,
      'offenseNumber': 2,
      'startAt': Timestamp.fromDate(startAt),
      'endAt': Timestamp.fromDate(endAt),
      'createdBy': adminUserId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    batch.update(vehicleRef, {'registrationStatus': 'suspended'});

    await batch.commit();
  }

  Future<void> _createRevocation({
    required String violationId,
    required String vehicleId,
    required String adminUserId,
    required DateTime startAt,
  }) async {
    final batch = _firestore.batch();

    final sanctionRef = _firestore.collection('sanctions').doc();
    final vehicleRef = _firestore.collection('vehicles').doc(vehicleId);

    batch.set(sanctionRef, {
      'vehicleId': vehicleId,
      'violationId': violationId,
      'type': SanctionType.revocation.value,
      'status': SanctionStatus.active.value,
      'offenseNumber': 3,
      'startAt': Timestamp.fromDate(startAt),
      'endAt': null,
      'createdBy': adminUserId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    batch.update(vehicleRef, {'registrationStatus': 'revoked'});

    await batch.commit();
  }

  DateTime _addWorkingDays(DateTime start, int days) {
    var date = start;
    var added = 0;

    while (added < days) {
      date = date.add(const Duration(days: 1));
      if (date.weekday <= DateTime.friday) {
        added++;
      }
    }
    return date;
  }
}
