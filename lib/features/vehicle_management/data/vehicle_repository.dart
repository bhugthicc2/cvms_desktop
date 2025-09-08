import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle_entry.dart';

class VehicleRepository {
  final _firestore = FirebaseFirestore.instance;
  final _collection = 'vehicles';

  Future<List<VehicleEntry>> fetchVehicles() async {
    final snapshot = await _firestore.collection(_collection).get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return VehicleEntry.fromMap(data, doc.id);
    }).toList();
  }

  Future<void> addVehicle(VehicleEntry entry) async {
    await _firestore.collection(_collection).add(entry.toMap());
  }

  Future<void> updateVehicle(String id, Map<String, dynamic> updates) async {
    await _firestore.collection(_collection).doc(id).update(updates);
  }

  Future<void> deleteVehicle(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  Stream<List<VehicleEntry>> watchVehicles() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return VehicleEntry.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
}
