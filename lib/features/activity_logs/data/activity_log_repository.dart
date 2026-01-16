import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/activity_log.dart';
import '../../../core/models/activity_type.dart';

class ActivityLogRepository {
  final FirebaseFirestore _firestore;

  ActivityLogRepository(this._firestore);

  // -----------------------------
  // User Fullnames Fetching
  // -----------------------------
  Future<Map<String, String>> fetchUserFullnames(List<ActivityLog> logs) async {
    try {
      // Extract unique user IDs from activity logs
      final Set<String> userIds = {};
      for (final log in logs) {
        if (log.userId != null && log.userId!.isNotEmpty) {
          userIds.add(log.userId!);
        }
      }

      // Batch fetch user names
      final Map<String, String> userFullnames = {};
      if (userIds.isNotEmpty) {
        final usersSnapshot =
            await _firestore
                .collection('users')
                .where(FieldPath.documentId, whereIn: userIds.take(10).toList())
                .get();

        for (final userDoc in usersSnapshot.docs) {
          final userData = userDoc.data();
          final fullname = userData['fullname'] as String?;
          if (fullname != null && fullname.isNotEmpty) {
            userFullnames[userDoc.id] = fullname;
          }
        }
      }

      return userFullnames;
    } catch (e) {
      // Return empty map on error, fallback to 'System' will be used
      return {};
    }
  }

  static const String _collection = 'activities';

  Stream<List<ActivityLog>> getActivityLogsStream({
    DateTime? startDate,
    DateTime? endDate,
    String? userId,
    ActivityType? type,
    int limit = 100,
  }) {
    Query query = _firestore
        .collection(_collection)
        .orderBy('timestamp', descending: true)
        .limit(limit);

    if (startDate != null) {
      query = query.where(
        'timestamp',
        isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
      );
    }

    if (endDate != null) {
      query = query.where(
        'timestamp',
        isLessThanOrEqualTo: Timestamp.fromDate(endDate),
      );
    }

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    if (type != null) {
      query = query.where('type', isEqualTo: type.name);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ActivityLog.fromMap(data);
      }).toList();
    });
  }

  Future<List<ActivityLog>> getActivityLogs({
    DateTime? startDate,
    DateTime? endDate,
    String? userId,
    ActivityType? type,
    int limit = 100,
  }) async {
    Query query = _firestore
        .collection(_collection)
        .orderBy('timestamp', descending: true)
        .limit(limit);

    if (startDate != null) {
      query = query.where(
        'timestamp',
        isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
      );
    }

    if (endDate != null) {
      query = query.where(
        'timestamp',
        isLessThanOrEqualTo: Timestamp.fromDate(endDate),
      );
    }

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    if (type != null) {
      query = query.where('type', isEqualTo: type.name);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return ActivityLog.fromMap(data);
    }).toList();
  }

  Future<void> addActivityLog(ActivityLog log) async {
    await _firestore.collection(_collection).doc(log.id).set(log.toMap());
  }

  Future<void> updateActivityLog(ActivityLog log) async {
    await _firestore.collection(_collection).doc(log.id).update(log.toMap());
  }

  Future<void> deleteActivityLog(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}
