import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_model.dart';

class VehicleViolationRepository {
  final CollectionReference _violations = FirebaseFirestore.instance.collection(
    'violations',
  );

  Future<void> reportViolation(ViolationEntry violation) async {
    await _violations.add(violation.toMap());
  }
}
