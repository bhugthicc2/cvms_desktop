// DASHBOARD SEARCH FUNCTIONALITY STEP 1

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/dashboard2/models/dashboard/vehicle_search_result.dart';

class VehicleSearchRepository {
  final FirebaseFirestore _db;

  VehicleSearchRepository(this._db);

  Future<List<VehicleSearchResult>> searchVehicles(String query) async {
    if (query.isEmpty) return [];

    final queryLower = query.toLowerCase();

    // Plate number prefix search
    final plateSnapshot =
        await _db
            .collection('vehicles')
            .where('plateNumber', isGreaterThanOrEqualTo: query)
            .where('plateNumber', isLessThan: '${query}z')
            .limit(10)
            .get();

    // Owner / school ID fallback search
    final allVehiclesSnapshot = await _db.collection('vehicles').get();

    final results = <String, VehicleSearchResult>{};

    // Plate matches
    for (final doc in plateSnapshot.docs) {
      results[doc.id] = VehicleSearchResult(id: doc.id, data: doc.data());
    }

    // Owner name & school ID matches
    for (final doc in allVehiclesSnapshot.docs) {
      if (results.containsKey(doc.id)) continue;

      final data = doc.data();
      final ownerName = (data['ownerName'] as String? ?? '').toLowerCase();
      final schoolId = (data['schoolID'] as String? ?? '').toLowerCase();

      if (ownerName.contains(queryLower) || schoolId.contains(queryLower)) {
        results[doc.id] = VehicleSearchResult(id: doc.id, data: data);
      }
    }

    return results.values.take(10).toList();
  }

  Future<Map<String, dynamic>?> getVehicleById(String vehicleId) async {
    final doc = await _db.collection('vehicles').doc(vehicleId).get();

    if (!doc.exists) return null;
    return doc.data();
  }
}
