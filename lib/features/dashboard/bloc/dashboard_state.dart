import '../models/chart_data_model.dart';
import 'package:equatable/equatable.dart';

class DashboardState extends Equatable {
  final bool loading;
  final List<ChartDataModel> vehicleDistribution;
  final List<ChartDataModel> topViolations;
  final List<ChartDataModel> weeklyTrend;
  final List<ChartDataModel> topViolators;
  final String? error;

  const DashboardState({
    this.loading = false,
    this.vehicleDistribution = const [],
    this.topViolations = const [],
    this.weeklyTrend = const [],
    this.topViolators = const [],
    this.error,
  });

  DashboardState copyWith({
    bool? loading,
    List<ChartDataModel>? vehicleDistribution,
    List<ChartDataModel>? topViolations,
    List<ChartDataModel>? monthlyTrend,
    List<ChartDataModel>? topViolators,
    String? error,
  }) {
    return DashboardState(
      loading: loading ?? this.loading,
      vehicleDistribution: vehicleDistribution ?? this.vehicleDistribution,
      topViolations: topViolations ?? this.topViolations,
      weeklyTrend: monthlyTrend ?? weeklyTrend,
      topViolators: topViolators ?? this.topViolators,
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
    error,
  ];
}
