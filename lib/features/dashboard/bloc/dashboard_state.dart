part of 'dashboard_cubit.dart';

class DashboardState {
  final List<VehicleEntry> allEntries;
  final List<VehicleEntry> enteredFiltered;
  final List<VehicleEntry> exitedFiltered;
  final int totalVehicles;
  final int totalViolations;

  DashboardState({
    required this.allEntries,
    required this.enteredFiltered,
    required this.exitedFiltered,
    required this.totalVehicles,
    required this.totalViolations,
  });

  factory DashboardState.initial() => DashboardState(
    allEntries: [],
    enteredFiltered: [],
    exitedFiltered: [],
    totalVehicles: 0,
    totalViolations: 0,
  );

  DashboardState copyWith({
    List<VehicleEntry>? allEntries,
    List<VehicleEntry>? enteredFiltered,
    List<VehicleEntry>? exitedFiltered,
    int? totalVehicles,
    int? totalViolations,
  }) {
    return DashboardState(
      allEntries: allEntries ?? this.allEntries,
      enteredFiltered: enteredFiltered ?? this.enteredFiltered,
      exitedFiltered: exitedFiltered ?? this.exitedFiltered,
      totalVehicles: totalVehicles ?? this.totalVehicles,
      totalViolations: totalViolations ?? this.totalViolations,
    );
  }

  int get totalEntered => allEntries.where((e) => e.status == "inside").length;
  int get totalExited => allEntries.where((e) => e.status == "outside").length;
}
