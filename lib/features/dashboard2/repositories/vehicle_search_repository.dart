// DASHBOARD SEARCH FUNCTIONALITY STEP 1

import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleSearchRepository {
  final FirebaseFirestore _db;

  VehicleSearchRepository(this._db);

  /// Fetch vehicles whose plate starts with query
  Future<List<Map<String, dynamic>>> searchVehicles(String query) async {
    if (query.isEmpty) return [];

    final snapshot =
        await _db
            .collection('vehicles')
            .where('plateNumber', isGreaterThanOrEqualTo: query)
            .where('plateNumber', isLessThan: '${query}z')
            .limit(10)
            .get();

    return snapshot.docs.map((d) => d.data()).toList();
  }
}
