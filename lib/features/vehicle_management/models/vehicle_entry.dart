import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleEntry {
  final String vehicleID;
  final String ownerName;
  final String schoolID;
  final String department;
  final String gender;
  final String yearLevel;
  final String block;
  final String contact;
  final String purok;
  final String barangay;
  final String city;
  final String province;
  final String plateNumber;
  final String vehicleType;
  final String vehicleModel;
  final String vehicleColor;
  final String licenseNumber;
  final String orNumber;
  final String crNumber;
  final String status;
  final Timestamp? createdAt;
  VehicleEntry({
    required this.vehicleID,
    required this.ownerName,
    required this.schoolID,
    required this.department,
    required this.gender,
    required this.purok,
    required this.barangay,
    required this.city,
    required this.yearLevel,
    required this.province,
    required this.block,
    required this.contact,
    required this.plateNumber,
    required this.vehicleType,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.licenseNumber,
    required this.orNumber,
    required this.crNumber,
    required this.status,
    this.createdAt,
  });

  factory VehicleEntry.fromMap(Map<String, dynamic> map, String id) {
    return VehicleEntry(
      vehicleID: id,
      ownerName: map['ownerName'] ?? '',
      schoolID: map['schoolID'] ?? '',
      department: map['department'] ?? '',
      gender: map['gender'] ?? '',
      yearLevel: map['yearLevel'] ?? '',
      block: map['block'] ?? '',
      contact: map['contact'] ?? '',
      purok: map['purok'] ?? '',
      barangay: map['barangay'] ?? '',
      city: map['city'] ?? '',
      province: map['province'] ?? '',
      plateNumber: map['plateNumber'] ?? '',
      vehicleType: map['vehicleType'] ?? '',
      vehicleModel: map['vehicleModel'] ?? '',
      vehicleColor: map['vehicleColor'] ?? '',
      licenseNumber: map['licenseNumber'] ?? '',
      orNumber: map['orNumber'] ?? '',
      crNumber: map['crNumber'] ?? '',
      status: map['status'] ?? '',
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerName': ownerName,
      'schoolID': schoolID,
      'department': department,
      'gender': gender,
      'yearLevel': yearLevel,
      'block': block,
      'contact': contact,
      'purok': purok,
      'barangay': barangay,
      'city': city,
      'province': province,
      'plateNumber': plateNumber,
      'vehicleType': vehicleType,
      'vehicleModel': vehicleModel,
      'vehicleColor': vehicleColor,
      'licenseNumber': licenseNumber,
      'orNumber': orNumber,
      'crNumber': crNumber,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
