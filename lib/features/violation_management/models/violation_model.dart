import 'package:cloud_firestore/cloud_firestore.dart';

class ViolationEntry {
  final String violationID;
  final Timestamp dateTime;
  final String reportedBy;
  final String plateNumber;
  final String vehicleID;
  final String owner;
  final String violation;
  final String status;

  ViolationEntry({
    required this.violationID,
    required this.dateTime,
    required this.reportedBy,
    required this.plateNumber,
    required this.vehicleID,
    required this.owner,
    required this.violation,
    required this.status,
  });

  factory ViolationEntry.fromMap(Map<String, dynamic> map, String id) {
    return ViolationEntry(
      violationID: id,
      dateTime: map['dateTime'] ?? Timestamp.now(),
      reportedBy: map['reportedBy'] ?? '',
      plateNumber: map['plateNumber'] ?? '',
      vehicleID: map['vehicleID'] ?? '',
      owner: map['owner'] ?? '',
      violation: map['violation'] ?? '',
      status: map['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime,
      'reportedBy': reportedBy,
      'plateNumber': plateNumber,
      'vehicleID': vehicleID,
      'owner': owner,
      'violation': violation,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  ViolationEntry copyWith({
    String? violationID,
    Timestamp? dateTime,
    String? reportedBy,
    String? plateNumber,
    String? vehicleID,
    String? owner,
    String? violation,
    String? status,
    String? reportReason,
  }) {
    return ViolationEntry(
      violationID: violationID ?? this.violationID,
      dateTime: dateTime ?? this.dateTime,
      reportedBy: reportedBy ?? this.reportedBy,
      plateNumber: plateNumber ?? this.plateNumber,
      vehicleID: vehicleID ?? this.vehicleID,
      owner: owner ?? this.owner,
      violation: violation ?? this.violation,
      status: status ?? this.status,
    );
  }

  static ViolationEntry sample() {
    return ViolationEntry(
      violationID: 'sample-violation-id',
      dateTime: Timestamp.now(),
      reportedBy: 'Sample Reporter',
      plateNumber: 'ABC-123',
      vehicleID: 'sample-vehicle-id',
      owner: 'Sample Owner',
      violation: 'Parking Violation',
      status: 'pending',
    );
  }
}
