import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard_state.dart';
import 'package:cvms_desktop/features/reports/models/vehicle_logs_model.dart';
import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import '../../models/fleet_summary.dart';
import '../../models/vehicle_profile.dart';
import '../../models/violation_history_model.dart';

enum ReportViewMode { global, individual, pdfPreview }

class ReportsState extends Equatable {
  final ReportViewMode viewMode;
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
  final VehicleProfile? selectedVehicleProfile;
  final List<ViolationHistoryEntry> pendingViolations;
  final List<ChartDataModel>? violationsByType;
  final List<ChartDataModel>? vehicleLogsForLast7Days;
  final List<ViolationHistoryEntry>? violationHistory;
  final List<VehicleLogsEntry>? vehicleLogs;

  const ReportsState({
    this.viewMode = ReportViewMode.global,
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
    this.selectedVehicleProfile,
    this.pendingViolations = const [],
    this.violationsByType,
    this.vehicleLogsForLast7Days,
    this.violationHistory,
    this.vehicleLogs,
  });

  ReportsState copyWith({
    ReportViewMode? viewMode,
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
    VehicleProfile? selectedVehicleProfile,
    List<ViolationHistoryEntry>? pendingViolations,
    List<ChartDataModel>? violationsByType,
    List<ChartDataModel>? vehicleLogsForLast7Days,
    List<ViolationHistoryEntry>? violationHistory,
    List<VehicleLogsEntry>? vehicleLogs,
  }) {
    return ReportsState(
      viewMode: viewMode ?? this.viewMode,
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
      selectedVehicleProfile:
          selectedVehicleProfile ?? this.selectedVehicleProfile,
      pendingViolations: pendingViolations ?? this.pendingViolations,
      violationsByType: violationsByType ?? this.violationsByType,
      vehicleLogsForLast7Days:
          vehicleLogsForLast7Days ?? this.vehicleLogsForLast7Days,
      violationHistory: violationHistory ?? this.violationHistory,
      vehicleLogs: vehicleLogs ?? this.vehicleLogs,
    );
  }

  @override
  List<Object?> get props => [
    viewMode,
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
    selectedVehicleProfile,
    pendingViolations,
    violationsByType,
    vehicleLogsForLast7Days,
    violationHistory,
    vehicleLogs,
  ];
}
