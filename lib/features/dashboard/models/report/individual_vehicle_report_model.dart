import 'package:cvms_desktop/features/dashboard/models/dashboard/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/models/report/date_range.dart';
import '../dashboard/individual_vehicle_info.dart';
import '../dashboard/violation_history_entry.dart';
import '../dashboard/recent_log_entry.dart';

class IndividualVehicleReportModel {
  final IndividualVehicleInfo vehicle;
  final int totalViolations;
  final int pendingViolations;
  final int totalLogs;
  final List<ChartDataModel> vehicleLogsTrend;
  final List<ViolationHistoryEntry> recentViolations;
  final List<RecentLogEntry> recentLogs;
  final DateRange period;

  IndividualVehicleReportModel({
    required this.vehicle,
    required this.totalViolations,
    required this.pendingViolations,
    required this.totalLogs,
    required this.vehicleLogsTrend,
    required this.recentViolations,
    required this.recentLogs,
    required this.period,
  });
}
