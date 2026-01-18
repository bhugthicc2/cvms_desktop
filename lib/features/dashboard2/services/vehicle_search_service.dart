import 'package:cvms_desktop/features/dashboard2/data/mock_individual_data.dart';
import 'package:cvms_desktop/features/dashboard2/models/individual_vehicle_report.dart';

class VehicleSearchService {
  static List<String> getVehicleSuggestions(String query) {
    if (query.isEmpty) return [];

    return MockIndividualData.searchResults
        .where((vehicle) => _matchesQuery(vehicle, query))
        .map((vehicle) => vehicle.plateNumber)
        .toList();
  }

  static IndividualVehicleReport getVehicleByPlate(String plateNumber) {
    return MockIndividualData.searchResults.firstWhere(
      (vehicle) => vehicle.plateNumber == plateNumber,
      orElse: () => MockIndividualData.sampleReport,
    );
  }

  static bool _matchesQuery(IndividualVehicleReport vehicle, String query) {
    final lowerQuery = query.toLowerCase();
    return vehicle.plateNumber.toLowerCase().contains(lowerQuery) ||
        vehicle.ownerName.toLowerCase().contains(lowerQuery) ||
        vehicle.vehicleType.toLowerCase().contains(lowerQuery);
  }
}
