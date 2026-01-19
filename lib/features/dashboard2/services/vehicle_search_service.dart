// DASHBOARD SEARCH FUNCTIONALITY STEP 2

import 'package:cvms_desktop/features/dashboard2/models/vehicle_search_suggestion.dart';

import '../repositories/vehicle_search_repository.dart';
import '../models/individual_vehicle_report.dart';

class VehicleSearchService {
  final VehicleSearchRepository repository;

  VehicleSearchService(this.repository);

  /// Returns vehicle suggestions by searching plateNumber, ownerName, and schoolID
  Future<List<VehicleSearchSuggestion>> getSuggestions(String query) async {
    final results = await repository.searchVehicles(query);

    return results.map(VehicleSearchSuggestion.fromFirestore).toList();
  }

  /// Fetch full vehicle report by plate
  Future<IndividualVehicleReport?> getVehicleByPlate(String plateNumber) async {
    final results = await repository.searchVehicles(plateNumber);

    if (results.isEmpty) return null;

    return IndividualVehicleReport.fromFirestore(results.first);
  }
}
