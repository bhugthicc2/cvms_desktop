//ACTIVITY LOG 6

// VEHICLE ID REFERENCE UPDATE MARKER
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_enums.dart';
import 'package:flutter/foundation.dart';
import '../models/violation_model.dart';
import '../../../core/error/firebase_error_handler.dart';
import '../../../core/services/activity_log_service.dart';

class ViolationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'violations';
  final ActivityLogService _logger = ActivityLogService();

  Future<void> reportViolation(ViolationEntry violation) async {
    try {
      await _firestore.collection(_collection).add(violation.toMap());

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

  Future<List<ViolationEntry>> fetchViolations() async {
    try {
      final snapshot =
          await _firestore
              .collection(_collection)
              .orderBy('createdAt', descending: true)
              .get();
      final violations =
          snapshot.docs.map((doc) {
            final data = doc.data();
            return ViolationEntry.fromMap(data, doc.id);
          }).toList();

      // Enrich with related info after fetching
      return await enrichViolationsWithRelatedInfo(violations);
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  Future<void> updateViolationStatus({
    required List<String> violationIds,
    required ViolationStatus status,
  }) async {
    try {
      final batch = FirebaseFirestore.instance.batch();

      for (final id in violationIds) {
        final ref = FirebaseFirestore.instance.collection('violations').doc(id);

        final updateData = {
          'status': status.value,
          'resolvedAt':
              status == ViolationStatus.pending
                  ? null
                  : FieldValue.serverTimestamp(),
        };

        batch.update(ref, updateData);
      }

      await batch.commit();
    } catch (e) {
      debugPrint('Error updating violation status: $e');
      rethrow;
    }
  }

  Future<Map<String, Map<String, dynamic>>> getVehiclesBasicInfos(
    List<String> vehicleIds,
  ) async {
    if (vehicleIds.isEmpty) return <String, Map<String, dynamic>>{};

    final futures = <Future<DocumentSnapshot>>[];
    for (final id in vehicleIds) {
      final docRef = _firestore.collection('vehicles').doc(id);
      futures.add(docRef.get());
    }

    final snapshots = await Future.wait(futures);
    final Map<String, Map<String, dynamic>> info =
        <String, Map<String, dynamic>>{};

    for (int i = 0; i < vehicleIds.length; i++) {
      final id = vehicleIds[i];
      final snap = snapshots[i];
      info[id] = {
        'ownerName':
            (snap.exists
                ? (snap.data() as Map<String, dynamic>)['ownerName'] ??
                    'Unknown'
                : 'Unknown'),
        'plateNumber':
            (snap.exists
                ? (snap.data() as Map<String, dynamic>)['plateNumber'] ??
                    'Unknown'
                : 'Unknown'),
      };
    }

    return info;
  }

  Future<Map<String, String>> getUsersBasicInfos(List<String> userIds) async {
    if (userIds.isEmpty) return <String, String>{};

    final futures = <Future<DocumentSnapshot>>[];
    for (final id in userIds) {
      final docRef = _firestore.collection('users').doc(id);
      futures.add(docRef.get());
    }

    final snapshots = await Future.wait(futures);
    final Map<String, String> info = <String, String>{};

    for (int i = 0; i < userIds.length; i++) {
      final id = userIds[i];
      final snap = snapshots[i];
      info[id] =
          snap.exists
              ? (snap.data() as Map<String, dynamic>)['fullname'] ?? 'Unknown'
              : 'Unknown';
    }

    return info;
  }

  Future<List<ViolationEntry>> _enrichWithRelatedInfo(
    List<ViolationEntry> violations,
  ) async {
    final uniqueVehicles = <String>{};
    final uniqueUsers = <String>{};
    for (final e in violations) {
      uniqueVehicles.add(e.vehicleId);
      uniqueUsers.add(e.reportedByUserId);
    }

    final vehiclesInfo = await getVehiclesBasicInfos(uniqueVehicles.toList());
    final usersInfo = await getUsersBasicInfos(uniqueUsers.toList());
    final enriched = <ViolationEntry>[];

    for (final e in violations) {
      final vehicleInfo =
          vehiclesInfo[e.vehicleId] ??
          {'ownerName': 'Unknown', 'plateNumber': 'Unknown'};
      final userFullname = usersInfo[e.reportedByUserId] ?? 'Unknown';
      enriched.add(
        e.copyWith(
          ownerName: vehicleInfo['ownerName'] as String,
          plateNumber: vehicleInfo['plateNumber'] as String,
          fullname: userFullname,
        ),
      );
    }

    return enriched;
  }

  // Public wrapper for enriching violations with vehicle and user info
  Future<List<ViolationEntry>> enrichViolationsWithRelatedInfo(
    List<ViolationEntry> violations,
  ) async {
    return await _enrichWithRelatedInfo(violations);
  }

  Future<Map<String, dynamic>> getVehicleBasicInfo(String vehicleId) async {
    final doc =
        await FirebaseFirestore.instance
            .collection('vehicles')
            .doc(vehicleId)
            .get();
    if (!doc.exists) {
      return {'ownerName': 'Unknown', 'plateNumber': 'Unknown'};
    }
    final data = doc.data()!;
    return {
      'ownerName': data['ownerName'] ?? 'Unknown',
      'plateNumber': data['plateNumber'] ?? 'Unknown',
    };
  }

  Stream<List<ViolationEntry>> watchViolations() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          final violations =
              snapshot.docs.map((doc) {
                final data = doc.data();
                return ViolationEntry.fromMap(data, doc.id);
              }).toList();

          final enriched = await _enrichWithRelatedInfo(violations);
          return enriched;
        })
        .handleError((error) {
          throw Exception(FirebaseErrorHandler.handleFirestoreError(error));
        });
  }

  Stream<List<ViolationEntry>> watchPendingViolations() {
    return _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          final violations =
              snapshot.docs.map((doc) {
                final data = doc.data();
                return ViolationEntry.fromMap(data, doc.id);
              }).toList();

          return await _enrichWithRelatedInfo(violations);
        })
        .handleError((error) {
          throw Exception(FirebaseErrorHandler.handleFirestoreError(error));
        });
  }

  Future<void> deleteViolation(String violationId) async {
    try {
      await _firestore.collection(_collection).doc(violationId).delete();

      // Log violation deletion
      await _logger.logViolationDeleted(violationId, null);
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }
}
