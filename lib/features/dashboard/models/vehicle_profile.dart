class VehicleProfile {
  final String vehicleId;
  final String plateNumber;
  final String ownerName;
  final String model;
  final String vehicleType;
  final String department;
  final String status;
  final DateTime? registeredDate;
  final DateTime? createdAt;
  final DateTime? expiryDate;
  final int activeViolations;
  final int totalViolations;
  final int totalEntriesExits;

  const VehicleProfile({
    required this.vehicleId,
    required this.plateNumber,
    required this.ownerName,
    required this.model,
    required this.vehicleType,
    required this.department,
    required this.status,
    this.registeredDate,
    this.createdAt,
    this.expiryDate,
    this.activeViolations = 0,
    this.totalViolations = 0,
    this.totalEntriesExits = 0,
  });

  Null get schoolId => null;
}
