import 'package:cloud_firestore/cloud_firestore.dart';

class ViolationModel {
  final String violationId;
  final Timestamp createdAt;
  final Timestamp reportedAt;
  final String reportedByUserId;
  final String status;
  final String vehicleId;
  final String violationType;

  ViolationModel({
    required this.violationId,
    required this.createdAt,
    required this.reportedAt,
    required this.reportedByUserId,
    required this.status,
    required this.vehicleId,
    required this.violationType,
  });

  factory ViolationModel.fromMap(Map<String, dynamic> map, String id) {
    return ViolationModel(
      violationId: id,
      createdAt: map['createdAt'] ?? Timestamp.now(),
      reportedAt: map['reportedAt'] ?? Timestamp.now(),
      reportedByUserId: map['reportedByUserId'] ?? '',
      status: map['status'] ?? 'pending',
      vehicleId: map['vehicleId'] ?? '',
      violationType: map['violationType'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
      'reportedAt': reportedAt,
      'reportedByUserId': reportedByUserId,
      'status': status,
      'vehicleId': vehicleId,
      'violationType': violationType,
    };
  }

  ViolationModel copyWith({
    String? violationId,
    Timestamp? createdAt,
    Timestamp? reportedAt,
    String? reportedByUserId,
    String? status,
    String? vehicleId,
    String? violationType,
  }) {
    return ViolationModel(
      violationId: violationId ?? this.violationId,
      createdAt: createdAt ?? this.createdAt,
      reportedAt: reportedAt ?? this.reportedAt,
      reportedByUserId: reportedByUserId ?? this.reportedByUserId,
      status: status ?? this.status,
      vehicleId: vehicleId ?? this.vehicleId,
      violationType: violationType ?? this.violationType,
    );
  }
}
