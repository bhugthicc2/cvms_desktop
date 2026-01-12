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

  // Mock data generator
  static List<GlobalVehicleLogsEntry> getMockData() {
    final now = DateTime.now();
    return [
      GlobalVehicleLogsEntry(
        logId: 'L001',
        ownerName: 'Juan Dela Cruz',
        vehicleModel: 'Toyota Vios',
        plateNumber: 'ABC-1234',
        updatedBy: 'John Doe',
        status: 'Completed',
        timeIn: now.subtract(const Duration(hours: 4)),
        timeOut: now.subtract(const Duration(hours: 2)),
        durationMinutes: 120,
      ),
      GlobalVehicleLogsEntry(
        logId: 'L002',
        ownerName: 'Maria Santos',
        vehicleModel: 'Honda Civic',
        plateNumber: 'XYZ-5678',
        updatedBy: 'Jane Smith',
        status: 'Completed',
        timeIn: now.subtract(const Duration(days: 1, hours: 3)),
        timeOut: now.subtract(const Duration(days: 1, hours: 1)),
        durationMinutes: 120,
      ),
      GlobalVehicleLogsEntry(
        logId: 'L003',
        ownerName: 'Jose Reyes',
        vehicleModel: 'Nissan Sentra',
        plateNumber: 'DEF-9012',
        updatedBy: 'Mike Johnson',
        status: 'Completed',
        timeIn: now.subtract(const Duration(days: 2, hours: 5)),
        timeOut: now.subtract(const Duration(days: 2, hours: 3)),
        durationMinutes: 120,
      ),
      GlobalVehicleLogsEntry(
        logId: 'L004',
        ownerName: 'Ana Garcia',
        vehicleModel: 'Mitsubishi Mirage',
        plateNumber: 'GHI-3456',
        updatedBy: 'Sarah Wilson',
        status: 'Completed',
        timeIn: now.subtract(const Duration(days: 3, hours: 2)),
        timeOut: now.subtract(const Duration(days: 3, hours: 1)),
        durationMinutes: 60,
      ),
      GlobalVehicleLogsEntry(
        logId: 'L005',
        ownerName: 'Carlos Mendoza',
        vehicleModel: 'Ford Ranger',
        plateNumber: 'JKL-7890',
        updatedBy: 'Tom Brown',
        status: 'Active',
        timeIn: now.subtract(const Duration(hours: 1)),
        timeOut: DateTime.now(),
        durationMinutes: 60,
      ),
      GlobalVehicleLogsEntry(
        logId: 'L006',
        ownerName: 'Sofia Rodriguez',
        vehicleModel: 'Toyota Hilux',
        plateNumber: 'MNO-2345',
        updatedBy: 'Emily Davis',
        status: 'Completed',
        timeIn: now.subtract(const Duration(days: 4, hours: 6)),
        timeOut: now.subtract(const Duration(days: 4, hours: 4)),
        durationMinutes: 120,
      ),
      GlobalVehicleLogsEntry(
        logId: 'L007',
        ownerName: 'Miguel Lopez',
        vehicleModel: 'Isuzu D-Max',
        plateNumber: 'PQR-6789',
        updatedBy: 'Chris Martinez',
        status: 'Completed',
        timeIn: now.subtract(const Duration(days: 5, hours: 3)),
        timeOut: now.subtract(const Duration(days: 5, hours: 2)),
        durationMinutes: 60,
      ),
      GlobalVehicleLogsEntry(
        logId: 'L008',
        ownerName: 'Linda Chen',
        vehicleModel: 'Hyundai Accent',
        plateNumber: 'STU-0123',
        updatedBy: 'Lisa Anderson',
        status: 'Completed',
        timeIn: now.subtract(const Duration(days: 6, hours: 4)),
        timeOut: now.subtract(const Duration(days: 6, hours: 2)),
        durationMinutes: 120,
      ),
    ];
  }

  String get duration {
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}
