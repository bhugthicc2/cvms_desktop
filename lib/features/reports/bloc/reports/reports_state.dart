import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard_state.dart';
import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import '../../models/fleet_summary.dart';

class ReportsState extends Equatable {
  final bool showPdfPreview;
  final bool loading;
  final String? error;
  final FleetSummary? fleetSummary;
  final bool isGlobalMode;
  final List<ChartDataModel> logsData;
  final TimeRange selectedTimeRange;
  final List<ChartDataModel>? vehicleDistribution;
  final List<ChartDataModel>? yearLevelBreakdown;
  final List<ChartDataModel>? cityBreakdown;
  final List<ChartDataModel>? studentWithMostViolations;
  final Uint8List? vehicleDistributionChartBytes;
  final Uint8List? yearLevelBreakdownChartBytes;
  final Uint8List? studentwithMostViolationChartBytes;
  final Uint8List? cityBreakdownChartBytes;
  final Uint8List? vehicleLogsDistributionChartBytes;
  final Uint8List? violationDistributionPerCollegeChartBytes;
  final Uint8List? top5ViolationByTypeChartBytes;
  final Uint8List? fleetLogsChartBytes;
  const ReportsState({
    this.showPdfPreview = false,
    this.loading = false,
    this.error,
    this.fleetSummary,
    this.isGlobalMode = true,
    this.logsData = const [],
    this.selectedTimeRange = TimeRange.days7,
    this.vehicleDistribution,
    this.yearLevelBreakdown,
    this.cityBreakdown,
    this.studentWithMostViolations,
    this.vehicleDistributionChartBytes,
    this.yearLevelBreakdownChartBytes,
    this.studentwithMostViolationChartBytes,
    this.cityBreakdownChartBytes,
    this.vehicleLogsDistributionChartBytes,
    this.violationDistributionPerCollegeChartBytes,
    this.top5ViolationByTypeChartBytes,
    this.fleetLogsChartBytes,
  });

  ReportsState copyWith({
    bool? showPdfPreview,
    bool? loading,
    String? error,
    FleetSummary? fleetSummary,
    bool? isGlobalMode,
    List<ChartDataModel>? logsData,
    TimeRange? selectedTimeRange,
    List<ChartDataModel>? vehicleDistribution,
    List<ChartDataModel>? yearLevelBreakdown,
    List<ChartDataModel>? cityBreakdown,
    List<ChartDataModel>? studentWithMostViolations,
    Uint8List? vehicleDistributionChartBytes,
    Uint8List? yearLevelBreakdownChartBytes,
    Uint8List? studentwithMostViolationChartBytes,
    Uint8List? cityBreakdownChartBytes,
    Uint8List? vehicleLogsDistributionChartBytes,
    Uint8List? violationDistributionPerCollegeChartBytes,
    Uint8List? top5ViolationByTypeChartBytes,
    Uint8List? fleetLogsChartBytes,
  }) {
    return ReportsState(
      showPdfPreview: showPdfPreview ?? this.showPdfPreview,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      fleetSummary: fleetSummary ?? this.fleetSummary,
      isGlobalMode: isGlobalMode ?? this.isGlobalMode,
      logsData: logsData ?? this.logsData,
      selectedTimeRange: selectedTimeRange ?? this.selectedTimeRange,
      vehicleDistribution: vehicleDistribution ?? this.vehicleDistribution,
      yearLevelBreakdown: yearLevelBreakdown ?? this.yearLevelBreakdown,
      cityBreakdown: cityBreakdown ?? this.cityBreakdown,
      studentWithMostViolations:
          studentWithMostViolations ?? this.studentWithMostViolations,
      vehicleDistributionChartBytes:
          vehicleDistributionChartBytes ?? this.vehicleDistributionChartBytes,
      yearLevelBreakdownChartBytes:
          yearLevelBreakdownChartBytes ?? this.yearLevelBreakdownChartBytes,
      studentwithMostViolationChartBytes:
          studentwithMostViolationChartBytes ??
          this.studentwithMostViolationChartBytes,
      cityBreakdownChartBytes:
          cityBreakdownChartBytes ?? this.cityBreakdownChartBytes,
      vehicleLogsDistributionChartBytes:
          vehicleLogsDistributionChartBytes ??
          this.vehicleLogsDistributionChartBytes,
      violationDistributionPerCollegeChartBytes:
          violationDistributionPerCollegeChartBytes ??
          this.violationDistributionPerCollegeChartBytes,
      top5ViolationByTypeChartBytes:
          top5ViolationByTypeChartBytes ?? this.top5ViolationByTypeChartBytes,
      fleetLogsChartBytes: fleetLogsChartBytes ?? this.fleetLogsChartBytes,
    );
  }

  @override
  List<Object?> get props => [
    showPdfPreview,
    loading,
    error,
    fleetSummary,
    isGlobalMode,
    logsData,
    selectedTimeRange,
    vehicleDistribution,
    yearLevelBreakdown,
    cityBreakdown,
    studentWithMostViolations,
    vehicleDistributionChartBytes,
    yearLevelBreakdownChartBytes,
    studentwithMostViolationChartBytes,
    cityBreakdownChartBytes,
    vehicleLogsDistributionChartBytes,
    violationDistributionPerCollegeChartBytes,
    top5ViolationByTypeChartBytes,
    fleetLogsChartBytes,
  ];
}
