import 'package:cvms_desktop/features/dashboard/data/chart_data_model.dart';
import 'package:equatable/equatable.dart';

enum TimeRange { days7, month, year }

enum DashboardViewMode {
  overview,
  enteredVehicles,
  exitedVehicles,
  violations,
  allVehicles,
  vehicleDistribution,
  vehicleLogsTrend,
  topViolations,
  topViolators,
}

class DashboardState extends Equatable {
  final bool loading;
  final List<ChartDataModel> vehicleDistribution;
  final List<ChartDataModel> topViolations;
  final List<ChartDataModel> allViolations;
  final List<ChartDataModel> weeklyTrend;
  final List<ChartDataModel> topViolators;
  final List<ChartDataModel> allViolators;
  final TimeRange selectedTimeRange;
  final DashboardViewMode viewMode;
  final String? error;

  const DashboardState({
    this.loading = false,
    this.vehicleDistribution = const [],
    this.topViolations = const [],
    this.allViolations = const [],
    this.weeklyTrend = const [],
    this.topViolators = const [],
    this.allViolators = const [],
    this.selectedTimeRange = TimeRange.days7,
    this.viewMode = DashboardViewMode.overview,
    this.error,
  });

  DashboardState copyWith({
    bool? loading,
    List<ChartDataModel>? vehicleDistribution,
    List<ChartDataModel>? topViolations,
    List<ChartDataModel>? allViolations,
    List<ChartDataModel>? weeklyTrend,
    List<ChartDataModel>? topViolators,
    List<ChartDataModel>? allViolators,
    TimeRange? selectedTimeRange,
    DashboardViewMode? viewMode,
    String? error,
  }) {
    return DashboardState(
      loading: loading ?? this.loading,
      vehicleDistribution: vehicleDistribution ?? this.vehicleDistribution,
      topViolations: topViolations ?? this.topViolations,
      allViolations: allViolations ?? this.allViolations,
      weeklyTrend: weeklyTrend ?? this.weeklyTrend,
      topViolators: topViolators ?? this.topViolators,
      allViolators: allViolators ?? this.allViolators,
      selectedTimeRange: selectedTimeRange ?? this.selectedTimeRange,
      viewMode: viewMode ?? this.viewMode,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    vehicleDistribution,
    topViolations,
    allViolations,
    weeklyTrend,
    topViolators,
    allViolators,
    selectedTimeRange,
    viewMode,
    error,
  ];
}
