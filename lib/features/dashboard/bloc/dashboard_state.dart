part of 'dashboard_cubit.dart';

class DashboardState {
  final List<VehicleEntry> allEntries;
  final List<VehicleEntry> enteredFiltered;
  final List<VehicleEntry> exitedFiltered;

  DashboardState({
    required this.allEntries,
    required this.enteredFiltered,
    required this.exitedFiltered,
  });

  factory DashboardState.initial() =>
      DashboardState(allEntries: [], enteredFiltered: [], exitedFiltered: []);

  DashboardState copyWith({
    List<VehicleEntry>? allEntries,
    List<VehicleEntry>? enteredFiltered,
    List<VehicleEntry>? exitedFiltered,
  }) {
    return DashboardState(
      allEntries: allEntries ?? this.allEntries,
      enteredFiltered: enteredFiltered ?? this.enteredFiltered,
      exitedFiltered: exitedFiltered ?? this.exitedFiltered,
    );
  }
}
