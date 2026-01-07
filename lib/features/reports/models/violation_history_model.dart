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

  // Mock data generator
  static List<ViolationHistoryEntry> getMockData() {
    final now = DateTime.now();
    return [
      ViolationHistoryEntry(
        violationId: 'V001',
        dateTime: now.subtract(const Duration(hours: 2)),
        violationType: 'Over Speeding',
        reportedBy: 'John Doe',
        status: 'Pending',
        createdAt: now.subtract(const Duration(hours: 2)),
        lastUpdated: now.subtract(const Duration(hours: 2)),
      ),
      ViolationHistoryEntry(
        violationId: 'V002',
        dateTime: now.subtract(const Duration(days: 1)),
        violationType: 'No Parking',
        reportedBy: 'Jane Smith',
        status: 'Resolved',
        createdAt: now.subtract(const Duration(days: 1)),
        lastUpdated: now.subtract(const Duration(hours: 12)),
      ),
      ViolationHistoryEntry(
        violationId: 'V003',
        dateTime: now.subtract(const Duration(days: 2)),
        violationType: 'Wrong Overtaking',
        reportedBy: 'Mike Johnson',
        status: 'In Progress',
        createdAt: now.subtract(const Duration(days: 2)),
        lastUpdated: now.subtract(const Duration(hours: 6)),
      ),
      ViolationHistoryEntry(
        violationId: 'V004',
        dateTime: now.subtract(const Duration(days: 3)),
        violationType: 'No Helmet',
        reportedBy: 'Sarah Wilson',
        status: 'Resolved',
        createdAt: now.subtract(const Duration(days: 3)),
        lastUpdated: now.subtract(const Duration(days: 2)),
      ),
      ViolationHistoryEntry(
        violationId: 'V005',
        dateTime: now.subtract(const Duration(days: 4)),
        violationType: 'Invalid License',
        reportedBy: 'Tom Brown',
        status: 'Pending',
        createdAt: now.subtract(const Duration(days: 4)),
        lastUpdated: now.subtract(const Duration(days: 4)),
      ),
      ViolationHistoryEntry(
        violationId: 'V006',
        dateTime: now.subtract(const Duration(days: 5)),
        violationType: 'Traffic Signal Violation',
        reportedBy: 'Emily Davis',
        status: 'Resolved',
        createdAt: now.subtract(const Duration(days: 5)),
        lastUpdated: now.subtract(const Duration(days: 4)),
      ),
      ViolationHistoryEntry(
        violationId: 'V007',
        dateTime: now.subtract(const Duration(days: 6)),
        violationType: 'Over Loading',
        reportedBy: 'Chris Martinez',
        status: 'In Progress',
        createdAt: now.subtract(const Duration(days: 6)),
        lastUpdated: now.subtract(const Duration(days: 1)),
      ),
      ViolationHistoryEntry(
        violationId: 'V008',
        dateTime: now.subtract(const Duration(days: 7)),
        violationType: 'No Parking',
        reportedBy: 'Lisa Anderson',
        status: 'Resolved',
        createdAt: now.subtract(const Duration(days: 7)),
        lastUpdated: now.subtract(const Duration(days: 6)),
      ),
    ];
  }
}
