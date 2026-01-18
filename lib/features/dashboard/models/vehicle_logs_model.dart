class VehicleLogsEntry {
  final String logId;
  final DateTime timeIn;
  final DateTime timeOut;
  final int durationMinutes;
  final String status;
  final String updatedBy;

  VehicleLogsEntry({
    required this.logId,
    required this.timeIn,
    required this.timeOut,
    required this.durationMinutes,
    required this.status,
    required this.updatedBy,
  });
}
