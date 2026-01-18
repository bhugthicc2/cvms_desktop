class GlobalViolationHistoryEntry {
  final String violationId;
  final DateTime dateTime;
  final String reportedBy;
  final String plateNumber;
  final String owner;
  final String violation;
  final String status;

  GlobalViolationHistoryEntry({
    required this.violationId,
    required this.dateTime,
    required this.reportedBy,
    required this.plateNumber,
    required this.owner,
    required this.violation,
    required this.status,
  });

  String get formattedDateTime {
    return '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.year.toString().substring(2)} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
