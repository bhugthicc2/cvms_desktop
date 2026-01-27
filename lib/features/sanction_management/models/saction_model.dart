import 'package:cvms_desktop/features/sanction_management/models/sanction_enums.dart';

class Sanction {
  final String id;
  final String vehicleId;
  final String violationId;

  final SanctionType type;
  final SanctionStatus status;
  final int offenseNumber;

  final String vehicleStatusEffect;

  final DateTime startAt;
  final DateTime? endAt;
  final DateTime? lastEvaluatedAt;

  final String createdBy;
  final DateTime createdAt;

  Sanction({
    required this.id,
    required this.vehicleId,
    required this.violationId,
    required this.type,
    required this.status,
    required this.offenseNumber,
    required this.vehicleStatusEffect,
    required this.startAt,
    this.endAt,
    this.lastEvaluatedAt,
    required this.createdBy,
    required this.createdAt,
  });
}

// FIRESTORE SHAPE

// "sanctions": {
//   "sanction_001": {
//     "vehicleId": "08YuOljfmVJw6ihTVI9l",
//     "violationId": "3BqNVgENvA87rM7TELvU",
//     "type": "suspension",
//     "offenseNumber": 2,
//     "status": "active",
//     "startAt": { "_seconds": 1769437252 },
//     "endAt": { "_seconds": 1772037252 },
//     "createdBy": "adminUserId",
//     "createdAt": { "_seconds": 1769437252 }
//   }
// }
