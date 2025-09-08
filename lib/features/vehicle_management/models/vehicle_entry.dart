import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleEntry {
  final String vehicleID;
  final String ownerName;
  final String schoolID;
  final String plateNumber;
  final String vehicleType;
  final String vehicleModel;
  final String vehicleColor;
  final String licenseNumber;
  final String orNumber;
  final String crNumber;
  final String status;
  final String qrCodeID;
  final Timestamp? createdAt;
  VehicleEntry({
    required this.vehicleID,
    required this.ownerName,
    required this.schoolID,
    required this.plateNumber,
    required this.vehicleType,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.licenseNumber,
    required this.orNumber,
    required this.crNumber,
    required this.status,
    required this.qrCodeID,
    this.createdAt,
  });

  factory VehicleEntry.fromMap(Map<String, dynamic> map, String id) {
    return VehicleEntry(
      vehicleID: id,
      ownerName: map['ownerName'] ?? '',
      schoolID: map['schoolID'] ?? '',
      plateNumber: map['plateNumber'] ?? '',
      vehicleType: map['vehicleType'] ?? '',
      vehicleModel: map['vehicleModel'] ?? '',
      vehicleColor: map['vehicleColor'] ?? '',
      licenseNumber: map['licenseNumber'] ?? '',
      orNumber: map['orNumber'] ?? '',
      crNumber: map['crNumber'] ?? '',
      status: map['status'] ?? '',
      qrCodeID: map['qrCodeID'] ?? '',
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerName': ownerName,
      'schoolID': schoolID,
      'plateNumber': plateNumber,
      'vehicleType': vehicleType,
      'vehicleModel': vehicleModel,
      'vehicleColor': vehicleColor,
      'licenseNumber': licenseNumber,
      'orNumber': orNumber,
      'crNumber': crNumber,
      'status': status,
      'qrCodeID': qrCodeID,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
