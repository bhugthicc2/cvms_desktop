import 'package:cvms_desktop/features/dashboard/models/dashboard/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/models/report/global_vehicle_report_model.dart';
import 'package:cvms_desktop/features/dashboard/repositories/report/global_report_repository.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/violation_history_entry.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/recent_log_entry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'report_assembler.dart';
import '../../models/report/date_range.dart';

class GlobalReportAssembler
    implements ReportAssembler<GlobalVehicleReportModel> {
  final GlobalReportRepository repository;

  GlobalReportAssembler(this.repository);

  @override
  Future<GlobalVehicleReportModel> assemble({required DateRange range}) async {
    final dateRange = DateRange(range.start, range.end, range.type);

    // Fetch in parallel
    final results = await Future.wait([
      repository.getTotalVehicles(),
      repository.getTotalFleetLogs(dateRange),
      repository.getTotalViolations(dateRange),
      repository.getPendingViolations(dateRange),
      repository.getVehicleDistributionPerCollege(),
      repository.getViolationsByType(dateRange),
      repository.getRecentViolations(dateRange, limit: 10),
      repository.getRecentLogs(dateRange, limit: 10),
      repository.getVehiclesByYearLevel(), //step 4 for adding a report entry
      repository.getVehiclesByCity(),
      repository.getVehicleLogsByCollege(dateRange),
      repository.getViolationDistributionByCollege(dateRange),
      repository.getFleetLogsTrend(dateRange),
      repository.getTopStudentsByViolations(dateRange),
    ]);

    // Convert raw violation data to ViolationHistoryEntry
    final rawViolations = results[7] as List<Map<String, dynamic>>;
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
    final vehiclesByYearLevel =
        results[8] as Map<String, int>; //step 6 for adding a report entry
    final vehiclesByCity = results[9] as Map<String, int>;
    final logsByCollege = results[10] as Map<String, int>;
    final violationsByCollege = results[11] as Map<String, int>;
    final trendMap = results[12] as Map<DateTime, int>;

    final fleetLogsTrend =
        trendMap.entries.map((entry) {
            return ChartDataModel(
              category: '${entry.key.year}-${entry.key.month}-${entry.key.day}',
              value: entry.value.toDouble(),
              date: entry.key,
            );
          }).toList()
          ..sort((a, b) => a.date!.compareTo(b.date!));
    final topStudentsByViolations = results[13] as List<ChartDataModel>;

    return GlobalVehicleReportModel(
      period: dateRange,
      totalVehicles: results[0] as int,
      totalFleetLogs: results[1] as int,
      totalViolations: results[2] as int,
      pendingViolations: results[3] as int,
      vehiclesPerCollege: results[4] as Map<String, int>,
      violationsByType: results[5] as Map<String, int>,
      fleetLogsTrend: fleetLogsTrend,
      recentViolations: recentViolations,
      recentLogs: recentLogs,
      vehiclesByYearLevel:
          vehiclesByYearLevel, //step 7 for adding a report entry
      vehiclesByCity: vehiclesByCity,
      logsByCollege: logsByCollege,
      violationsByCollege: violationsByCollege,
      topStudentsByViolations: topStudentsByViolations,
    );
  }
}
