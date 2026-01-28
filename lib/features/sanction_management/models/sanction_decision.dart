import 'package:cloud_firestore/cloud_firestore.dart';
import 'sanction_enums.dart';
import '../../vehicle_management/models/vehicle_status.dart';

class SanctionDecision {
  final SanctionType type;
  final VehicleStatus vehicleStatus;
  final Timestamp? endsAt;

  const SanctionDecision({
    required this.type,
    required this.vehicleStatus,
    this.endsAt,
  });
}
