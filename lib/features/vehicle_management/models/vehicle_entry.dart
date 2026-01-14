import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/vehicle_management/config/vehicle_form_config.dart';

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
  final String? status;
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
    this.status,
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

  // ----model validation----
  void validate() {
    // Required text fields
    if (ownerName.trim().isEmpty) {
      throw Exception('Owner name is required');
    }
    if (schoolID.trim().isEmpty) {
      throw Exception('School ID is required');
    }
    if (plateNumber.trim().isEmpty) {
      throw Exception('Plate number is required');
    }
    if (vehicleModel.trim().isEmpty) {
      throw Exception('Vehicle model is required');
    }
    if (licenseNumber.trim().isEmpty) {
      throw Exception('License number is required');
    }
    if (orNumber.trim().isEmpty) {
      throw Exception('OR number is required');
    }
    if (crNumber.trim().isEmpty) {
      throw Exception('CR number is required');
    }
    if (contact.trim().isEmpty) {
      throw Exception('Contact number is required');
    }

    // Dropdown validations against VehicleFormConfig
    bool inOptions(String key, String value) {
      final list = VehicleFormConfig.dropdownOptions[key];
      if (list == null) return true; // no options configured => skip
      return list.any((opt) => opt.value == value);
    }

    if (!inOptions('department', department)) {
      throw Exception('Invalid department: $department');
    }
    if (!inOptions('vehicleType', vehicleType)) {
      throw Exception('Invalid vehicle type: $vehicleType');
    }
    if (!inOptions('vehicleColor', vehicleColor)) {
      throw Exception('Invalid vehicle color: $vehicleColor');
    }
    // Status validation: allow empty string for new vehicles (status set when first log is created)
    if (status != null && !inOptions('status', status!)) {
      throw Exception('Invalid status: $status');
    }
    if (!inOptions('gender', gender)) {
      throw Exception('Invalid gender: $gender');
    }
    if (!inOptions('yearLevel', yearLevel)) {
      throw Exception('Invalid year level: $yearLevel');
    }
    if (!inOptions('block', block)) {
      throw Exception('Invalid block: $block');
    }

    // Location validation (basic)
    if (province.trim().isEmpty ||
        city.trim().isEmpty ||
        barangay.trim().isEmpty ||
        purok.trim().isEmpty) {
      throw Exception('Complete location is required');
    }

    // Basic format checks (keep lenient to avoid false negatives)
    // PH contact: allow 11-digit starting with 09, or 10-11 digits generic
    final contactOk = RegExp(r'^(09\d{9}|\d{10,11})$').hasMatch(contact);
    if (!contactOk) {
      throw Exception('Invalid contact number');
    }

    // Plate number: alphanumeric, spaces/dash allowed, at least 3 chars
    if (!RegExp(
      r'^[A-Z0-9\- ]{3,}$',
      caseSensitive: false,
    ).hasMatch(plateNumber)) {
      throw Exception('Invalid plate number');
    }

    // License/OR/CR: allow alphanumeric with dashes/spaces, min length
    bool alnumMin(String v) => RegExp(r'^[A-Za-z0-9\- ]{4,}$').hasMatch(v);
    if (!alnumMin(licenseNumber)) {
      throw Exception('Invalid license number');
    }
    if (!alnumMin(orNumber)) {
      throw Exception('Invalid OR number');
    }
    if (!alnumMin(crNumber)) {
      throw Exception('Invalid CR number');
    }
  }

  static VehicleEntry sample() {
    return VehicleEntry(
      vehicleID: 'sample-vehicle-id',
      ownerName: 'Sample Owner',
      schoolID: '2023-12345',
      department: 'College of Engineering',
      gender: 'Male',
      yearLevel: '3rd Year',
      block: 'Block A',
      contact: '09123456789',
      purok: 'Purok 1',
      barangay: 'Barangay Sample',
      city: 'Zamboanga City',
      province: 'Zamboanga del Sur',
      plateNumber: 'ABC-123',
      vehicleType: 'Motorcycle',
      vehicleModel: 'Honda XRM',
      vehicleColor: 'Black',
      licenseNumber: '1234567890',
      orNumber: 'OR-123456',
      crNumber: 'CR-123456',
      status: 'active',
      createdAt: Timestamp.now(),
    );
  }
}
