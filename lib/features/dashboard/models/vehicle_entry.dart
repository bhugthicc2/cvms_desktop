import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleEntry {
  final String ownerName;
  final String vehicleModel;
  final String plateNumber;
  final DateTime timeIn;
  final DateTime? timeOut;

  VehicleEntry({
    required this.ownerName,
    required this.vehicleModel,
    required this.plateNumber,
    required this.timeIn,
    this.timeOut,
  });

  Duration get duration {
    final end = timeOut ?? DateTime.now(); //current time if timeout is null
    return end.difference(timeIn); //time in - current time
  }

  String get formattedDuration {
    final d = duration;
    return "${d.inHours}h ${d.inMinutes % 60}m"; //converted the duration in minutes into hours and minutes
  }

  String get status => timeOut == null ? "inside" : "outside";

  // Factory for Firestore
  factory VehicleEntry.fromMap(Map<String, dynamic> data) {
    return VehicleEntry(
      ownerName: data['ownerName'] ?? '',
      vehicleModel: data['vehicleModel'] ?? '',
      plateNumber: data['plateNumber'] ?? '',
      timeIn: (data['timeIn'] as Timestamp).toDate(),
      timeOut:
          data['timeOut'] != null
              ? (data['timeOut'] as Timestamp).toDate()
              : null,
    );
  }
}
