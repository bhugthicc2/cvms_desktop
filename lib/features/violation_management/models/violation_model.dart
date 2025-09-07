class ViolationEntry {
  final String dateTime;
  final String reportedBy;
  final String plateNumber;
  final String owner;
  final String violation;
  final String status;

  ViolationEntry({
    required this.dateTime,
    required this.reportedBy,
    required this.plateNumber,
    required this.owner,
    required this.violation,
    required this.status,
  });
}
