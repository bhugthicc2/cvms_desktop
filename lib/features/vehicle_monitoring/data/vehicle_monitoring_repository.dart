import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle_model.dart';
import '../models/violation_model.dart';
import '../../../core/error/firebase_error_handler.dart';
import '../../../core/services/activity_log_service.dart';
import '../../../core/models/activity_type.dart';
import '../../../features/auth/data/auth_repository.dart';

class DashboardRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _vehiclesCollection = 'vehicles';
  final _vehicleLogsCollection = 'vehicle_logs';
  final _violationCollection = 'violations';
  final ActivityLogService _logger = ActivityLogService();
  final AuthRepository _authRepository = AuthRepository();

  //  Vehicle logs (entry/exit history)
  Stream<List<VehicleModel>> streamVehicleLogs() {
    return _firestore.collection('vehicle_logs').snapshots().asyncMap((
      snapshot,
    ) async {
      try {
        final entries =
            snapshot.docs.map((doc) => VehicleModel.fromDoc(doc)).toList();

        // Fetch vehicle details for all entries
        final entriesWithDetails = <VehicleModel>[];
        for (final entry in entries) {
          final entryWithDetails = await VehicleModel.withVehicleDetails(entry);
          entriesWithDetails.add(entryWithDetails);
        }

        return entriesWithDetails;
      } catch (e) {
        // Log error
        await _logger.logError(
          'Failed to stream vehicle logs: ${e.toString()}',
          'streamVehicleLogs',
          null,
        );
        rethrow;
      }
    });
  }

  // Current vehicles (master list of registered vehicles)
  Future<int> getTotalVehicles() async {
    try {
      final snapshot = await _firestore.collection('vehicles').get();
      final count = snapshot.size;

      // Log vehicle count retrieval

      return count;
    } catch (e) {
      rethrow;
    }
  }

  // Current entered vehicles (onsite or inside)
  Future<int> getTotalEnteredVehicles() async {
    try {
      final snapshot =
          await _firestore
              .collection('vehicles')
              .where('status', whereIn: ['inside', 'onsite'])
              .get();
      final count = snapshot.size;

      return count;
    } catch (e) {
      rethrow;
    }
  }

  // Current exited vehicles (offsite or outside)
  Future<int> getTotalExitedVehicles() async {
    try {
      final snapshot =
          await _firestore
              .collection('vehicles')
              .where('status', whereIn: ['outside', 'offsite'])
              .get();
      final count = snapshot.size;

      return count;
    } catch (e) {
      rethrow;
    }
  }

  // Violations
  Stream<int> streamTotalViolations() {
    return _firestore
        .collection('violations')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
          final count = snapshot.size;

          return count;
        })
        .handleError((error) {
          throw Exception(FirebaseErrorHandler.handleFirestoreError(error));
        });
  }

  Future<void> updateVehicle(String id, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(_vehiclesCollection).doc(id).update(updates);

      // Log vehicle update
      final plateNumber = updates['plateNumber'] as String? ?? 'Unknown';
      await _logger.logVehicleUpdated(id, plateNumber, null);
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  Future<void> updateVehicleLog(String id, Map<String, dynamic> updates) async {
    try {
      await _firestore
          .collection(_vehicleLogsCollection)
          .doc(id)
          .update(updates);

      // Log vehicle log update
      final vehicleId = updates['vehicleId'] as String? ?? 'Unknown';
      final status = updates['status'] as String? ?? 'Unknown';
      await _logger.logVehicleLogCreated(
        vehicleId,
        status,
        _authRepository.uid,
      );
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  // Updates vehicle status and corresponding vehicle_logs using a WriteBatch.
  Future<void> updateVehicleStatusAndLogs({
    required String vehicleId,
    required String newStatus, // "onsite" or "offsite"
    required String updatedByUserId,
  }) async {
    try {
      if (vehicleId.trim().isEmpty) {
        throw Exception("Empty vehicleId");
      }

      final vehicleRef = _firestore
          .collection(_vehiclesCollection)
          .doc(vehicleId);

      // Read required documents FIRST (outside any transaction)
      final vehicleSnap = await vehicleRef.get();
      if (!vehicleSnap.exists) {
        throw Exception("Vehicle not found: $vehicleId");
      }

      // Query active log (timeOut == null)
      final activeQuery =
          await _firestore
              .collection(_vehicleLogsCollection)
              .where('vehicleId', isEqualTo: vehicleId)
              .where('timeOut', isNull: true)
              .limit(1)
              .get();

      final now = Timestamp.now();
      final batch = _firestore.batch();

      // Always update master vehicle status
      batch.update(vehicleRef, {'status': newStatus});

      if (newStatus == 'onsite') {
        if (activeQuery.docs.isEmpty) {
          final newLogRef = _firestore.collection(_vehicleLogsCollection).doc();
          batch.set(newLogRef, {
            'logID': newLogRef.id,
            'vehicleId': vehicleId,
            'timeIn': now,
            'timeOut': null,
            'updatedByUserId': updatedByUserId,
            'status': 'onsite',
            'durationMinutes': null,
          });
        } else {
          batch.update(activeQuery.docs.first.reference, {
            'status': 'onsite',
            'updatedByUserId': updatedByUserId,
          });
        }
      } else if (newStatus == 'offsite') {
        if (activeQuery.docs.isNotEmpty) {
          final doc = activeQuery.docs.first;
          final data = doc.data();
          final timeInTs = data['timeIn'] as Timestamp;
          final durationMinutes =
              now.toDate().difference(timeInTs.toDate()).inMinutes;
          batch.update(doc.reference, {
            'timeOut': now,
            'status': 'offsite',
            'durationMinutes': durationMinutes,
            'updatedByUserId': updatedByUserId,
          });
        }
      }

      await batch.commit();

      // Log vehicle status update
      await _logger.logActivity(
        type: ActivityType.vehicleUpdated,
        description: 'Vehicle status changed to $newStatus',
        targetId: vehicleId,
        metadata: {
          'vehicleId': vehicleId,
          'newStatus': newStatus,
          'updatedByUserId': updatedByUserId,
          'action': 'status_change',
        },
      );
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  Future<Map<String, dynamic>> getVehicleById(String id) async {
    try {
      final snap =
          await FirebaseFirestore.instance.collection('vehicles').doc(id).get();
      if (!snap.exists) {
        throw Exception('Vehicle not found: $id');
      }
      final data = snap.data()!;
      final vehicleData = {
        'ownerName': (data['ownerName'] ?? '').toString(),
        'schoolID': (data['schoolID'] ?? '').toString(),
        'gender': (data['gender'] ?? '').toString(),
        'contact': (data['contact'] ?? '').toString(),
        'purok': (data['purok'] ?? '').toString(),
        'barangay': (data['barangay'] ?? '').toString(),
        'city': (data['city'] ?? '').toString(),
        'province': (data['province'] ?? '').toString(),
        'licenseNumber': (data['licenseNumber'] ?? '').toString(),
        'plateNumber': (data['plateNumber'] ?? '').toString(),
        'vehicleModel': (data['vehicleModel'] ?? '').toString(),
        'department': (data['department'] ?? '').toString(),
        'yearLevel': (data['yearLevel'] ?? '').toString(),
        'block': (data['block'] ?? '').toString(),
        'enrollment': (data['enrollment'] ?? '').toString(), // todo
        'licenseIssueExpiry':
            (data['licenseIssueExpiry'] ?? '').toString(), // todo
      };

      return vehicleData;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> reportViolation(ViolationModel violation) async {
    try {
      final docRef = _firestore.collection(_violationCollection).doc();
      final data = violation.toMap();
      // ensure the stored document has its own generated id
      data['violationId'] = docRef.id;
      await docRef.set(data);

      // Log violation report with current user ID
      await _logger.logViolationReported(
        docRef.id,
        violation.vehicleId,
        '${violation.violationType} violation reported for vehicle ${violation.vehicleId}',
        violation.reportedByUserId,
      );

      return docRef.id;
    } catch (e) {
      // Log error
      await _logger.logError(
        'Failed to report violation: ${e.toString()}',
        'reportViolation',
        null,
      );
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  Future<void> deleteVehicleLog(String docId) async {
    try {
      // Get the vehicle log details before deletion for logging
      final logSnapshot =
          await _firestore.collection('vehicle_logs').doc(docId).get();
      final vehicleId =
          logSnapshot.data()?['vehicleId'] as String? ?? 'Unknown';

      await _firestore.collection('vehicle_logs').doc(docId).delete();

      // Log vehicle log deletion
      await _logger.logActivity(
        type:
            ActivityType
                .systemNavigation, // Using systemNavigation as there's no specific vehicleLogDeleted type
        description: 'Vehicle log deleted for vehicle $vehicleId',
        targetId: vehicleId,
        metadata: {
          'vehicleId': vehicleId,
          'logId': docId,
          'action': 'delete_vehicle_log',
        },
      );
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }
}
