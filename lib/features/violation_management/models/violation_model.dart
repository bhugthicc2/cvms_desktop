import 'package:cloud_firestore/cloud_firestore.dart';
import 'violation_enums.dart';

class ViolationEntry {
  final String id;

  /// References
  final String vehicleId;
  final String reportedByUserId;

  /// Violation details
  final String violationType;
  final ViolationStatus status;

  /// Sanction / impact to vehicle
  /// null = no vehicle impact yet
  /// suspension | revocation
  final String? sanctionType;
  final bool sanctionApplied;

  /// Timestamps
  final Timestamp reportedAt;
  final Timestamp? createdAt;
  final Timestamp? reviewedAt;

  /// Enriched fields (joined data)
  final String ownerName;
  final String plateNumber;
  final String fullname;

  const ViolationEntry({
    required this.id,
    required this.vehicleId,
    required this.reportedByUserId,
    required this.violationType,
    required this.status,
    required this.reportedAt,
    this.sanctionType,
    required this.sanctionApplied,
    this.createdAt,
    this.reviewedAt,
    this.ownerName = '',
    this.plateNumber = '',
    this.fullname = '',
  });

  // Firestore mapping

  static ViolationStatus _parseStatus(dynamic statusValue) {
    if (statusValue == null) return ViolationStatus.pending;

    final statusString = statusValue.toString().toLowerCase();

    switch (statusString) {
      case 'pending':
        return ViolationStatus.pending;
      case 'confirmed':
        return ViolationStatus.confirmed;
      case 'dismissed':
        return ViolationStatus.dismissed;
      case 'suspended':
        return ViolationStatus.sanctioned;
      default:
        // Try to match by enum name as fallback
        try {
          return ViolationStatus.values.firstWhere(
            (e) => e.name.toLowerCase() == statusString,
            orElse: () => ViolationStatus.pending,
          );
        } catch (e) {
          return ViolationStatus.pending;
        }
    }
  }

  factory ViolationEntry.fromMap(Map<String, dynamic> map, String id) {
    return ViolationEntry(
      id: id,
      vehicleId: map['vehicleId'] ?? '',
      reportedByUserId: map['reportedByUserId'] ?? '',
      violationType: map['violationType'] ?? '',

      status: _parseStatus(map['status']),

      sanctionType: map['sanctionType'],
      sanctionApplied: map['sanctionApplied'] ?? false,
      reportedAt: map['reportedAt'] ?? Timestamp.now(),
      createdAt: map['createdAt'],
      reviewedAt: map['reviewedAt'],

      // enriched fields (optional)
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
      'status': status.name,
      'sanctionType': sanctionType,
      'reportedAt': reportedAt,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'reviewedAt': reviewedAt,
    };
  }

  bool get isPending => status == ViolationStatus.pending;
  bool get isConfirmed => status == ViolationStatus.confirmed;
  bool get isDismissed => status == ViolationStatus.dismissed;
  bool get isSanctioned => status == ViolationStatus.sanctioned;

  ViolationEntry copyWith({
    ViolationStatus? status,
    String? sanctionType,
    Timestamp? reviewedAt,
    String? ownerName,
    String? plateNumber,
    String? fullname,
  }) {
    return ViolationEntry(
      id: id,
      vehicleId: vehicleId,
      reportedByUserId: reportedByUserId,
      violationType: violationType,
      sanctionApplied: sanctionApplied,
      status: status ?? this.status,
      sanctionType: sanctionType ?? this.sanctionType,
      reportedAt: reportedAt,
      createdAt: createdAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      ownerName: ownerName ?? this.ownerName,
      plateNumber: plateNumber ?? this.plateNumber,
      fullname: fullname ?? this.fullname,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ViolationEntry && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
