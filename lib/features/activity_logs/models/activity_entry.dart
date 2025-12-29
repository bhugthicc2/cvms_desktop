import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum ActivityType {
  vehicleAdded,
  vehicleUpdated,
  vehicleDeleted,
  violationReported,
  userLoggedIn,
  userLoggedOut,
  userCreated,
  userUpdated,
  userDeleted,
  passwordReset,
  // Add more activity types as needed
}

class ActivityLog extends Equatable {
  final String id;
  final ActivityType type;
  final String description;
  final String? userId; // ID of the user who performed the action
  final String? userEmail; // Email of the user who performed the action
  final String?
  targetId; // ID of the entity being acted upon (vehicle, user, etc.)
  final String? targetType; // Type of entity (e.g., 'vehicle', 'user')
  final Map<String, dynamic>? metadata; // Additional context-specific data
  final DateTime timestamp;

  const ActivityLog({
    required this.id,
    required this.type,
    required this.description,
    this.userId,
    this.userEmail,
    this.targetId,
    this.targetType,
    this.metadata,
    required this.timestamp,
  });

  factory ActivityLog.create({
    required ActivityType type,
    required String description,
    String? userId,
    String? userEmail,
    String? targetId,
    String? targetType,
    Map<String, dynamic>? metadata,
  }) {
    return ActivityLog(
      id: '',
      type: type,
      description: description,
      userId: userId,
      userEmail: userEmail,
      targetId: targetId,
      targetType: targetType,
      metadata: metadata,
      timestamp: DateTime.now(),
    );
  }

  factory ActivityLog.fromMap(Map<String, dynamic> map, String id) {
    return ActivityLog(
      id: id,
      type: ActivityType.values.firstWhere(
        (e) => e.toString() == 'ActivityType.${map['type']}',
        orElse: () => ActivityType.vehicleAdded,
      ),
      description: map['description'] ?? '',
      userId: map['userId'],
      userEmail: map['userEmail'],
      targetId: map['targetId'],
      targetType: map['targetType'],
      metadata:
          map['metadata'] != null
              ? Map<String, dynamic>.from(map['metadata'])
              : null,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.toString().split('.').last,
      'description': description,
      if (userId != null) 'userId': userId,
      if (userEmail != null) 'userEmail': userEmail,
      if (targetId != null) 'targetId': targetId,
      if (targetType != null) 'targetType': targetType,
      if (metadata != null) 'metadata': metadata,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  @override
  List<Object?> get props => [
    id,
    type,
    description,
    userId,
    userEmail,
    targetId,
    targetType,
    metadata,
    timestamp,
  ];
}
