import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleEntry {
  final String docId;
  final String vehicleId;
  final String ownerName;
  final String vehicleModel;
  final String plateNumber;
  final DateTime timeIn;
  final DateTime? timeOut;

  VehicleEntry({
    required this.docId,
    required this.vehicleId,
    required this.ownerName,
    required this.vehicleModel,
    required this.plateNumber,
    required this.timeIn,
    this.timeOut,
  });

  String get status => timeOut == null ? "inside" : "outside";

  factory VehicleEntry.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VehicleEntry(
      docId: doc.id, //
      vehicleId: data['vehicleId'] ?? '',
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

  Duration get duration {
    final end = timeOut ?? DateTime.now();
    return end.difference(timeIn);
  }

  String get formattedDuration {
    final d = duration;
    return "${d.inHours}h ${d.inMinutes % 60}m";
  }

  @override
  String toString() {
    return 'VehicleEntry(owner: $ownerName, plate: $plateNumber, docId: $docId)';
  }
}
