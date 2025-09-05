part of 'vehicle_cubit.dart';

class VehicleState {
  final List<VehicleEntry> allEntries;
  final List<VehicleEntry> filteredEntries;

  VehicleState({required this.filteredEntries, required this.allEntries});

  factory VehicleState.initial() =>
      VehicleState(allEntries: [], filteredEntries: []);

  VehicleState copyWith({
    List<VehicleEntry>? allEntries,
    List<VehicleEntry>? filteredEntries,
  }) {
    return VehicleState(
      allEntries: allEntries ?? this.allEntries,
      filteredEntries: filteredEntries ?? this.filteredEntries,
    );
  }
}
