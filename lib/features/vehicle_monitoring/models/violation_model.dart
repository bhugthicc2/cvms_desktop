import 'package:cloud_firestore/cloud_firestore.dart';

class ViolationModel {
  final String violationId;
  final Timestamp dateTime;
  final String reportedBy;
  final String plateNumber;
  final String vehicleId;
  final String owner;
  final String violation;
  final String status;

  ViolationModel({
    required this.violationId,
    required this.dateTime,
    required this.reportedBy,
    required this.plateNumber,
    required this.vehicleId,
    required this.owner,
    required this.violation,
    required this.status,
  });

  factory ViolationModel.fromMap(Map<String, dynamic> map, String id) {
    return ViolationModel(
      violationId: id,
      dateTime: map['dateTime'] ?? Timestamp.now(),
      reportedBy: map['reportedBy'] ?? '',
      plateNumber: map['plateNumber'] ?? '',
      vehicleId: map['vehicleId'] ?? '',
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
      'vehicleID': vehicleId,
      'owner': owner,
      'violation': violation,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  ViolationModel copyWith({
    String? violationId,
    Timestamp? dateTime,
    String? reportedBy,
    String? plateNumber,
    String? vehicleId,
    String? owner,
    String? violation,
    String? status,
    String? reportReason,
  }) {
    return ViolationModel(
      violationId: violationId ?? this.violationId,
      dateTime: dateTime ?? this.dateTime,
      reportedBy: reportedBy ?? this.reportedBy,
      plateNumber: plateNumber ?? this.plateNumber,
      vehicleId: vehicleId ?? this.vehicleId,
      owner: owner ?? this.owner,
      violation: violation ?? this.violation,
      status: status ?? this.status,
    );
  }
}
