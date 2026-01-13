import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard_state.dart';
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
  ];
}
