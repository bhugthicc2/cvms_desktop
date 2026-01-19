import 'package:cloud_firestore/cloud_firestore.dart';

class IndividualDashboardRepository {
  final FirebaseFirestore _db;

  IndividualDashboardRepository(this._db);

  Stream<int> watchTotalViolations(String vehicleId) {
    return _db
        .collection('violations')
        .where('vehicleId', isEqualTo: vehicleId)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }
}
