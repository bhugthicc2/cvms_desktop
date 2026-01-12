//REFACTORED DB REFERENCE

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/models/vehicle_log_model.dart';
import '../../../core/error/firebase_error_handler.dart';

class VehicleLogsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'vehicle_logs';

  /// Add a manual log entry (reference-based)
  Future<void> addManualLog(VehicleLogModel entry) async {
    try {
      final active =
          await _firestore
              .collection(_collection)
              .where("vehicleId", isEqualTo: entry.vehicleId)
              .where("timeOut", isNull: true)
              .limit(1)
              .get();

      if (active.docs.isNotEmpty) {
        throw Exception(
          "This vehicle already has an active session. End it first.",
        );
      }

      await _firestore.collection(_collection).add(entry.toMap());

      await _firestore.collection("vehicles").doc(entry.vehicleId).update({
        "status": entry.status,
      });
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  /// Real-time logs stream
  Stream<List<VehicleLogModel>> fetchLogs() {
    return _firestore
        .collection(_collection)
        .orderBy('timeIn', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => VehicleLogModel.fromMap(doc.data(), doc.id))
                  .toList(),
        );
  }

  /// Start a session (no vehicle snapshots)
  Future<void> startSession({
    required String vehicleId,
    required String updatedByUserId,
  }) async {
    final now = Timestamp.now();

    final log = VehicleLogModel(
      id: '',
      vehicleId: vehicleId,
      updatedByUserId: updatedByUserId,
      timeIn: now,
      status: "onsite",
    );

    await _firestore.collection(_collection).add(log.toMap());
    await _firestore.collection("vehicles").doc(vehicleId).update({
      "status": "onsite",
    });
  }

  /// End a session
  Future<void> endSession({
    required String vehicleId,
    required String updatedByUserId,
  }) async {
    final now = Timestamp.now();

    final active =
        await _firestore
            .collection(_collection)
            .where("vehicleId", isEqualTo: vehicleId)
            .where("timeOut", isNull: true)
            .limit(1)
            .get();

    if (active.docs.isEmpty) {
      throw Exception("No active session found for vehicle $vehicleId");
    }

    final doc = active.docs.first;
    final timeIn = doc["timeIn"] as Timestamp;
    final duration = now.toDate().difference(timeIn.toDate()).inMinutes;

    await _firestore.collection(_collection).doc(doc.id).update({
      "timeOut": now,
      "status": "offsite",
      "durationMinutes": duration,
      "updatedBy": updatedByUserId,
    });

    await _firestore.collection("vehicles").doc(vehicleId).update({
      "status": "offsite",
    });
  }

  /// Check if a vehicle has any logs
  Future<bool> hasVehicleLogs(String vehicleId) async {
    try {
      final snapshot =
          await _firestore
              .collection(_collection)
              .where("vehicleId", isEqualTo: vehicleId)
              .limit(1)
              .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  /// Get all vehicle IDs that have logs
  Future<Set<String>> getVehiclesWithLogs() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();

      return snapshot.docs
          .map((doc) => doc.data()['vehicleId'] as String?)
          .whereType<String>()
          .toSet();
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }
}
