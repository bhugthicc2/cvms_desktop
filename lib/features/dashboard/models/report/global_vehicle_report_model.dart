import 'package:cvms_desktop/features/dashboard/models/dashboard/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/models/report/date_range.dart';
import '../dashboard/recent_log_entry.dart';
import '../dashboard/violation_history_entry.dart';

class GlobalVehicleReportModel {
  final int totalVehicles;
  final int totalFleetLogs;
  final int totalViolations;
  final int pendingViolations;

  final Map<String, int> violationsByType;
  final List<ChartDataModel> fleetLogsTrend;

  final List<ViolationHistoryEntry> recentViolations;
  final List<RecentLogEntry> recentLogs;

  final DateRange period;

  GlobalVehicleReportModel({
    required this.totalVehicles,
    required this.totalFleetLogs,
    required this.totalViolations,
    required this.pendingViolations,
    required this.violationsByType,
    required this.fleetLogsTrend,
    required this.recentViolations,
    required this.recentLogs,
    required this.period,
  });
}
