// VEHICLE ID REFERENCE UPDATE MARKER
import 'package:cloud_firestore/cloud_firestore.dart';

class ViolationEntry {
  final String id;
  final String vehicleId;
  final String reportedByUserId;
  final String violationType;
  final String status;
  final Timestamp reportedAt;
  final Timestamp? createdAt;
  final String ownerName;
  final String plateNumber;
  final String fullname;

  ViolationEntry({
    required this.id,
    required this.vehicleId,
    required this.reportedByUserId,
    required this.violationType,
    required this.status,
    required this.reportedAt,
    this.createdAt,
    this.ownerName = '',
    this.plateNumber = '',
    this.fullname = '',
  });

  factory ViolationEntry.fromMap(Map<String, dynamic> map, String id) {
    return ViolationEntry(
      id: id,
      vehicleId: map['vehicleId'] ?? '',
      reportedByUserId: map['reportedByUserId'] ?? '',
      violationType: map['violationType'] ?? '',
      status: map['status'] ?? 'pending',
      reportedAt: map['reportedAt'] ?? Timestamp.now(),
      createdAt: map['createdAt'],
      ownerName: map['ownerName'] ?? '',
      plateNumber: map['plateNumber'] ?? '',
      fullname: map['fullname'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vehicleId': vehicleId,
      'reportedByUserId': reportedByUserId,
      'violationType': violationType,
      'status': status,
      'reportedAt': reportedAt,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  ViolationEntry copyWith({
    String? status,
    String? ownerName,
    String? plateNumber,
    String? fullname,
  }) {
    return ViolationEntry(
      id: id,
      vehicleId: vehicleId,
      reportedByUserId: reportedByUserId,
      violationType: violationType,
      status: status ?? this.status,
      reportedAt: reportedAt,
      createdAt: createdAt,
      ownerName: ownerName ?? this.ownerName,
      plateNumber: plateNumber ?? this.plateNumber,
      fullname: fullname ?? this.fullname,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ViolationEntry &&
        runtimeType == other.runtimeType &&
        id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
