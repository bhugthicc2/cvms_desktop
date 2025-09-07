import '../models/vehicle_monitoring_entry.dart';

class VehicleMonitoringState {
  final List<VehicleMonitoringEntry> allEntries;
  final List<VehicleMonitoringEntry> enteredFiltered;
  final List<VehicleMonitoringEntry> exitedFiltered;
  final bool isLoading;
  final String? error;

  const VehicleMonitoringState({
    this.allEntries = const [],
    this.enteredFiltered = const [],
    this.exitedFiltered = const [],
    this.isLoading = false,
    this.error,
  });

  VehicleMonitoringState copyWith({
    List<VehicleMonitoringEntry>? allEntries,
    List<VehicleMonitoringEntry>? enteredFiltered,
    List<VehicleMonitoringEntry>? exitedFiltered,
    bool? isLoading,
    String? error,
  }) {
    return VehicleMonitoringState(
      allEntries: allEntries ?? this.allEntries,
      enteredFiltered: enteredFiltered ?? this.enteredFiltered,
      exitedFiltered: exitedFiltered ?? this.exitedFiltered,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VehicleMonitoringState &&
        other.allEntries == allEntries &&
        other.enteredFiltered == enteredFiltered &&
        other.exitedFiltered == exitedFiltered &&
        other.isLoading == isLoading &&
        other.error == error;
  }

  @override
  int get hashCode {
    return allEntries.hashCode ^
        enteredFiltered.hashCode ^
        exitedFiltered.hashCode ^
        isLoading.hashCode ^
        error.hashCode;
  }
}
