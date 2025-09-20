import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle_entry.dart';

class DashboardRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //  Vehicle logs (entry/exit history)
  Stream<List<VehicleEntry>> streamVehicleLogs() {
    return _firestore.collection('vehicle_logs').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return VehicleEntry.fromMap(doc.data());
      }).toList();
    });
  }

  // Current vehicles (master list of registered vehicles)
  Future<int> getTotalVehicles() async {
    final snapshot = await _firestore.collection('vehicles').get();
    return snapshot.size; // quick count
  }

  // Violations
  Stream<int> streamTotalViolations() {
    return _firestore
        .collection('violations')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.size);
  }
}
