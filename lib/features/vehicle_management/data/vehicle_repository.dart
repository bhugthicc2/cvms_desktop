//ACTIVITY LOG 5

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle_entry.dart';
import '../../../core/error/firebase_error_handler.dart';
import '../../../core/services/activity_log_service.dart';

class VehicleRepository {
  final _firestore = FirebaseFirestore.instance;
  final _collection = 'vehicles';
  final ActivityLogService _logger = ActivityLogService();

  Future<List<VehicleEntry>> fetchVehicles() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return VehicleEntry.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  Future<void> addVehicle(VehicleEntry entry) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(entry.toMap());

      // Log vehicle creation with the actual document ID as targetId
      await _logger.logVehicleCreated(docRef.id, entry.plateNumber, null);
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  Future<void> updateVehicle(String id, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(_collection).doc(id).update(updates);

      // Log vehicle update
      final vehicleData = await getVehicleById(id);
      if (vehicleData != null) {
        await _logger.logVehicleUpdated(
          id,
          vehicleData.plateNumber,
          null, // Will use current user from service
        );
      }
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  Future<void> deleteVehicle(String id) async {
    try {
      // Get vehicle data before deletion for logging
      final vehicleData = await getVehicleById(id);

      await _firestore.collection(_collection).doc(id).delete();

      // Log vehicle deletion
      if (vehicleData != null) {
        await _logger.logVehicleDeleted(
          id,
          vehicleData.plateNumber,
          null, // Will use current user from service
        );
      }
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  static const int _batchSize = 500; // Firestore limit

  Future<void> addVehicles(List<VehicleEntry> entries) async {
    try {
      for (var i = 0; i < entries.length; i += _batchSize) {
        final batch = _firestore.batch();
        final end =
            (i + _batchSize < entries.length) ? i + _batchSize : entries.length;
        final sublist = entries.sublist(i, end);

        for (final entry in sublist) {
          final docRef = _firestore.collection(_collection).doc(); // Auto ID
          batch.set(docRef, entry.toMap());
        }

        await batch.commit();
      }

      // Log bulk vehicle creation
      await _logger.logBulkVehiclesCreated(entries.length, null);
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  Stream<List<VehicleEntry>> watchVehicles() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return VehicleEntry.fromMap(doc.data(), doc.id);
          }).toList();
        })
        .handleError((error) {
          throw Exception(FirebaseErrorHandler.handleFirestoreError(error));
        });
  }

  /// Bulk delete multiple vehicles by their IDs
  Future<void> bulkDeleteVehicles(List<String> vehicleIds) async {
    if (vehicleIds.isEmpty) return;

    try {
      final batch = _firestore.batch();

      for (final id in vehicleIds) {
        final docRef = _firestore.collection(_collection).doc(id);
        batch.delete(docRef);
      }

      await batch.commit();

      // Log bulk vehicle deletion
      await _logger.logBulkVehiclesDeleted(vehicleIds, null);
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  Future<VehicleEntry?> getVehicleById(String vehicleId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(vehicleId).get();
      if (!doc.exists) return null;

      return VehicleEntry.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  Future<void> bulkUpdateStatus(List<String> vehicleIds, String status) async {
    if (vehicleIds.isEmpty) return;

    try {
      final batch = _firestore.batch();

      for (final id in vehicleIds) {
        final docRef = _firestore.collection(_collection).doc(id);
        batch.update(docRef, {'status': status});
      }

      await batch.commit();

      // Log bulk status update
      await _logger.logBulkStatusUpdated(vehicleIds, status, null);
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }
}
