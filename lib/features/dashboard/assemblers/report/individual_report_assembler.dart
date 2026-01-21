import 'package:cvms_desktop/features/dashboard/models/report/individual_report_query.dart';
import 'package:cvms_desktop/features/dashboard/models/report/individual_vehicle_report_model.dart';
import 'package:cvms_desktop/features/dashboard/repositories/report/individual_report_repository.dart';

class IndividualReportAssembler {
  final IndividualReportRepository repository;

  IndividualReportAssembler(this.repository);

  Future<IndividualVehicleReportModel> assemble(
    IndividualReportQuery query,
  ) async {
    final range = query.range; // Use the original DateRange object

    final vehicle = await repository.getVehicleInfo(query.vehicleId);

    final metrics = await repository.getVehicleMetrics(query.vehicleId, range);

    final violations = await repository.getRecentViolations(query.vehicleId);

    final logs = await repository.getRecentLogs(query.vehicleId);

    final violationsByType = await repository.getViolationByType(
      query.vehicleId,
      range,
    );

    return IndividualVehicleReportModel(
      vehicle: vehicle,
      totalViolations: metrics.totalViolations,
      pendingViolations: metrics.pendingViolations,
      totalLogs: metrics.totalLogs,
      vehicleLogsTrend: metrics.logsTrend,
      recentViolations: violations,
      recentLogs: logs,
      period: range,
      violationsByType: violationsByType,
    );
  }
}
