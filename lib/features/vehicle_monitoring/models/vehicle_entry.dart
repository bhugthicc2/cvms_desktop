import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleEntry {
  final String docId;
  final String vehicleId;
  final DateTime timeIn;
  final DateTime? timeOut;
  final String? _ownerName;
  final String? _vehicleModel;
  final String? _plateNumber;

  VehicleEntry({
    required this.docId,
    required this.vehicleId,
    required this.timeIn,
    this.timeOut,
    String? ownerName,
    String? vehicleModel,
    String? plateNumber,
  }) : _ownerName = ownerName,
       _vehicleModel = vehicleModel,
       _plateNumber = plateNumber;

  String get status => timeOut == null ? "inside" : "outside";

  factory VehicleEntry.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VehicleEntry(
      docId: doc.id,
      vehicleId: data['vehicleId'] ?? '',
      timeIn: (data['timeIn'] as Timestamp).toDate(),
      timeOut:
          data['timeOut'] != null
              ? (data['timeOut'] as Timestamp).toDate()
              : null,
      ownerName: data['ownerName'],
      vehicleModel: data['vehicleModel'],
      plateNumber: data['plateNumber'],
    );
  }

  // Method to fetch vehicle details from vehicles collection
  static Future<VehicleEntry> withVehicleDetails(VehicleEntry entry) async {
    if (entry._ownerName != null &&
        entry._vehicleModel != null &&
        entry._plateNumber != null) {
      return entry; // Details already available
    }

    try {
      final vehicleDoc =
          await FirebaseFirestore.instance
              .collection('vehicles')
              .doc(entry.vehicleId)
              .get();

      if (vehicleDoc.exists) {
        final vehicleData = vehicleDoc.data();
        return VehicleEntry(
          docId: entry.docId,
          vehicleId: entry.vehicleId,
          timeIn: entry.timeIn,
          timeOut: entry.timeOut,
          ownerName: vehicleData?['ownerName'],
          vehicleModel: vehicleData?['vehicleModel'],
          plateNumber: vehicleData?['plateNumber'],
        );
      }
    } catch (e) {
      // Return entry with default values if fetch fails
    }

    return entry;
  }

  // Getters with fallbacks
  String get ownerName => _ownerName ?? 'Unknown';
  String get vehicleModel => _vehicleModel ?? 'Unknown';
  String get plateNumber => _plateNumber ?? 'Unknown';

  Duration get duration {
    final end = timeOut ?? DateTime.now();
    return end.difference(timeIn);
  }

  String get formattedDuration {
    final d = duration;
    return "${d.inHours}h ${d.inMinutes % 60}m";
  }
}
