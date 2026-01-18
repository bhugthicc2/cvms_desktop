import 'package:cloud_firestore/cloud_firestore.dart';

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
}
