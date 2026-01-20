import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard2/models/report/global_vehicle_report_model.dart';
import 'package:cvms_desktop/features/dashboard2/repositories/report/global_report_repository.dart';
import 'package:cvms_desktop/features/dashboard2/models/dashboard/violation_history_entry.dart';
import 'package:cvms_desktop/features/dashboard2/models/dashboard/recent_log_entry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'report_assembler.dart';
import '../../models/report/date_range.dart';

class GlobalReportAssembler
    implements ReportAssembler<GlobalVehicleReportModel> {
  final GlobalReportRepository repository;

  GlobalReportAssembler(this.repository);

  @override
  Future<GlobalVehicleReportModel> assemble({required DateRange range}) async {
    final dateRange = DateRange(range.start, range.end);

    // Fetch in parallel
    final results = await Future.wait([
      repository.getTotalVehicles(),
      repository.getTotalFleetLogs(dateRange),
      repository.getTotalViolations(dateRange),
      repository.getPendingViolations(dateRange),
      repository.getViolationsByType(dateRange),
      repository.getFleetLogsTrend(dateRange),
      repository.getRecentViolations(dateRange, limit: 10),
      repository.getRecentLogs(dateRange, limit: 10),
    ]);

    // Convert map to ChartDataModel for fleetLogsTrend
    final fleetLogsTrendMap = results[5] as Map<String, int>;
    final fleetLogsTrend =
        fleetLogsTrendMap.entries.map((entry) {
          // Parse string date key back to DateTime
          final dateParts = entry.key.split('-');
          final date = DateTime(
            int.parse(dateParts[0]),
            int.parse(dateParts[1]),
            int.parse(dateParts[2]),
          );
          return ChartDataModel(
            category: entry.key,
            value: entry.value.toDouble(),
            date: date,
          );
        }).toList();

    // Convert raw violation data to ViolationHistoryEntry
    final rawViolations = results[6] as List<Map<String, dynamic>>;
    final recentViolations =
        rawViolations.map((data) {
          return ViolationHistoryEntry(
            violationId: data['id'] as String? ?? '',
            dateTime:
                data['reportedAt'] != null
                    ? (data['reportedAt'] as Timestamp).toDate()
                    : DateTime.now(),
            violationType: data['violationType'] as String? ?? '',
            reportedBy: data['reportedBy'] as String? ?? '',
            status: data['status'] as String? ?? '',
            createdAt:
                data['createdAt'] != null
                    ? (data['createdAt'] as Timestamp).toDate()
                    : DateTime.now(),
            lastUpdated:
                data['lastUpdated'] != null
                    ? (data['lastUpdated'] as Timestamp).toDate()
                    : DateTime.now(),
          );
        }).toList();

    // Convert raw log data to RecentLogEntry
    final rawLogs = results[7] as List<Map<String, dynamic>>;
    final recentLogs =
        rawLogs.map((data) {
          return RecentLogEntry(
            logId: data['id'] as String? ?? '',
            timeIn:
                data['timeIn'] != null
                    ? (data['timeIn'] as Timestamp).toDate()
                    : DateTime.now(),
            timeOut:
                data['timeOut'] != null
                    ? (data['timeOut'] as Timestamp).toDate()
                    : null,
            durationMinutes: data['durationMinutes'] as int?,
            status: data['status'] as String? ?? '',
            updatedBy: data['updatedBy'] as String? ?? '',
          );
        }).toList();

    return GlobalVehicleReportModel(
      period: dateRange,
      totalVehicles: results[0] as int,
      totalFleetLogs: results[1] as int,
      totalViolations: results[2] as int,
      pendingViolations: results[3] as int,
      violationsByType: results[4] as Map<String, int>,
      fleetLogsTrend: fleetLogsTrend,
      recentViolations: recentViolations,
      recentLogs: recentLogs,
    );
  }
}
