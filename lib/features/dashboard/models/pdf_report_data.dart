import 'dart:typed_data';
import 'dart:ui';
import 'package:cvms_desktop/features/dashboard/bloc/reports/reports_state.dart';
import 'package:cvms_desktop/features/dashboard/models/fleet_summary.dart';
import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard/dashboard_state.dart';

/// Data transfer object for PDF report data
class PdfReportData {
  final VoidCallback? onBackPressed;
  final FleetSummary? fleetSummary;
  final List<ChartDataModel>? vehicleDistribution;
  final List<ChartDataModel>? yearLevelBreakdown;
  final List<ChartDataModel>? cityBreakdown;
  final List<ChartDataModel>? studentWithMostViolations;
  final List<ChartDataModel> logsData;
  final TimeRange selectedTimeRange;
  final Uint8List? vehicleDistributionChartBytes;
  final Uint8List? yearLevelBreakdownChartBytes;
  final Uint8List? studentwithMostViolationChartBytes;
  final Uint8List? cityBreakdownChartBytes;
  final Uint8List? vehicleLogsDistributionChartBytes;
  final Uint8List? violationDistributionPerCollegeChartBytes;
  final Uint8List? top5ViolationByTypeChartBytes;
  final Uint8List? fleetLogsChartBytes;

  const PdfReportData({
    this.onBackPressed,
    this.fleetSummary,
    this.vehicleDistribution,
    this.yearLevelBreakdown,
    this.cityBreakdown,
    this.studentWithMostViolations,
    this.logsData = const [],
    this.selectedTimeRange = TimeRange.days7,
    this.vehicleDistributionChartBytes,
    this.yearLevelBreakdownChartBytes,
    this.studentwithMostViolationChartBytes,
    this.cityBreakdownChartBytes,
    this.vehicleLogsDistributionChartBytes,
    this.violationDistributionPerCollegeChartBytes,
    this.top5ViolationByTypeChartBytes,
    this.fleetLogsChartBytes,
  });

  /// Creates PdfReportData from ReportsState
  factory PdfReportData.fromReportsState({
    VoidCallback? onBackPressed,
    required ReportsState state,
  }) {
    return PdfReportData(
      onBackPressed: onBackPressed,
      fleetSummary: state.fleetSummary,
      vehicleDistribution: state.vehicleDistribution,
      yearLevelBreakdown: state.yearLevelBreakdown,
      cityBreakdown: state.cityBreakdown,
      studentWithMostViolations: state.studentWithMostViolations,
      logsData: state.logsData,
      selectedTimeRange: state.selectedTimeRange,
      vehicleDistributionChartBytes: state.vehicleDistributionChartBytes,
      yearLevelBreakdownChartBytes: state.yearLevelBreakdownChartBytes,
      studentwithMostViolationChartBytes:
          state.studentwithMostViolationChartBytes,
      cityBreakdownChartBytes: state.cityBreakdownChartBytes,
      vehicleLogsDistributionChartBytes:
          state.vehicleLogsDistributionChartBytes,
      violationDistributionPerCollegeChartBytes:
          state.violationDistributionPerCollegeChartBytes,
      top5ViolationByTypeChartBytes: state.top5ViolationByTypeChartBytes,
      fleetLogsChartBytes: state.fleetLogsChartBytes,
    );
  }
}
