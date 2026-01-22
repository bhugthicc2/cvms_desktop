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
  final Map<String, int> vehiclesPerCollege;
  final DateRange period;
  final Map<String, int> vehiclesByYearLevel; //step 1 for adding a report entry
  final Map<String, int> vehiclesByCity;
  final Map<String, int> logsByCollege;
  final Map<String, int> violationsByCollege;
  final List<ChartDataModel> topStudentsByViolations;

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
    required this.vehiclesPerCollege,
    required this.vehiclesByYearLevel,
    required this.vehiclesByCity,
    required this.logsByCollege,
    required this.violationsByCollege,
    required this.topStudentsByViolations,
  });
}
