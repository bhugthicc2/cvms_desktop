//ACTIVITY LOG 4

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/activity_log.dart';
import '../models/activity_type.dart';

class ActivityLogService {
  static final ActivityLogService _instance = ActivityLogService._internal();
  factory ActivityLogService() => _instance;
  ActivityLogService._internal();

  final ActivityLogRepository _repository = ActivityLogRepository();

  Future<void> logActivity({
    required ActivityType type,
    required String description,
    String? userId,
    String? targetId,
    Map<String, dynamic>? metadata,
  }) async {
    final log = ActivityLog(
      id: _generateId(),
      type: type,
      description: description,
      userId: userId ?? _getCurrentUserId(),
      targetId: targetId,
      metadata: metadata,
      timestamp: DateTime.now(),
    );

    await _repository.createLog(log);
  }

  //step 1 in creating a logger
  Future<void> logVehicleCreated(
    String vehicleId,
    String plateNumber,
    String? userId,
  ) async {
    await logActivity(
      type: ActivityType.vehicleCreated,
      targetId: vehicleId,

      description: 'Vehicle $plateNumber created successfully',
      userId: userId,
      metadata: {'plateNumber': plateNumber, 'action': 'create'},
    );
  }

  Future<void> logVehicleLogCreated(
    String vehicleId,
    String status,
    String? userId,
  ) async {
    await logActivity(
      type: ActivityType.dataImport,
      description:
          'Manual vehicle log created for vehicle $vehicleId with status $status',
      userId: userId,
      targetId: vehicleId,
      metadata: {
        'vehicleId': vehicleId,
        'status': status,
        'action': 'manual_log_create',
        'type': 'vehicle_log',
      },
    );
  }

  Future<void> logVehicleUpdated(
    String vehicleId,
    String plateNumber,
    String? userId,
  ) async {
    await logActivity(
      type: ActivityType.vehicleUpdated,
      description: 'Vehicle $plateNumber updated',
      userId: userId,
      targetId: vehicleId,
      metadata: {'plateNumber': plateNumber, 'action': 'update'},
    );
  }

  Future<void> logVehicleDeleted(
    String vehicleId,
    String plateNumber,
    String? userId,
  ) async {
    await logActivity(
      type: ActivityType.vehicleDeleted,
      description: 'Vehicle $plateNumber deleted',
      userId: userId,
      targetId: vehicleId,
      metadata: {'plateNumber': plateNumber, 'action': 'delete'},
    );
  }

  Future<void> logUserLogin(String? userId) async {
    await logActivity(
      type: ActivityType.userLogin,
      description: 'User logged in successfully',
      userId: userId,
      metadata: {'action': 'login'},
    );
  }

  Future<void> logUserLogout(String? userId) async {
    await logActivity(
      type: ActivityType.userLogout,
      description: 'User logged out',
      userId: userId,
      metadata: {'action': 'logout'},
    );
  }

  Future<void> logViolationReported(
    String violationId,
    String vehicleId,
    String description,
    String? userId,
  ) async {
    await logActivity(
      type: ActivityType.violationReported,
      description: 'Violation reported: $description',
      userId: userId,
      targetId: vehicleId,
      metadata: {'violationId': violationId, 'action': 'report'},
    );
  }

  Future<void> logViolationUpdated(
    String violationId,
    String newStatus,
    String? userId,
  ) async {
    await logActivity(
      type: ActivityType.violationUpdated,
      description: 'Violation status updated to $newStatus',
      userId: userId,
      targetId: violationId,
      metadata: {
        'violationId': violationId,
        'newStatus': newStatus,
        'action': 'status_update',
      },
    );
  }

  Future<void> logViolationDeleted(String violationId, String? userId) async {
    await logActivity(
      type: ActivityType.violationDeleted,
      description: 'Violation deleted',
      userId: userId,
      targetId: violationId,
      metadata: {'violationId': violationId, 'action': 'delete'},
    );
  }

  Future<void> logBulkViolationsReported(
    List<String> violationIds,
    String? userId,
  ) async {
    await logActivity(
      type: ActivityType.violationReported,
      description: 'Bulk report: ${violationIds.length} violations reported',
      userId: userId,
      metadata: {
        'count': violationIds.length,
        'violationIds': violationIds,
        'action': 'bulk_report',
        'type': 'violations',
      },
    );
  }

  Future<void> logUserCreated(String userId, String userEmail) async {
    await logActivity(
      type: ActivityType.userCreated,
      description: 'User account created for $userEmail',
      userId: userId,
      targetId: userId,
      metadata: {'userEmail': userEmail, 'action': 'create'},
    );
  }

  Future<void> logUserUpdated(String userId, String? currentUser) async {
    await logActivity(
      type: ActivityType.userUpdated,
      description: 'User profile updated for user $userId',
      userId: currentUser,
      targetId: userId,
      metadata: {'targetUserId': userId, 'action': 'profile_update'},
    );
  }

  Future<void> logUserStatusUpdated(
    String userId,
    String newStatus,
    String? currentUser,
  ) async {
    await logActivity(
      type: ActivityType.userUpdated,
      description: 'User status changed to $newStatus for user $userId',
      userId: currentUser,
      targetId: userId,
      metadata: {
        'targetUserId': userId,
        'newStatus': newStatus,
        'action': 'status_update',
      },
    );
  }

  Future<void> logUserDeleted(
    String userId,
    String userEmail,
    String? currentUser,
  ) async {
    await logActivity(
      type: ActivityType.userDeleted,
      description: 'User $userEmail deleted',
      userId: currentUser, // Current user who performed the deletion
      targetId: userId, // User who was deleted
      metadata: {'userEmail': userEmail, 'action': 'delete'},
    );
  }

  Future<void> logPasswordReset(String userId, String userEmail) async {
    await logActivity(
      type: ActivityType.passwordReset,
      description: 'Password reset for $userEmail',
      userId: userId,
      targetId: userId,
      metadata: {'userEmail': userEmail, 'action': 'password_reset'},
    );
  }

  //step 1 mvp export
  Future<void> logMvpStickerExported(
    String vehicleId,
    String ownerName,
    String? userId,
  ) async {
    await logActivity(
      type: ActivityType.dataExport,
      description: 'MVP sticker exported for vehicle $vehicleId ($ownerName)',
      userId: userId,
      targetId: vehicleId,
      metadata: {
        'vehicleId': vehicleId,
        'ownerName': ownerName,
        'action': 'mvp_sticker_export',
        'type': 'vehicle_export',
      },
    );
  }

  Future<void> logBulkVehiclesCreated(int count, String? userId) async {
    await logActivity(
      type: ActivityType.dataImport,
      description: 'Bulk import: $count vehicles created via CSV',
      userId: userId,
      metadata: {'count': count, 'action': 'bulk_import', 'type': 'vehicles'},
    );
  }

  Future<void> logBulkUsersDeleted(List<String> userIds, String? userId) async {
    await logActivity(
      type: ActivityType.userDeleted,
      description: 'Bulk deletion: ${userIds.length} users deleted',
      userId: userId,
      metadata: {
        'count': userIds.length,
        'userIds': userIds,
        'action': 'bulk_delete',
        'type': 'users',
      },
    );
  }

  Future<void> logBulkUserStatusUpdated(
    List<String> userIds,
    String newStatus,
    String? userId,
  ) async {
    await logActivity(
      type: ActivityType.userUpdated,
      description:
          'Bulk update: ${userIds.length} users status changed to $newStatus',
      userId: userId,
      metadata: {
        'count': userIds.length,
        'userIds': userIds,
        'newStatus': newStatus,
        'action': 'bulk_status_update',
        'type': 'users',
      },
    );
  }

  Future<void> logUserLoginUpdated(String userId, String? currentUser) async {
    await logActivity(
      type: ActivityType.userLogin,
      description: 'User login timestamp updated for user $userId',
      userId: currentUser,
      targetId: userId,
      metadata: {
        'targetUserId': userId,
        'action': 'login_update',
        'type': 'user_session',
      },
    );
  }

  Future<void> logBulkVehiclesDeleted(
    List<String> vehicleIds,
    String? userId,
  ) async {
    await logActivity(
      type: ActivityType.vehicleDeleted,
      description: 'Bulk deletion: ${vehicleIds.length} vehicles deleted',
      userId: userId,
      metadata: {
        'count': vehicleIds.length,
        'vehicleIds': vehicleIds,
        'action': 'bulk_delete',
        'type': 'vehicles',
      },
    );
  }

  Future<void> logBulkStatusUpdated(
    List<String> vehicleIds,
    String newStatus,
    String? userId,
  ) async {
    await logActivity(
      type: ActivityType.vehicleUpdated,
      description:
          'Bulk update: ${vehicleIds.length} vehicles status changed to $newStatus',
      userId: userId,
      metadata: {
        'count': vehicleIds.length,
        'vehicleIds': vehicleIds,
        'newStatus': newStatus,
        'action': 'bulk_status_update',
        'type': 'vehicles',
      },
    );
  }

  Future<void> logNavigation(
    String fromPage,
    String toPage,
    String? userId,
  ) async {
    await logActivity(
      type: ActivityType.systemNavigation,
      description: 'Navigated from $fromPage to $toPage',
      userId: userId,
      metadata: {'fromPage': fromPage, 'toPage': toPage, 'action': 'navigate'},
    );
  }

  Future<void> logError(String error, String? context, String? userId) async {
    await logActivity(
      type: ActivityType.systemError,
      description: 'System error: $error',
      userId: userId,
      metadata: {'error': error, 'context': context, 'action': 'error'},
    );
  }

  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${_getRandomString(8)}';
  }

  String _getRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    String result = '';

    for (int i = 0; i < length; i++) {
      result += chars[(random + i) % chars.length];
    }

    return result;
  }

  String? _getCurrentUserId() {
    try {
      return FirebaseAuth.instance.currentUser?.uid;
    } catch (e) {
      return null;
    }
  }
}

class ActivityLogRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'activities';

  Future<void> createLog(ActivityLog log) async {
    try {
      await _firestore.collection(_collection).doc(log.id).set(log.toMap());
    } catch (e) {
      throw ActivityLogException('Failed to create activity log: $e');
    }
  }

  Future<List<ActivityLog>> getLogs({
    DateTime? startDate,
    DateTime? endDate,
    String? userId,
    ActivityType? type,
    int limit = 100,
  }) async {
    try {
      Query query = _firestore.collection(_collection);

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

      final snapshot =
          await query.orderBy('timestamp', descending: true).limit(limit).get();

      return snapshot.docs
          .map((doc) => ActivityLog.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ActivityLogException('Failed to fetch activity logs: $e');
    }
  }

  Stream<List<ActivityLog>> getActivityLogsStream({
    DateTime? startDate,
    DateTime? endDate,
    String? userId,
    ActivityType? type,
    int limit = 100,
  }) {
    Query query = _firestore.collection(_collection);

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

    return query
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) =>
                        ActivityLog.fromMap(doc.data() as Map<String, dynamic>),
                  )
                  .toList(),
        );
  }
}

class ActivityLogException implements Exception {
  final String message;
  ActivityLogException(this.message);

  @override
  String toString() => 'ActivityLogException: $message';
}
