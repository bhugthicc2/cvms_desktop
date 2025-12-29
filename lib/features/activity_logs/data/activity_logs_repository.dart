import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/core/error/firebase_error_handler.dart';
import '../models/activity_entry.dart';

class ActivityLogsRepository {
  final FirebaseFirestore _firestore;
  static const String _collection = 'activity_logs';

  ActivityLogsRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // Get a single activity log by ID
  Future<ActivityLog> getActivityLog(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) {
        throw Exception('Activity log not found');
      }
      return ActivityLog.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  // Get all activity logs with optional filtering as a stream
  Stream<List<ActivityLog>> getActivityLogsStream({
    ActivityType? type,
    String? userId,
    String? targetId,
    String? targetType,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
  }) {
    try {
      Query query = _firestore
          .collection(_collection)
          .orderBy('timestamp', descending: true)
          .limit(limit);

      if (type != null) {
        query = query.where('type', isEqualTo: type.toString().split('.').last);
      }
      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }
      if (targetId != null) {
        query = query.where('targetId', isEqualTo: targetId);
      }
      if (targetType != null) {
        query = query.where('targetType', isEqualTo: targetType);
      }
      if (startDate != null) {
        query = query.where('timestamp', isGreaterThanOrEqualTo: startDate);
      }
      if (endDate != null) {
        query = query.where('timestamp', isLessThanOrEqualTo: endDate);
      }

      return query.snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => ActivityLog.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      });
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  // Get all activity logs with optional filtering (non-stream version)
  Future<List<ActivityLog>> getActivityLogs({
    ActivityType? type,
    String? userId,
    String? targetId,
    String? targetType,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
  }) async {
    try {
      Query query = _firestore
          .collection(_collection)
          .orderBy('timestamp', descending: true)
          .limit(limit);

      if (type != null) {
        query = query.where('type', isEqualTo: type.toString().split('.').last);
      }
      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }
      if (targetId != null) {
        query = query.where('targetId', isEqualTo: targetId);
      }
      if (targetType != null) {
        query = query.where('targetType', isEqualTo: targetType);
      }
      if (startDate != null) {
        query = query.where('timestamp', isGreaterThanOrEqualTo: startDate);
      }
      if (endDate != null) {
        query = query.where('timestamp', isLessThanOrEqualTo: endDate);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => ActivityLog.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  // Add a new activity log
  Future<String> addActivityLog(ActivityLog log) async {
    try {
      final docRef = await _firestore.collection(_collection).add(log.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  // Alias for getActivityLogsStream for backward compatibility
  Stream<List<ActivityLog>> watchActivityLogs({
    ActivityType? type,
    String? userId,
    int limit = 50,
  }) {
    return getActivityLogsStream(
      type: type,
      userId: userId,
      limit: limit,
    );
  }

  // Delete activity log by ID
  Future<void> deleteActivityLog(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  // Bulk delete activity logs
  Future<void> bulkDeleteActivityLogs(List<String> logIds) async {
    if (logIds.isEmpty) return;

    try {
      final batch = _firestore.batch();
      for (final id in logIds) {
        batch.delete(_firestore.collection(_collection).doc(id));
      }
      await batch.commit();
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  // Clear all activity logs (use with caution)
  Future<void> clearAllActivityLogs() async {
    try {
      // Get all documents
      final snapshot = await _firestore.collection(_collection).get();
      final batch = _firestore.batch();

      // Delete in batches of 500 (Firestore limit)
      for (var i = 0; i < snapshot.docs.length; i += 500) {
        final batch = _firestore.batch();
        final end =
            (i + 500 < snapshot.docs.length) ? i + 500 : snapshot.docs.length;
        for (var j = i; j < end; j++) {
          batch.delete(snapshot.docs[j].reference);
        }
        await batch.commit();
      }
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  // Get activity logs by target (e.g., vehicle, user)
  Future<List<ActivityLog>> getActivityLogsByTarget({
    required String targetType,
    required String targetId,
    int limit = 50,
  }) async {
    try {
      final query = _firestore
          .collection(_collection)
          .where('targetType', isEqualTo: targetType)
          .where('targetId', isEqualTo: targetId)
          .orderBy('timestamp', descending: true)
          .limit(limit);

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => ActivityLog.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  // Get recent activity logs for dashboard
  Future<List<ActivityLog>> getRecentActivityLogs({int limit = 10}) async {
    try {
      final query = _firestore
          .collection(_collection)
          .orderBy('timestamp', descending: true)
          .limit(limit);

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => ActivityLog.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }
}
