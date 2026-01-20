import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViolationHistoryEntry extends Equatable {
  final String violationId;
  final DateTime dateTime;
  final String violationType;
  final String reportedBy;
  final String status;
  final DateTime createdAt;
  final DateTime lastUpdated;

  const ViolationHistoryEntry({
    required this.violationId,
    required this.dateTime,
    required this.violationType,
    required this.reportedBy,
    required this.status,
    required this.createdAt,
    required this.lastUpdated,
  });

  // Factory constructor for creating from Firestore data
  factory ViolationHistoryEntry.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    return ViolationHistoryEntry(
      violationId: id,
      dateTime:
          data['reportedAt'] != null
              ? (data['reportedAt'] as Timestamp).toDate()
              : DateTime.now(),
      violationType: data['violationType'] as String? ?? '',
      reportedBy: data['reportedBy'] as String? ?? '',
      status: data['status'] as String? ?? '',
      createdAt:
          data['createdAt'] != null
              ? (data['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
      lastUpdated:
          data['lastUpdated'] != null
              ? (data['lastUpdated'] as Timestamp).toDate()
              : DateTime.now(),
    );
  }

  // Computed properties
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isResolved => status.toLowerCase() == 'resolved';

  @override
  List<Object?> get props => [
    violationId,
    dateTime,
    violationType,
    reportedBy,
    status,
    createdAt,
    lastUpdated,
  ];
}
