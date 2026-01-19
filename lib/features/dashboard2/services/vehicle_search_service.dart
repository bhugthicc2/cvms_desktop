// DASHBOARD SEARCH FUNCTIONALITY STEP 2

import 'package:cvms_desktop/features/dashboard2/models/vehicle_search_suggestion.dart';

import '../repositories/vehicle_search_repository.dart';
import '../models/individual_vehicle_info.dart';

class VehicleSearchService {
  final VehicleSearchRepository repository;

  VehicleSearchService(this.repository);

  Future<List<VehicleSearchSuggestion>> getSuggestions(String query) async {
    final results = await repository.searchVehicles(query);

    return results.map((result) {
      return VehicleSearchSuggestion.fromFirestore(result.id, result.data);
    }).toList();
  }

  Future<IndividualVehicleInfo?> getIndividualReport(String vehicleId) async {
    final data = await repository.getVehicleById(vehicleId);
    if (data == null) return null;

    return IndividualVehicleInfo.fromFirestore(vehicleId, data);
  }
}
