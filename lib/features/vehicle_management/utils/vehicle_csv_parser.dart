import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
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

      // Parse registration dates if provided
      final Timestamp? registrationValidFrom = _parseDate(
        map['registrationvalidfrom'],
      );
      final Timestamp? registrationValidUntil = _parseDate(
        map['registrationvaliduntil'],
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
        createdAt: Timestamp.now(), // Set to current timestamp for CSV imports
        registrationValidFrom: registrationValidFrom,
        registrationValidUntil: registrationValidUntil,
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

  /// Helper method to parse date strings from CSV
  /// Accepts formats: MM/DD/YYYY, YYYY-MM-DD, or empty/null
  static Timestamp? _parseDate(String? dateString) {
    if (dateString == null || dateString.trim().isEmpty) {
      return null;
    }

    try {
      final trimmed = dateString.trim();

      // Try MM/DD/YYYY format first
      if (trimmed.contains('/')) {
        final parts = trimmed.split('/');
        if (parts.length == 3) {
          final month = int.parse(parts[0]);
          final day = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          return Timestamp.fromDate(DateTime(year, month, day));
        }
      }

      // Try YYYY-MM-DD format
      if (trimmed.contains('-')) {
        final parts = trimmed.split('-');
        if (parts.length == 3) {
          final year = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final day = int.parse(parts[2]);
          return Timestamp.fromDate(DateTime(year, month, day));
        }
      }
    } catch (e) {
      // If parsing fails, return null and let validation handle it
      return null;
    }

    return null;
  }
}
