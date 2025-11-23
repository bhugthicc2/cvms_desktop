part of 'dashboard_cubit.dart';

class DashboardState {
  final List<VehicleEntry> allEntries;
  final List<VehicleEntry> enteredFiltered;
  final List<VehicleEntry> exitedFiltered;
  final int totalVehicles;
  final int totalViolations;
  final int totalEntered;
  final int totalExited;

  DashboardState({
    required this.allEntries,
    required this.enteredFiltered,
    required this.exitedFiltered,
    required this.totalVehicles,
    required this.totalViolations,
    required this.totalEntered,
    required this.totalExited,
  });

  factory DashboardState.initial() => DashboardState(
    allEntries: [],
    enteredFiltered: [],
    exitedFiltered: [],
    totalVehicles: 0,
    totalViolations: 0,
    totalEntered: 0,
    totalExited: 0,
  );

  DashboardState copyWith({
    List<VehicleEntry>? allEntries,
    List<VehicleEntry>? enteredFiltered,
    List<VehicleEntry>? exitedFiltered,
    int? totalVehicles,
    int? totalViolations,
    int? totalEntered,
    int? totalExited,
  }) {
    return DashboardState(
      allEntries: allEntries ?? this.allEntries,
      enteredFiltered: enteredFiltered ?? this.enteredFiltered,
      exitedFiltered: exitedFiltered ?? this.exitedFiltered,
      totalVehicles: totalVehicles ?? this.totalVehicles,
      totalViolations: totalViolations ?? this.totalViolations,
      totalEntered: totalEntered ?? this.totalEntered,
      totalExited: totalExited ?? this.totalExited,
    );
  }
}
