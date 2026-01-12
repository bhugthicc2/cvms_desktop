import 'package:equatable/equatable.dart';

class FleetSummary extends Equatable {
  final int totalViolations;
  final int activeViolations;
  final int totalVehicles;
  final int totalEntriesExits;
  final double violationTrendPercent;
  final List<ViolationTypeCount> topViolationTypes;
  final List<TopVehicle> topWorstVehicles;

  const FleetSummary({
    required this.totalViolations,
    required this.activeViolations,
    required this.totalVehicles,
    required this.totalEntriesExits,
    this.violationTrendPercent = 0.0,
    this.topViolationTypes = const [],
    this.topWorstVehicles = const [],
  });

  @override
  List<Object?> get props => [
    totalViolations,
    activeViolations,
    totalVehicles,
    totalEntriesExits,
    violationTrendPercent,
    topViolationTypes,
    topWorstVehicles,
  ];
}

class ViolationTypeCount extends Equatable {
  final String type;
  final int count;
  const ViolationTypeCount({required this.type, required this.count});
  @override
  List<Object?> get props => [type, count];
}

class TopVehicle extends Equatable {
  final String plate;
  final String ownerName;
  final int violations;
  final double trendPercent;
  const TopVehicle({
    required this.plate,
    required this.ownerName,
    required this.violations,
    this.trendPercent = 0.0,
  });
  @override
  List<Object?> get props => [plate, ownerName, violations, trendPercent];
}
