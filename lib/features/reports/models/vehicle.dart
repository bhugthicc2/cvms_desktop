import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  final String id;
  final String plateNumber;
  final String ownerName;
  final String vehicleModel;
  final String vehicleType;
  final String department;
  final String status;
  final DateTime createdAt;

  Vehicle({
    required this.id,
    required this.plateNumber,
    required this.ownerName,
    required this.vehicleModel,
    required this.vehicleType,
    required this.department,
    required this.status,
    required this.createdAt,
  });

  factory Vehicle.fromFirestore(DocumentSnapshot doc) {
    return Vehicle(
      id: doc.id,
      plateNumber: doc['plateNumber'] ?? '',
      ownerName: doc['ownerName'] ?? '',
      vehicleModel: doc['vehicleModel'] ?? '',
      vehicleType: doc['vehicleType'] ?? '',
      department: doc['department'] ?? '',
      status: doc['status'] ?? '',
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
    );
  }
}
