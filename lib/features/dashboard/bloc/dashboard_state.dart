import '../models/chart_data_model.dart';
import 'package:equatable/equatable.dart';

enum TimeRange { days7, month, year }

class DashboardState extends Equatable {
  final bool loading;
  final List<ChartDataModel> vehicleDistribution;
  final List<ChartDataModel> topViolations;
  final List<ChartDataModel> weeklyTrend;
  final List<ChartDataModel> topViolators;
  final TimeRange selectedTimeRange;
  final String? error;

  const DashboardState({
    this.loading = false,
    this.vehicleDistribution = const [],
    this.topViolations = const [],
    this.weeklyTrend = const [],
    this.topViolators = const [],
    this.selectedTimeRange = TimeRange.days7,
    this.error,
  });

  DashboardState copyWith({
    bool? loading,
    List<ChartDataModel>? vehicleDistribution,
    List<ChartDataModel>? topViolations,
    List<ChartDataModel>? weeklyTrend,
    List<ChartDataModel>? topViolators,
    TimeRange? selectedTimeRange,
    String? error,
  }) {
    return DashboardState(
      loading: loading ?? this.loading,
      vehicleDistribution: vehicleDistribution ?? this.vehicleDistribution,
      topViolations: topViolations ?? this.topViolations,
      weeklyTrend: weeklyTrend ?? this.weeklyTrend,
      topViolators: topViolators ?? this.topViolators,
      selectedTimeRange: selectedTimeRange ?? this.selectedTimeRange,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    vehicleDistribution,
    topViolations,
    weeklyTrend,
    topViolators,
    selectedTimeRange,
    error,
  ];
}
