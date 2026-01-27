import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/sanction_management/models/saction_model.dart';
import 'package:cvms_desktop/features/sanction_management/models/sanction_enums.dart';
import 'package:cvms_desktop/features/sanction_management/repository/sanction_repository.dart';

class FirestoreSanctionRepository implements SanctionRepository {
  final FirebaseFirestore firestore;

  FirestoreSanctionRepository({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Sanction>> watchSanctions() {
    return firestore
        .collection('sanctions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map(_fromFirestore).toList();
        });
  }

  Sanction _fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Sanction(
      id: doc.id,
      vehicleId: data['vehicleId'] as String,
      violationId: data['violationId'] as String,
      type: SanctionType.values.byName(data['type']),
      status: SanctionStatus.values.byName(data['status']),
      offenseNumber: data['offenseNumber'] as int,
      startAt: (data['startAt'] as Timestamp).toDate(),
      endAt:
          data['endAt'] != null ? (data['endAt'] as Timestamp).toDate() : null,
      createdBy: data['createdBy'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
