class VehicleSearchSuggestion {
  final String plateNumber;
  final String ownerName;
  final String schoolId;

  const VehicleSearchSuggestion({
    required this.plateNumber,
    required this.ownerName,
    required this.schoolId,
  });

  factory VehicleSearchSuggestion.fromFirestore(Map<String, dynamic> data) {
    return VehicleSearchSuggestion(
      plateNumber: data['plateNumber'] ?? '',
      ownerName: data['ownerName'] ?? '',
      schoolId: data['schoolID'] ?? '',
    );
  }
}
