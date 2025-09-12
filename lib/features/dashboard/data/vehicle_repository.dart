import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle_entry.dart';

class VehicleRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<VehicleEntry>> streamVehicleLogs() {
    return _firestore.collection('vehicle_logs').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return VehicleEntry.fromMap(data);
      }).toList();
    });
  }
}
