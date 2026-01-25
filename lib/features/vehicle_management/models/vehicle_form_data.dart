import '../../vehicle_management/models/vehicle_entry.dart';

class VehicleFormData {
  // Owner Information - Step 1
  final String? ownerName;
  final String? gender;
  final String? contact;
  final String? schoolId;
  final String? department;
  final String? yearLevel;
  final String? block;

  //Academic Enrollment (NEW)
  final String? academicYear;
  final String? semester;

  // Vehicle Information - Step 2
  final String? plateNumber;
  final String? vehicleModel;
  final String? vehicleColor;
  final String? vehicleType;

  // Legal Details - Step 3
  final String? licenseNumber;
  final String? orNumber;
  final String? crNumber;

  // Address Information - Step 4
  final String? region;
  final String? province;
  final String? municipality;
  final String? barangay;
  final String? purokStreet;

  const VehicleFormData({
    this.ownerName,
    this.gender,
    this.contact,
    this.schoolId,
    this.department,
    this.yearLevel,
    this.block,
    this.plateNumber,
    this.vehicleModel,
    this.vehicleColor,
    this.vehicleType,
    this.licenseNumber,
    this.orNumber,
    this.crNumber,
    this.region,
    this.province,
    this.municipality,
    this.barangay,
    this.purokStreet,
    this.academicYear,
    this.semester,
  });

  VehicleFormData copyWith({
    String? ownerName,
    String? gender,
    String? contact,
    String? schoolId,
    String? department,
    String? yearLevel,
    String? block,
    String? plateNumber,
    String? vehicleModel,
    String? vehicleColor,
    String? vehicleType,
    String? licenseNumber,
    String? orNumber,
    String? crNumber,
    String? region,
    String? province,
    String? municipality,
    String? barangay,
    String? purokStreet,
    String? academicYear,
    String? semester,
  }) {
    return VehicleFormData(
      ownerName: ownerName ?? this.ownerName,
      gender: gender ?? this.gender,
      contact: contact ?? this.contact,
      schoolId: schoolId ?? this.schoolId,
      department: department ?? this.department,
      yearLevel: yearLevel ?? this.yearLevel,
      block: block ?? this.block,
      plateNumber: plateNumber ?? this.plateNumber,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleColor: vehicleColor ?? this.vehicleColor,
      vehicleType: vehicleType ?? this.vehicleType,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      orNumber: orNumber ?? this.orNumber,
      crNumber: crNumber ?? this.crNumber,
      region: region ?? this.region,
      province: province ?? this.province,
      municipality: municipality ?? this.municipality,
      barangay: barangay ?? this.barangay,
      purokStreet: purokStreet ?? this.purokStreet,
      academicYear: academicYear ?? this.academicYear,
      semester: semester ?? this.semester,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VehicleFormData &&
        other.ownerName == ownerName &&
        other.gender == gender &&
        other.contact == contact &&
        other.schoolId == schoolId &&
        other.department == department &&
        other.yearLevel == yearLevel &&
        other.block == block &&
        other.plateNumber == plateNumber &&
        other.vehicleModel == vehicleModel &&
        other.vehicleColor == vehicleColor &&
        other.vehicleType == vehicleType &&
        other.licenseNumber == licenseNumber &&
        other.orNumber == orNumber &&
        other.crNumber == crNumber &&
        other.region == region &&
        other.province == province &&
        other.municipality == municipality &&
        other.barangay == barangay &&
        other.purokStreet == purokStreet &&
        other.academicYear == academicYear &&
        other.semester == semester;
  }

  @override
  int get hashCode {
    return Object.hash(
      ownerName,
      gender,
      contact,
      schoolId,
      department,
      yearLevel,
      block,
      plateNumber,
      vehicleModel,
      vehicleColor,
      vehicleType,
      licenseNumber,
      orNumber,
      crNumber,
      region,
      province,
      municipality,
      barangay,
      purokStreet,
      academicYear,
    );
  }

  @override
  String toString() {
    return 'VehicleFormData('
        'ownerName: $ownerName, '
        'gender: $gender, '
        'contact: $contact, '
        'schoolId: $schoolId, '
        'department: $department, '
        'yearLevel: $yearLevel, '
        'block: $block, '
        'plateNumber: $plateNumber, '
        'vehicleModel: $vehicleModel, '
        'vehicleColor: $vehicleColor, '
        'vehicleType: $vehicleType, '
        'licenseNumber: $licenseNumber, '
        'orNumber: $orNumber, '
        'crNumber: $crNumber, '
        'region: $region, '
        'province: $province, '
        'municipality: $municipality, '
        'barangay: $barangay, '
        'purokStreet: $purokStreet, '
        'academicYear: $academicYear, '
        'semester: $semester'
        ')';
  }

  // Convert VehicleFormData to VehicleEntry for Firestore saving
  VehicleEntry toVehicleEntry() {
    return VehicleEntry(
      vehicleId: '', // Will be generated by Firestore
      ownerName: ownerName ?? '',
      schoolID: schoolId ?? '',
      department: department ?? '',
      academicYear: academicYear ?? '',
      semester: semester ?? '',
      gender: gender ?? '',
      yearLevel: yearLevel ?? '',
      block: block ?? '',
      contact: contact ?? '',
      purok: purokStreet ?? '',
      barangay: barangay ?? '',
      city: municipality ?? '', // Map municipality to city field
      province: province ?? '',
      plateNumber: plateNumber ?? '',
      vehicleType: vehicleType ?? '',
      vehicleModel: vehicleModel ?? '',
      vehicleColor: vehicleColor ?? '',
      licenseNumber: licenseNumber ?? '',
      orNumber: orNumber ?? '',
      crNumber: crNumber ?? '',
      status: 'active', // Default status for new vehicles
      createdAt: null, // Firestore will set this
    );
  }
}
