import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';

class DashboardRepository {
  final FirebaseFirestore _db;

  DashboardRepository(this._db);
  //realtime implementation step 1
  /// Real-time total entries/exits
  Stream<int> watchTotalEntriesExits() {
    return _db.collection('vehicle_logs').snapshots().map((snapshot) {
      return snapshot.docs.length;
    });
  }

  Stream<int> watchTotalVehicles() {
    return _db.collection('vehicles').snapshots().map((snapshot) {
      return snapshot.docs.length;
    });
  }

  Stream<int> watchTotalViolations() {
    return _db.collection('violations').snapshots().map((snapshot) {
      return snapshot.docs.length;
    });
  }

  //realtime data retrieval based on collection field step 1
  Stream<int> watchTotalPendingViolations() {
    return _db
        .collection('violations')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  //real time grouped aggregation impl step 1
  Stream<List<ChartDataModel>> watchVehicleDistributionByDepartment() {
    return _db.collection('vehicles').snapshots().map((snapshot) {
      final Map<String, int> counts = {};

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final department = data['department'];

        if (department == null) continue;

        counts[department] = (counts[department] ?? 0) + 1;
      }

      return counts.entries
          .map(
            (entry) => ChartDataModel(
              category: entry.key,
              value: entry.value.toDouble(),
            ),
          )
          .toList();
    });
  }
}
