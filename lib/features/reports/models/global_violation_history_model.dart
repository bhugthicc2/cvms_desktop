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

  // Mock data generator
  static List<GlobalViolationHistoryEntry> getMockData() {
    final now = DateTime.now();
    return [
      GlobalViolationHistoryEntry(
        violationId: 'V001',
        dateTime: now.subtract(const Duration(hours: 2)),
        reportedBy: 'Officer Reyes',
        plateNumber: 'ABC-1234',
        owner: 'Juan Dela Cruz',
        violation: 'Over Speeding',
        status: 'Pending',
      ),
      GlobalViolationHistoryEntry(
        violationId: 'V002',
        dateTime: now.subtract(const Duration(days: 1, hours: 3)),
        reportedBy: 'Officer Santos',
        plateNumber: 'XYZ-5678',
        owner: 'Maria Santos',
        violation: 'Illegal Parking',
        status: 'Resolved',
      ),
      GlobalViolationHistoryEntry(
        violationId: 'V003',
        dateTime: now.subtract(const Duration(days: 2, hours: 5)),
        reportedBy: 'Officer Garcia',
        plateNumber: 'DEF-9012',
        owner: 'Jose Reyes',
        violation: 'No License',
        status: 'Resolved',
      ),
      GlobalViolationHistoryEntry(
        violationId: 'V004',
        dateTime: now.subtract(const Duration(days: 3, hours: 1)),
        reportedBy: 'Officer Mendoza',
        plateNumber: 'GHI-3456',
        owner: 'Ana Garcia',
        violation: 'Loud Muffler',
        status: 'Pending',
      ),
      GlobalViolationHistoryEntry(
        violationId: 'V005',
        dateTime: now.subtract(const Duration(days: 4, hours: 6)),
        reportedBy: 'Officer Rodriguez',
        plateNumber: 'JKL-7890',
        owner: 'Carlos Mendoza',
        violation: 'No Helmet',
        status: 'Resolved',
      ),
      GlobalViolationHistoryEntry(
        violationId: 'V006',
        dateTime: now.subtract(const Duration(days: 5, hours: 2)),
        reportedBy: 'Officer Lopez',
        plateNumber: 'MNO-2345',
        owner: 'Sofia Rodriguez',
        violation: 'Over Speeding',
        status: 'Pending',
      ),
      GlobalViolationHistoryEntry(
        violationId: 'V007',
        dateTime: now.subtract(const Duration(days: 6, hours: 4)),
        reportedBy: 'Officer Chen',
        plateNumber: 'PQR-6789',
        owner: 'Miguel Lopez',
        violation: 'Illegal Parking',
        status: 'Resolved',
      ),
      GlobalViolationHistoryEntry(
        violationId: 'V008',
        dateTime: now.subtract(const Duration(days: 7, hours: 1)),
        reportedBy: 'Officer Anderson',
        plateNumber: 'STU-0123',
        owner: 'Linda Chen',
        violation: 'No License',
        status: 'Pending',
      ),
    ];
  }

  String get formattedDateTime {
    return '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.year.toString().substring(2)} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
