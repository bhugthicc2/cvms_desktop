class GlobalVehicleLogsEntry {
  final String logId;
  final String ownerName;
  final String vehicleModel;
  final String plateNumber;
  final String updatedBy;
  final String status;
  final DateTime timeIn;
  final DateTime timeOut;
  final int durationMinutes;

  GlobalVehicleLogsEntry({
    required this.logId,
    required this.ownerName,
    required this.vehicleModel,
    required this.plateNumber,
    required this.updatedBy,
    required this.status,
    required this.timeIn,
    required this.timeOut,
    required this.durationMinutes,
  });

  String get duration {
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}
