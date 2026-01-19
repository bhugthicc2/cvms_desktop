// DASHBOARD SEARCH FUNCTIONALITY STEP 3

class IndividualVehicleReport {
  final String plateNumber;
  final String ownerName;
  final String vehicleType;

  IndividualVehicleReport({
    required this.plateNumber,
    required this.ownerName,
    required this.vehicleType,
  });

  factory IndividualVehicleReport.fromFirestore(Map<String, dynamic> data) {
    return IndividualVehicleReport(
      plateNumber: data['plateNumber'] ?? '',
      ownerName: data['ownerName'] ?? '',
      vehicleType: data['vehicleType'] ?? '',
    );
  }
}
