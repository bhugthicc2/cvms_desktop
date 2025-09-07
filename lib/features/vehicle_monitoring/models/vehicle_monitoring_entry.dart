class VehicleMonitoringEntry {
  final String status; // "inside" or "outside"
  final String name;
  final String vehicle;
  final String plateNumber;
  final Duration duration;
  final DateTime? entryTime;
  final DateTime? exitTime;

  const VehicleMonitoringEntry(
    this.status, {
    required this.name,
    required this.vehicle,
    required this.plateNumber,
    required this.duration,
    this.entryTime,
    this.exitTime,
  });

  VehicleMonitoringEntry copyWith({
    String? status,
    String? name,
    String? vehicle,
    String? plateNumber,
    Duration? duration,
    DateTime? entryTime,
    DateTime? exitTime,
  }) {
    return VehicleMonitoringEntry(
      status ?? this.status,
      name: name ?? this.name,
      vehicle: vehicle ?? this.vehicle,
      plateNumber: plateNumber ?? this.plateNumber,
      duration: duration ?? this.duration,
      entryTime: entryTime ?? this.entryTime,
      exitTime: exitTime ?? this.exitTime,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VehicleMonitoringEntry &&
        other.status == status &&
        other.name == name &&
        other.vehicle == vehicle &&
        other.plateNumber == plateNumber &&
        other.duration == duration &&
        other.entryTime == entryTime &&
        other.exitTime == exitTime;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        name.hashCode ^
        vehicle.hashCode ^
        plateNumber.hashCode ^
        duration.hashCode ^
        entryTime.hashCode ^
        exitTime.hashCode;
  }

  @override
  String toString() {
    return 'VehicleMonitoringEntry(status: $status, name: $name, vehicle: $vehicle, plateNumber: $plateNumber, duration: $duration, entryTime: $entryTime, exitTime: $exitTime)';
  }
}
