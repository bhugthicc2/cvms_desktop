import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';
import 'package:equatable/equatable.dart';

class FleetSummary extends Equatable {
  final int totalViolations;
  final int activeViolations;
  final int totalVehicles;
  final int totalEntriesExits;
  final double violationTrendPercent;
  final List<ViolationTypeCount> topViolationTypes;
  final List<ChartDataModel> departmentLogData;
  final List<ChartDataModel> deptViolationData;

  const FleetSummary({
    required this.totalViolations,
    required this.activeViolations,
    required this.totalVehicles,
    required this.totalEntriesExits,
    this.violationTrendPercent = 0.0,
    this.topViolationTypes = const [],
    this.departmentLogData = const [],
    this.deptViolationData = const [],
  });

  @override
  List<Object?> get props => [
    totalViolations,
    activeViolations,
    totalVehicles,
    totalEntriesExits,
    violationTrendPercent,
    topViolationTypes,
    departmentLogData,
    deptViolationData,
  ];
}

class ViolationTypeCount extends Equatable {
  final String type;
  final int count;
  const ViolationTypeCount({required this.type, required this.count});
  @override
  List<Object?> get props => [type, count];
}
