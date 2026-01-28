import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/sanction_management/models/saction_model.dart';
import 'package:cvms_desktop/features/sanction_management/models/sanction_enums.dart';
import 'package:cvms_desktop/features/sanction_management/utils/date_utils.dart';
import 'sanction_repository.dart';

class FirestoreSanctionRepository implements SanctionRepository {
  final FirebaseFirestore firestore;

  FirestoreSanctionRepository({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  // All sanctions (admin view)
  @override
  Stream<List<Sanction>> watchSanctions() {
    return firestore
        .collection('sanctions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_fromFirestore).toList());
  }

  //  Only ACTIVE SUSPENSIONS
  @override
  Stream<List<Sanction>> watchActiveSanctions() {
    return firestore
        .collection('sanctions')
        .where('status', isEqualTo: SanctionStatus.active.value)
        .where('type', isEqualTo: SanctionType.suspension.value)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_fromFirestore).toList());
  }

  //  Client-side sanction expiry logic
  @override
  Future<void> evaluateSanctionIfNeeded(Sanction sanction) async {
    if (sanction.endAt == null) return;
    if (DateTime.now().isBefore(sanction.endAt!)) return;

    final sanctionRef = firestore.collection('sanctions').doc(sanction.id);
    final vehicleRef = firestore.collection('vehicles').doc(sanction.vehicleId);

    await firestore.runTransaction((tx) async {
      final sanctionSnap = await tx.get(sanctionRef);
      if (!sanctionSnap.exists) return;

      final sanctionData = sanctionSnap.data() as Map<String, dynamic>;

      if (sanctionData['status'] != SanctionStatus.active.value) return;

      final vehicleSnap = await tx.get(vehicleRef);
      if (!vehicleSnap.exists) return;

      if (vehicleSnap['registrationStatus'] != 'suspended') return;

      // Expire sanction
      tx.update(sanctionRef, {
        'status': SanctionStatus.expired.value,
        'lastEvaluatedAt': FieldValue.serverTimestamp(),
      });

      // Restore vehicle
      tx.update(vehicleRef, {'registrationStatus': 'active'});
    });
  }

  Future<void> createSanctionForViolation({
    required String violationId,
    required String vehicleId,
    required String createdBy,
  }) async {
    final now = DateTime.now();

    final violationRef = firestore.collection('violations').doc(violationId);
    final vehicleRef = firestore.collection('vehicles').doc(vehicleId);
    final sanctionsRef = firestore.collection('sanctions');

    await firestore.runTransaction((tx) async {
      // 1. Ensure violation is confirmed
      final violationSnap = await tx.get(violationRef);
      if (!violationSnap.exists) return;

      final violation = violationSnap.data()!;
      if (violation['status'] != 'confirmed') return;

      // 2. Count confirmed violations
      final violationsQuery =
          await firestore
              .collection('violations')
              .where('vehicleId', isEqualTo: vehicleId)
              .where('status', isEqualTo: 'confirmed')
              .get();

      final offenseNumber = violationsQuery.size;

      // 3. Determine sanction
      late SanctionType type;
      DateTime? endAt;
      String vehicleStatusEffect = 'none';

      if (offenseNumber == 1) {
        type = SanctionType.warning;
      } else if (offenseNumber == 2) {
        type = SanctionType.suspension;
        endAt = addWorkingDays(now, 30);
        vehicleStatusEffect = 'suspended';
      } else {
        type = SanctionType.revocation;
        vehicleStatusEffect = 'revoked';
      }

      final sanctionRef = sanctionsRef.doc();

      // 4. Create sanction
      tx.set(sanctionRef, {
        'vehicleId': vehicleId,
        'violationId': violationId,
        'type': type.name,
        'status': SanctionStatus.active.name,
        'offenseNumber': offenseNumber,
        'vehicleStatusEffect': vehicleStatusEffect,
        'startAt': Timestamp.fromDate(now),
        'endAt': endAt != null ? Timestamp.fromDate(endAt) : null,
        'createdBy': createdBy,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 5. Update vehicle if needed
      if (vehicleStatusEffect != 'none') {
        tx.update(vehicleRef, {'registrationStatus': vehicleStatusEffect});
      }
    });
  }

  //  Firestore → Model mapper
  Sanction _fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Sanction(
      id: doc.id,
      vehicleId: data['vehicleId'] as String,
      violationId: data['violationId'] as String,
      type: SanctionTypeX.fromValue(data['type']),
      status: SanctionStatusX.fromValue(data['status']),
      offenseNumber: data['offenseNumber'] as int,
      vehicleStatusEffect: data['vehicleStatusEffect'] as String,
      startAt: (data['startAt'] as Timestamp).toDate(),
      endAt:
          data['endAt'] != null ? (data['endAt'] as Timestamp).toDate() : null,
      lastEvaluatedAt:
          data['lastEvaluatedAt'] != null
              ? (data['lastEvaluatedAt'] as Timestamp).toDate()
              : null,
      createdBy: data['createdBy'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
