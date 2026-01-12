//REFACTORED DB REFERENCE

import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleLogModel {
  final String id;
  final String vehicleId;
  final String updatedByUserId;

  final Timestamp timeIn;
  final Timestamp? timeOut;
  final String status;
  final int? durationMinutes;

  VehicleLogModel({
    required this.id,
    required this.vehicleId,
    required this.updatedByUserId,
    required this.timeIn,
    this.timeOut,
    required this.status,
    this.durationMinutes,
  });

  Map<String, dynamic> toMap() {
    return {
      "vehicleId": vehicleId,
      "updatedByUserId": updatedByUserId,
      "timeIn": timeIn,
      "timeOut": timeOut,
      "status": status,
      "durationMinutes": durationMinutes,
    };
  }

  factory VehicleLogModel.fromMap(Map<String, dynamic> map, String id) {
    return VehicleLogModel(
      id: id,
      vehicleId: map['vehicleId'],
      updatedByUserId: map['updatedByUserId'],
      timeIn: map['timeIn'] as Timestamp,
      timeOut: map['timeOut'] as Timestamp?,
      status: map['status'],
      durationMinutes:
          map['durationMinutes'] != null
              ? (map['durationMinutes'] as num).toInt()
              : null,
    );
  }

  /// Computed, not stored
  Duration get duration {
    final end = timeOut?.toDate() ?? DateTime.now();
    final start = timeIn.toDate();
    return end.difference(start);
  }

  String get formattedDuration {
    final d = duration;
    return "${d.inHours}h ${d.inMinutes % 60}m";
  }
}
