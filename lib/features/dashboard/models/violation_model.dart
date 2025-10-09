import 'package:cloud_firestore/cloud_firestore.dart';

class ViolationModel {
  final String violationID;
  final Timestamp dateTime;
  final String reportedBy;
  final String plateNumber;
  final String vehicleID;
  final String owner;
  final String violation;
  final String status;

  ViolationModel({
    required this.violationID,
    required this.dateTime,
    required this.reportedBy,
    required this.plateNumber,
    required this.vehicleID,
    required this.owner,
    required this.violation,
    required this.status,
  });

  factory ViolationModel.fromMap(Map<String, dynamic> map, String id) {
    return ViolationModel(
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

  ViolationModel copyWith({
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
    return ViolationModel(
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
}
