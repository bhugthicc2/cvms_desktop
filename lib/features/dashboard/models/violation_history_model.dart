class ViolationHistoryEntry {
  final String violationId;
  final DateTime dateTime;
  final String violationType;
  final String reportedBy;
  final String status;
  final DateTime createdAt;
  final DateTime lastUpdated;

  ViolationHistoryEntry({
    required this.violationId,
    required this.dateTime,
    required this.violationType,
    required this.reportedBy,
    required this.status,
    required this.createdAt,
    required this.lastUpdated,
  });
}
