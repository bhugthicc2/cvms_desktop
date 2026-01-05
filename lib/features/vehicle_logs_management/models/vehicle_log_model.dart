import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleLogModel {
  final String logID;
  final String vehicleID;
  final String ownerName;
  final String plateNumber;
  final String vehicleModel;
  final Timestamp timeIn;
  final Timestamp? timeOut;
  final String updatedBy;
  final String status;
  final int? durationMinutes;

  VehicleLogModel({
    required this.logID,
    required this.vehicleID,
    required this.ownerName,
    required this.plateNumber,
    required this.vehicleModel,
    required this.timeIn,
    this.timeOut,
    required this.updatedBy,
    required this.status,
    this.durationMinutes,
  });

  Map<String, dynamic> toMap() {
    return {
      "logID": logID,
      "vehicleId": vehicleID,
      "ownerName": ownerName,
      "plateNumber": plateNumber,
      "vehicleModel": vehicleModel,
      "timeIn": timeIn,
      "timeOut": timeOut,
      "updatedBy": updatedBy,
      "status": status,
      "durationMinutes": durationMinutes,
    };
  }

  Duration get duration {
    final end =
        timeOut?.toDate() ??
        DateTime.now(); // Convert Timestamp to DateTime if not null, otherwise use current time
    final start = timeIn.toDate(); // Convert Timestamp to DateTime
    return end.difference(start); // Calculate difference between end and start
  }

  String get formattedDuration {
    final d = duration;
    return "${d.inHours}h ${d.inMinutes % 60}m"; //converted the duration in minutes into hours and minutes
  }

  factory VehicleLogModel.fromMap(Map<String, dynamic> map, String id) {
    return VehicleLogModel(
      logID: id,
      vehicleID: map['vehicleId'] ?? '',
      status: map['status'] ?? '',
      ownerName: map['ownerName'] ?? '',
      vehicleModel: map['vehicleModel'] ?? '',
      plateNumber: map['plateNumber'] ?? '',
      updatedBy: map['updatedBy'] ?? '',
      timeIn: map['timeIn'] as Timestamp,
      timeOut: map['timeOut'] as Timestamp?,
      durationMinutes:
          map['durationMinutes'] != null
              ? (map['durationMinutes'] as num).toInt()
              : null,
    );
  }

  static VehicleLogModel sample() {
    final now = Timestamp.now();
    return VehicleLogModel(
      logID: 'sample-log-id',
      vehicleID: 'sample-vehicle-id',
      ownerName: 'Sample Owner',
      plateNumber: 'ABC-123',
      vehicleModel: 'Sample Model',
      timeIn: now,
      timeOut: null,
      updatedBy: 'Sample User',
      status: 'onsite',
      durationMinutes: null,
    );
  }
}
