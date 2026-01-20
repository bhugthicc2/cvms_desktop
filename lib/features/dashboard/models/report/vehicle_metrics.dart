import 'package:cvms_desktop/features/dashboard/models/dashboard/chart_data_model.dart';

class VehicleMetrics {
  final int totalViolations;
  final int pendingViolations;
  final int totalLogs;
  final List<ChartDataModel> logsTrend;

  const VehicleMetrics({
    required this.totalViolations,
    required this.pendingViolations,
    required this.totalLogs,
    required this.logsTrend,
  });
}
