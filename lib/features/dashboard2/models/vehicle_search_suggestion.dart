class VehicleSearchSuggestion {
  final String vehicleId;
  final String plateNumber;
  final String ownerName;
  final String schoolId;

  const VehicleSearchSuggestion({
    required this.vehicleId,
    required this.plateNumber,
    required this.ownerName,
    required this.schoolId,
  });

  factory VehicleSearchSuggestion.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    return VehicleSearchSuggestion(
      vehicleId: id,
      plateNumber: data['plateNumber'] ?? '',
      ownerName: data['ownerName'] ?? '',
      schoolId: data['schoolID'] ?? '',
    );
  }
}
