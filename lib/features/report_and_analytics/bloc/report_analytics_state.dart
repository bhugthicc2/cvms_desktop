import '../models/chart_data_model.dart';
import 'package:equatable/equatable.dart';

class ReportAnalyticsState extends Equatable {
  final bool loading;
  final List<ChartDataModel> vehicleDistribution;
  final List<ChartDataModel> topViolations;
  final List<ChartDataModel> monthlyTrend;
  final List<ChartDataModel> topViolators;
  final String? error;

  const ReportAnalyticsState({
    this.loading = false,
    this.vehicleDistribution = const [],
    this.topViolations = const [],
    this.monthlyTrend = const [],
    this.topViolators = const [],
    this.error,
  });

  ReportAnalyticsState copyWith({
    bool? loading,
    List<ChartDataModel>? vehicleDistribution,
    List<ChartDataModel>? topViolations,
    List<ChartDataModel>? monthlyTrend,
    List<ChartDataModel>? topViolators,
    String? error,
  }) {
    return ReportAnalyticsState(
      loading: loading ?? this.loading,
      vehicleDistribution: vehicleDistribution ?? this.vehicleDistribution,
      topViolations: topViolations ?? this.topViolations,
      monthlyTrend: monthlyTrend ?? this.monthlyTrend,
      topViolators: topViolators ?? this.topViolators,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    vehicleDistribution,
    topViolations,
    monthlyTrend,
    topViolators,
    error,
  ];
}
