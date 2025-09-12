import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_model.dart';
import '../../../core/error/firebase_error_handler.dart';

class VehicleViolationRepository {
  final CollectionReference _violations = FirebaseFirestore.instance.collection(
    'violations',
  );

  Future<void> reportViolation(ViolationEntry violation) async {
    try {
      await _violations.add(violation.toMap());
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  Future<void> bulkReportViolations(List<ViolationEntry> violations) async {
    if (violations.isEmpty) return;

    try {
      final batch = FirebaseFirestore.instance.batch();

      for (final violation in violations) {
        final docRef = _violations.doc();
        batch.set(docRef, violation.toMap());
      }

      await batch.commit();
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }
}
