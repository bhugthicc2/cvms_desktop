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

  // Mock data generator
  static List<VehicleLogsEntry> getMockData() {
    final now = DateTime.now();
    return [
      VehicleLogsEntry(
        logId: 'L001',
        timeIn: now.subtract(const Duration(hours: 4)),
        timeOut: now.subtract(const Duration(hours: 2)),
        durationMinutes: 120,
        status: 'offsite',
        updatedBy: 'John Doe',
      ),
      VehicleLogsEntry(
        logId: 'L002',
        timeIn: now.subtract(const Duration(days: 1, hours: 3)),
        timeOut: now.subtract(const Duration(days: 1, hours: 1)),
        durationMinutes: 120,
        status: 'offsite',
        updatedBy: 'Jane Smith',
      ),
      VehicleLogsEntry(
        logId: 'L003',
        timeIn: now.subtract(const Duration(days: 2, hours: 5)),
        timeOut: now.subtract(const Duration(days: 2, hours: 3)),
        durationMinutes: 120,
        status: 'offsite',
        updatedBy: 'Mike Johnson',
      ),
      VehicleLogsEntry(
        logId: 'L004',
        timeIn: now.subtract(const Duration(days: 3, hours: 2)),
        timeOut: now.subtract(const Duration(days: 3, hours: 1)),
        durationMinutes: 60,
        status: 'offsite',
        updatedBy: 'Sarah Wilson',
      ),
      VehicleLogsEntry(
        logId: 'L005',
        timeIn: now.subtract(const Duration(hours: 1)),
        timeOut: DateTime.now(), // Still active
        durationMinutes: 60,
        status: 'onsite',
        updatedBy: 'Tom Brown',
      ),
      VehicleLogsEntry(
        logId: 'L006',
        timeIn: now.subtract(const Duration(days: 4, hours: 6)),
        timeOut: now.subtract(const Duration(days: 4, hours: 4)),
        durationMinutes: 120,
        status: 'offsite',
        updatedBy: 'Emily Davis',
      ),
      VehicleLogsEntry(
        logId: 'L007',
        timeIn: now.subtract(const Duration(days: 5, hours: 3)),
        timeOut: now.subtract(const Duration(days: 5, hours: 2)),
        durationMinutes: 60,
        status: 'offsite',
        updatedBy: 'Chris Martinez',
      ),
      VehicleLogsEntry(
        logId: 'L008',
        timeIn: now.subtract(const Duration(days: 6, hours: 4)),
        timeOut: now.subtract(const Duration(days: 6, hours: 2)),
        durationMinutes: 120,
        status: 'offsite',
        updatedBy: 'Lisa Anderson',
      ),
    ];
  }
}
