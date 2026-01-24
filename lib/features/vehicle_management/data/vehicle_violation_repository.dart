import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_model.dart';
import '../../../core/error/firebase_error_handler.dart';
import '../../../core/services/activity_log_service.dart';

class VehicleViolationRepository {
  final CollectionReference _violations = FirebaseFirestore.instance.collection(
    'violations',
  );
  final ActivityLogService _logger = ActivityLogService();

  Future<void> reportViolation(ViolationEntry violation) async {
    try {
      await _violations.add(violation.toMap());

      // Log violation report
      await _logger.logViolationReported(
        violation.id,
        violation.vehicleId,
        '${violation.violationType} violation reported',
        null, // Will use current user from service
      );
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

      // Log bulk violation reporting
      await _logger.logBulkViolationsReported(
        violations.map((v) => v.id).toList(),
        null, // Will use current user from service
      );
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }
}
