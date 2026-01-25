part of 'vehicle_monitoring_cubit.dart';

class VehicleMonitoringState {
  final List<VehicleModel> allEntries;
  final List<VehicleModel> enteredFiltered;
  final List<VehicleModel> exitedFiltered;
  final int totalVehicles;
  final int totalViolations;
  final int totalEntered;
  final int totalExited;
  final bool loading;

  VehicleMonitoringState({
    required this.allEntries,
    required this.enteredFiltered,
    required this.exitedFiltered,
    required this.totalVehicles,
    required this.totalViolations,
    required this.totalEntered,
    required this.totalExited,
    this.loading = false,
  });

  factory VehicleMonitoringState.initial() => VehicleMonitoringState(
    allEntries: [],
    enteredFiltered: [],
    exitedFiltered: [],
    totalVehicles: 0,
    totalViolations: 0,
    totalEntered: 0,
    totalExited: 0,
    loading: true,
  );

  VehicleMonitoringState copyWith({
    List<VehicleModel>? allEntries,
    List<VehicleModel>? enteredFiltered,
    List<VehicleModel>? exitedFiltered,
    int? totalVehicles,
    int? totalViolations,
    int? totalEntered,
    int? totalExited,
    bool? loading,
  }) {
    return VehicleMonitoringState(
      allEntries: allEntries ?? this.allEntries,
      enteredFiltered: enteredFiltered ?? this.enteredFiltered,
      exitedFiltered: exitedFiltered ?? this.exitedFiltered,
      totalVehicles: totalVehicles ?? this.totalVehicles,
      totalViolations: totalViolations ?? this.totalViolations,
      totalEntered: totalEntered ?? this.totalEntered,
      totalExited: totalExited ?? this.totalExited,
      loading: loading ?? this.loading,
    );
  }
}
