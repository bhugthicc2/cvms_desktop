import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_model.dart';

class VehicleViolationRepository {
  final CollectionReference _violations = FirebaseFirestore.instance.collection(
    'violations',
  );

  Future<void> reportViolation(ViolationEntry violation) async {
    await _violations.add(violation.toMap());
  }

  Future<void> bulkReportViolations(List<ViolationEntry> violations) async {
    if (violations.isEmpty) return;

    final batch = FirebaseFirestore.instance.batch();

    for (final violation in violations) {
      final docRef = _violations.doc();
      batch.set(docRef, violation.toMap());
    }

    await batch.commit();
  }
}
