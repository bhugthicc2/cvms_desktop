//ACTIVITY LOG 1

import 'package:cloud_firestore/cloud_firestore.dart';
import 'activity_type.dart';

class ActivityLog {
  final String id;
  final ActivityType type;
  final String description;
  final String? userId;
  final String? targetId;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;

  const ActivityLog({
    required this.id,
    required this.type,
    required this.description,
    this.userId,
    this.targetId,
    this.metadata,
    required this.timestamp,
  });

  factory ActivityLog.fromMap(Map<String, dynamic> map) {
    final typeString = map['type'] as String?;
    return ActivityLog(
      id: map['id'] as String,
      type:
          typeString != null
              ? ActivityType.values.firstWhere(
                (type) => type.name == typeString,
                orElse: () => ActivityType.systemError,
              )
              : ActivityType.systemError,
      description: map['description'] as String? ?? '',
      userId: map['userId'] as String?,
      targetId: map['targetId'] as String?,
      metadata: map['metadata'] as Map<String, dynamic>?,
      timestamp:
          map['timestamp'] != null
              ? map['timestamp'] is Timestamp
                  ? (map['timestamp'] as Timestamp).toDate()
                  : DateTime.tryParse(map['timestamp'] as String) ??
                      DateTime.now()
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'description': description,
      'userId': userId,
      'targetId': targetId,
      'metadata': metadata,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  ActivityLog copyWith({
    String? id,
    ActivityType? type,
    String? description,
    String? userId,
    String? targetId,
    Map<String, dynamic>? metadata,
    DateTime? timestamp,
  }) {
    return ActivityLog(
      id: id ?? this.id,
      type: type ?? this.type,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      targetId: targetId ?? this.targetId,
      metadata: metadata ?? this.metadata,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ActivityLog && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ActivityLog(id: $id, type: $type, description: $description, timestamp: $timestamp)';
  }
}
