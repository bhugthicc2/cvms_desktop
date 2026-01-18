import 'package:cvms_desktop/features/dashboard2/models/recent_log_entry.dart';
import 'package:cvms_desktop/features/dashboard2/models/violation_history_entry.dart';

class MockTableData {
  /// Mock violation history entries for testing
  static List<ViolationHistoryEntry> getViolationHistoryEntries() {
    final now = DateTime.now();
    return [
      ViolationHistoryEntry(
        violationId: 'V001',
        dateTime: now.subtract(const Duration(days: 5, hours: 14, minutes: 30)),
        violationType: 'Speeding',
        reportedBy: 'Traffic Officer Smith',
        status: 'Pending',
        createdAt: now.subtract(
          const Duration(days: 5, hours: 14, minutes: 30),
        ),
        lastUpdated: now.subtract(const Duration(days: 5, hours: 15)),
      ),
      ViolationHistoryEntry(
        violationId: 'V002',
        dateTime: now.subtract(const Duration(days: 12, hours: 9, minutes: 15)),
        violationType: 'Illegal Parking',
        reportedBy: 'Security Guard Johnson',
        status: 'Resolved',
        createdAt: now.subtract(
          const Duration(days: 12, hours: 9, minutes: 15),
        ),
        lastUpdated: now.subtract(const Duration(days: 10, hours: 16)),
      ),
      ViolationHistoryEntry(
        violationId: 'V003',
        dateTime: now.subtract(
          const Duration(days: 25, hours: 11, minutes: 45),
        ),
        violationType: 'No Parking Permit',
        reportedBy: 'Parking Enforcement Davis',
        status: 'Appealed',
        createdAt: now.subtract(
          const Duration(days: 25, hours: 11, minutes: 45),
        ),
        lastUpdated: now.subtract(const Duration(days: 24, hours: 14)),
      ),
      ViolationHistoryEntry(
        violationId: 'V004',
        dateTime: now.subtract(
          const Duration(days: 30, hours: 16, minutes: 20),
        ),
        violationType: 'Wrong Lane Usage',
        reportedBy: 'Traffic Officer Wilson',
        status: 'Pending',
        createdAt: now.subtract(
          const Duration(days: 30, hours: 16, minutes: 20),
        ),
        lastUpdated: now.subtract(const Duration(days: 30, hours: 17)),
      ),
      ViolationHistoryEntry(
        violationId: 'V005',
        dateTime: now.subtract(const Duration(days: 45, hours: 8, minutes: 0)),
        violationType: 'Expired Registration',
        reportedBy: 'Campus Police Brown',
        status: 'Resolved',
        createdAt: now.subtract(const Duration(days: 45, hours: 8, minutes: 0)),
        lastUpdated: now.subtract(const Duration(days: 40, hours: 10)),
      ),
    ];
  }

  /// Mock recent log entries for testing
  static List<RecentLogEntry> getRecentLogEntries() {
    final now = DateTime.now();
    return [
      RecentLogEntry(
        logId: 'L001',
        timeIn: now.subtract(const Duration(hours: 8)),
        timeOut: now.subtract(const Duration(hours: 5)),
        durationMinutes: 180,
        status: 'Offsite',
        updatedBy: 'System',
      ),
      RecentLogEntry(
        logId: 'L002',
        timeIn: now.subtract(const Duration(days: 1, hours: 9)),
        timeOut: now.subtract(const Duration(days: 1, hours: 5)),
        durationMinutes: 240,
        status: 'Offsite',
        updatedBy: 'Juan Dela Cruz',
      ),
      RecentLogEntry(
        logId: 'L003',
        timeIn: now.subtract(const Duration(days: 2, hours: 14)),
        timeOut: null, // Still active
        durationMinutes: null,
        status: 'Onsite',
        updatedBy: 'Maria Santos',
      ),
      RecentLogEntry(
        logId: 'L004',
        timeIn: now.subtract(const Duration(days: 3, hours: 7)),
        timeOut: now.subtract(const Duration(days: 3, hours: 12)),
        durationMinutes: 300,
        status: 'Offsite',
        updatedBy: 'System',
      ),
      RecentLogEntry(
        logId: 'L005',
        timeIn: now.subtract(const Duration(days: 4, hours: 8)),
        timeOut: now.subtract(const Duration(days: 4, hours: 15)),
        durationMinutes: 420,
        status: 'Offsite',
        updatedBy: 'Carlos Rodriguez',
      ),
      RecentLogEntry(
        logId: 'L006',
        timeIn: now.subtract(const Duration(days: 5, hours: 6)),
        timeOut: null, // Still active
        durationMinutes: null,
        status: 'Onsite',
        updatedBy: 'Ana Lopez',
      ),
    ];
  }

  /// Get mock data for specific vehicle
  static List<ViolationHistoryEntry> getViolationHistoryForVehicle(
    String vehicleId,
  ) {
    // In real implementation, this would filter by vehicleId
    return getViolationHistoryEntries();
  }

  static List<RecentLogEntry> getRecentLogsForVehicle(String vehicleId) {
    // In real implementation, this would filter by vehicleId
    return getRecentLogEntries();
  }
}
