import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/core/error/firebase_error_handler.dart';
import 'package:cvms_desktop/features/dashboard/models/violation_model.dart';
import '../models/vehicle_entry.dart';

class DashboardRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _vehiclesCollection = 'vehicles';
  final _vehicleLogsCollection = 'vehicle_logs';
  final _violationCollection = 'violations';

  //  Vehicle logs (entry/exit history)
  Stream<List<VehicleEntry>> streamVehicleLogs() {
    return _firestore.collection('vehicle_logs').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return VehicleEntry.fromDoc(doc);
      }).toList();
    });
  }

  // Current vehicles (master list of registered vehicles)
  Future<int> getTotalVehicles() async {
    final snapshot = await _firestore.collection('vehicles').get();
    return snapshot.size; // quick count
  }

  // Current entered vehicles (onsite or inside)
  Future<int> getTotalEnteredVehicles() async {
    final snapshot =
        await _firestore
            .collection('vehicles')
            .where('status', whereIn: ['inside', 'onsite'])
            .get();
    return snapshot.size; // quick count
  }

  // Current exited vehicles (offsite or outside)
  Future<int> getTotalExitedVehicles() async {
    final snapshot =
        await _firestore
            .collection('vehicles')
            .where('status', whereIn: ['outside', 'offsite'])
            .get();
    return snapshot.size; // quick count
  }

  // Violations
  Stream<int> streamTotalViolations() {
    return _firestore
        .collection('violations')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  Future<void> updateVehicle(String id, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(_vehiclesCollection).doc(id).update(updates);
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
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  // Updates vehicle status and corresponding vehicle_logs using a WriteBatch.
  Future<void> updateVehicleStatusAndLogs({
    required String vehicleId,
    required String newStatus, // "inside" or "outside"
    String updatedBy = "Admin",
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
      final vehicleData = vehicleSnap.data() as Map<String, dynamic>;

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

      if (newStatus == 'inside') {
        if (activeQuery.docs.isEmpty) {
          final newLogRef = _firestore.collection(_vehicleLogsCollection).doc();
          batch.set(newLogRef, {
            'logID': newLogRef.id,
            'vehicleId': vehicleId,
            'ownerName': (vehicleData['ownerName'] ?? '').toString(),
            'plateNumber': (vehicleData['plateNumber'] ?? '').toString(),
            'vehicleModel': (vehicleData['vehicleModel'] ?? '').toString(),
            'timeIn': now,
            'timeOut': null,
            'updatedBy': updatedBy,
            'status': 'inside',
            'durationMinutes': null,
          });
        } else {
          batch.update(activeQuery.docs.first.reference, {
            'status': 'inside',
            'updatedBy': updatedBy,
          });
        }
      } else if (newStatus == 'outside') {
        if (activeQuery.docs.isNotEmpty) {
          final doc = activeQuery.docs.first;
          final data = doc.data();
          final timeInTs = data['timeIn'] as Timestamp;
          final durationMinutes =
              now.toDate().difference(timeInTs.toDate()).inMinutes;
          batch.update(doc.reference, {
            'timeOut': now,
            'status': 'outside',
            'durationMinutes': durationMinutes,
            'updatedBy': updatedBy,
          });
        }
      }

      await batch.commit();
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  Future<Map<String, dynamic>> getVehicleById(String id) async {
    final snap =
        await FirebaseFirestore.instance.collection('vehicles').doc(id).get();
    if (!snap.exists) {
      throw Exception('Vehicle not found: $id');
    }
    final data = snap.data()!;
    return {
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
  }

  Future<String> reportViolation(ViolationModel violation) async {
    try {
      final docRef = _firestore.collection(_violationCollection).doc();
      final data = violation.toMap();
      // ensure the stored document has its own generated id
      data['violationId'] = docRef.id;
      await docRef.set(data);
      return docRef.id;
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  Future<void> deleteVehicleLog(String docId) async {
    try {
      await _firestore.collection('vehicle_logs').doc(docId).delete();
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }
}
