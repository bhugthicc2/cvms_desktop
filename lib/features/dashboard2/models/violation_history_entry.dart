import 'package:equatable/equatable.dart';

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

  // Computed properties
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isResolved => status.toLowerCase() == 'resolved';
  bool get isAppealed => status.toLowerCase() == 'appealed';

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
