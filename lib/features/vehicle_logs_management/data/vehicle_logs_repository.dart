import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/models/vehicle_log_model.dart';
import '../../../core/error/firebase_error_handler.dart';

class VehicleLogsRepository {
  final _firestore = FirebaseFirestore.instance;
  final String _collection = 'vehicle_logs';

  Future<void> addManualLog(VehicleLogModel entry) async {
    try {
      // check if vehicle already has an active session
      // Note: Firestore field is 'vehicleId' (lowercase 'd')
      final active =
          await _firestore
              .collection(_collection)
              .where("vehicleId", isEqualTo: entry.vehicleID)
              .where("timeOut", isNull: true) // still active session
              .limit(1)
              .get();

      if (active.docs.isNotEmpty) {
        throw Exception(
          "This vehicle already has an active session. End it first before adding a new log.",
        );
      }

      await _firestore.collection(_collection).add(entry.toMap());

      // also update vehicle status to reflect manual entry
      await _firestore.collection("vehicles").doc(entry.vehicleID).update({
        "status": entry.status, // 'onsite' or 'offsite'
      });
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  Future<List<Map<String, dynamic>>> fetchAvailableVehicles(
    String query,
  ) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection("vehicles")
            .where("status", isEqualTo: "offsite")
            .get();

    return snapshot.docs
        .where((doc) {
          final data = doc.data();
          final ownerName = (data["ownerName"] ?? "").toString();
          return ownerName.toLowerCase().contains(query.toLowerCase());
        })
        .map((doc) {
          final data = doc.data();
          return {
            "docId": doc.id,
            "ownerName": data["ownerName"] ?? "",
            "schoolID": data["schoolID"] ?? "",
            "department": data["department"] ?? "",
            "plateNumber": data["plateNumber"] ?? "",
            "vehicleType": data["vehicleType"] ?? "",
            "vehicleModel": data["vehicleModel"] ?? "",
            "vehicleColor": data["vehicleColor"] ?? "",
            "licenseNumber": data["licenseNumber"] ?? "",
            "orNumber": data["orNumber"] ?? "",
            "crNumber": data["crNumber"] ?? "",
          };
        })
        .toList();
  }

  //fetch vehicle in real time by using stream subscription
  Stream<List<VehicleLogModel>> fetchLogs() {
    return _firestore
        .collection('vehicle_logs')
        .orderBy('timeIn', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) {
                final data = doc.data();
                // Use VehicleLogModel.fromMap which correctly handles 'vehicleId' field
                return VehicleLogModel.fromMap(data, doc.id);
              }).toList(),
        );
  }

  Future<void> startSession(
    String vehicleID,
    String updatedBy,
    Map<String, dynamic> vehicleInfo,
  ) async {
    final now = Timestamp.now();

    final log = VehicleLogModel(
      logID: "",
      vehicleID: vehicleID,
      ownerName: vehicleInfo['ownerName'] ?? '',
      plateNumber: vehicleInfo['plateNumber'] ?? '',
      vehicleModel: vehicleInfo['vehicleModel'] ?? '',
      timeIn: now,
      updatedBy: updatedBy,
      status: "onsite",
    );

    await _firestore.collection(_collection).add(log.toMap());
    await _firestore.collection("vehicles").doc(vehicleID).update({
      "status": "onsite",
    });
  }

  Future<void> endSession(String vehicleID, String updatedBy) async {
    final now = Timestamp.now();

    // find active session
    // Note: Firestore field is 'vehicleId' (lowercase 'd')
    final active =
        await _firestore
            .collection(_collection)
            .where("vehicleId", isEqualTo: vehicleID)
            .where("timeOut", isNull: true)
            .limit(1)
            .get();

    if (active.docs.isEmpty) {
      throw Exception("No active session found for vehicle $vehicleID");
    }

    final doc = active.docs.first;
    final timeIn = (doc["timeIn"] as Timestamp);
    final duration = now.toDate().difference(timeIn.toDate()).inMinutes;

    await _firestore.collection(_collection).doc(doc.id).update({
      "timeOut": now,
      "status": "offsite",
      "durationMinutes": duration,
      "updatedBy": updatedBy,
    });

    await _firestore.collection("vehicles").doc(vehicleID).update({
      "status": "offsite",
    });
  }

  /// Check if a vehicle has any logs (transactions)
  Future<bool> hasVehicleLogs(String vehicleID) async {
    try {
      // Note: Firestore field is 'vehicleId' (lowercase 'd')
      final snapshot =
          await _firestore
              .collection(_collection)
              .where("vehicleId", isEqualTo: vehicleID)
              .limit(1)
              .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  /// Get all vehicle IDs that have at least one log
  Future<Set<String>> getVehiclesWithLogs() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();

      if (snapshot.docs.isEmpty) {
        return <String>{};
      }

      // Extract vehicle IDs
      // Note: Firestore uses 'vehicleId' (lowercase 'd') as per VehicleLogModel.toMap()
      final allVehicleIDs =
          snapshot.docs.map((doc) {
            final data = doc.data();
            // Try both 'vehicleId' (actual) and 'vehicleID' (fallback) for compatibility
            return (data['vehicleId'] as String? ??
                data['vehicleID'] as String? ??
                '');
          }).toList();

      final vehiclesWithLogs =
          allVehicleIDs.where((id) => id.isNotEmpty).toSet();

      return vehiclesWithLogs;
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }
}
