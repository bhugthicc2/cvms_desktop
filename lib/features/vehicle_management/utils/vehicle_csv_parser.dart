import 'dart:io';
import 'package:csv/csv.dart';
import 'package:cvms_desktop/features/vehicle_management/config/location_formatter.dart';
import 'package:cvms_desktop/features/vehicle_management/models/registration_status.dart';
import 'package:cvms_desktop/features/vehicle_management/models/vehicle_entry.dart';

class VehicleCsvParser {
  static Future<List<VehicleEntry>> parseCsv(File file) async {
    final csvString = await file.readAsString();
    final rows = const CsvToListConverter().convert(csvString);

    if (rows.isEmpty || rows.length < 2) {
      throw Exception('Empty or invalid CSV');
    }

    final headers =
        rows[0].map((h) => h.toString().trim().toLowerCase()).toList();
    final dataRows = rows.sublist(1);

    final List<VehicleEntry> entries = [];
    for (var i = 0; i < dataRows.length; i++) {
      final row = dataRows[i];
      if (row.length != headers.length) {
        throw Exception('Invalid row length at line ${i + 2}');
      }

      final map = Map<String, String>.fromIterables(
        headers,
        row.map((v) => v.toString().trim()),
      );

      final entry = VehicleEntry(
        vehicleId: '', // Auto-generated
        ownerName: map['ownername'] ?? '',
        schoolID: map['schoolid'] ?? '',
        department: map['department'] ?? '',
        gender: map['gender'] ?? '',
        yearLevel: map['yearlevel'] ?? '',
        block: map['block'] ?? '',
        contact: map['contact'] ?? '',
        purok: map['purok'] ?? '',
        barangay: LocationFormatter().toProperCase(map['barangay'] ?? ''),
        city: LocationFormatter().toProperCase(map['city'] ?? ''),
        province: LocationFormatter().toProperCase(map['province'] ?? ''),
        plateNumber: map['platenumber'] ?? '',
        vehicleType: map['vehicletype'] ?? 'two-wheeled', // Default
        vehicleModel: map['vehiclemodel'] ?? '',
        vehicleColor: map['vehiclecolor'] ?? '',
        licenseNumber: map['licensenumber'] ?? '',
        orNumber: map['ornumber'] ?? '',
        crNumber: map['crnumber'] ?? '',
        status: '',
        registrationStatus: RegistrationStatus.active,
        academicYear: map['academicyear'] ?? '',
        semester:
            map['semester'] ??
            '', // Empty - status will be set when vehicle has first log/transaction
      );

      entry.validate(); // Throws if invalid
      entries.add(entry);
    }

    return entries;
  }
}
