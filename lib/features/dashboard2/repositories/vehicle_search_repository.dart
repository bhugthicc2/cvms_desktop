// DASHBOARD SEARCH FUNCTIONALITY STEP 1

import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleSearchRepository {
  final FirebaseFirestore _db;

  VehicleSearchRepository(this._db);

  /// Search vehicles by plateNumber, ownerName, or schoolID
  Future<List<Map<String, dynamic>>> searchVehicles(String query) async {
    if (query.isEmpty) return [];

    final queryLower = query.toLowerCase();

    // Search by plateNumber (exact match and starts with)
    final plateSnapshot =
        await _db
            .collection('vehicles')
            .where('plateNumber', isGreaterThanOrEqualTo: query)
            .where('plateNumber', isLessThan: '${query}z')
            .limit(10)
            .get();

    // Get all vehicles for ownerName and schoolID search
    final allVehiclesSnapshot = await _db.collection('vehicles').get();

    final results = <String, Map<String, dynamic>>{};

    // Add plate number results
    for (final doc in plateSnapshot.docs) {
      results[doc.id] = doc.data();
    }

    // Add owner name and school ID matches (case-insensitive)
    for (final doc in allVehiclesSnapshot.docs) {
      if (results.containsKey(doc.id)) {
        continue; // Skip if already added from plate search
      }
      final data = doc.data();
      final ownerName = (data['ownerName'] as String? ?? '').toLowerCase();
      final schoolId = (data['schoolID'] as String? ?? '').toLowerCase();

      if (ownerName.contains(queryLower) || schoolId.contains(queryLower)) {
        results[doc.id] = data;
      }
    }

    return results.values.take(10).toList();
  }
}
