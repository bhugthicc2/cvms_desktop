// DASHBOARD SEARCH FUNCTIONALITY STEP 2

import '../repositories/vehicle_search_repository.dart';
import '../models/individual_vehicle_report.dart';

class VehicleSearchService {
  final VehicleSearchRepository repository;

  VehicleSearchService(this.repository);

  /// Returns plate numbers for autocomplete
  Future<List<String>> getSuggestions(String query) async {
    final results = await repository.searchVehicles(query);

    return results.map((v) => v['plateNumber'] as String).toList();
  }

  /// Fetch full vehicle report by plate
  Future<IndividualVehicleReport?> getVehicleByPlate(String plateNumber) async {
    final results = await repository.searchVehicles(plateNumber);

    if (results.isEmpty) return null;

    return IndividualVehicleReport.fromFirestore(results.first);
  }
}
