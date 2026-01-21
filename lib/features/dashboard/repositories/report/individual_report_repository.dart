import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/models/report/date_range.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/individual_vehicle_info.dart';
import 'package:cvms_desktop/features/dashboard/models/report/vehicle_metrics.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/violation_history_entry.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/recent_log_entry.dart';

class IndividualReportRepository {
  final FirebaseFirestore _db;

  IndividualReportRepository(this._db);

  // STATIC VEHICLE INFO (NO DATE RANGE)
  Future<IndividualVehicleInfo> getVehicleInfo(String vehicleId) async {
    final doc = await _db.collection('vehicles').doc(vehicleId).get();
    if (!doc.exists) throw Exception('Vehicle not found');
    return IndividualVehicleInfo.fromFirestore(vehicleId, doc.data()!);
  }

  // METRICS (DATE RANGE BOUND)
  Future<VehicleMetrics> getVehicleMetrics(
    String vehicleId,
    DateRange range,
  ) async {
    final violationsSnap =
        await _db
            .collection('violations')
            .where('vehicleId', isEqualTo: vehicleId)
            .where(
              'createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(range.start),
            )
            .where(
              'createdAt',
              isLessThanOrEqualTo: Timestamp.fromDate(range.end),
            )
            .get();

    final pendingCount =
        violationsSnap.docs.where((d) => d['status'] == 'pending').length;

    final logsSnap =
        await _db
            .collection('vehicle_logs')
            .where('vehicleId', isEqualTo: vehicleId)
            .where(
              'timeIn',
              isGreaterThanOrEqualTo: Timestamp.fromDate(range.start),
            )
            .where('timeIn', isLessThanOrEqualTo: Timestamp.fromDate(range.end))
            .get();

    // Calculate logs trend - group by day for the date range
    final Map<String, int> dailyLogs = {};
    for (final doc in logsSnap.docs) {
      final timeIn = (doc['timeIn'] as Timestamp).toDate();
      final dayKey =
          '${timeIn.year}-${timeIn.month.toString().padLeft(2, '0')}-${timeIn.day.toString().padLeft(2, '0')}';
      dailyLogs[dayKey] = (dailyLogs[dayKey] ?? 0) + 1;
    }

    final List<ChartDataModel> logsTrend =
        dailyLogs.entries
            .map(
              (entry) => ChartDataModel(
                category: entry.key,
                value: entry.value.toDouble(),
                date: DateTime.parse(entry.key),
              ),
            )
            .toList();

    return VehicleMetrics(
      totalViolations: violationsSnap.size,
      pendingViolations: pendingCount,
      totalLogs: logsSnap.size,
      logsTrend: logsTrend,
    );
  }

  /// RECENT VIOLATIONS (LIMITED, ORDERED, WITH USER FULLNAME)
  Future<List<ViolationHistoryEntry>> getRecentViolations(
    String vehicleId, {
    int limit = 10,
  }) async {
    // step 1: fetch violations
    final violationsSnap =
        await _db
            .collection('violations')
            .where('vehicleId', isEqualTo: vehicleId)
            .orderBy('createdAt', descending: true)
            .limit(limit)
            .get();

    if (violationsSnap.docs.isEmpty) {
      return [];
    }

    // step 2: collect unique userIds
    final Set<String> userIds =
        violationsSnap.docs
            .map((doc) => doc.data()['reportedByUserId'] as String?)
            .whereType<String>()
            .toSet();

    // step 3: fetch users (batch)
    final Map<String, String> usersMap = {};

    if (userIds.isNotEmpty) {
      final usersSnap = await _db.collection('users').get();

      for (final doc in usersSnap.docs) {
        if (userIds.contains(doc.id)) {
          usersMap[doc.id] = doc.data()['fullname'] ?? 'Unknown';
        }
      }
    }

    // step 4: map to ViolationHistoryEntry
    return violationsSnap.docs.map((doc) {
      final data = doc.data();

      return ViolationHistoryEntry(
        violationId: doc.id,
        dateTime:
            data['reportedAt'] != null
                ? (data['reportedAt'] as Timestamp).toDate()
                : DateTime.now(),
        violationType: data['violationType'] as String? ?? '',
        reportedBy: usersMap[data['reportedByUserId']] ?? 'Unknown',
        status: data['status'] as String? ?? '',
        createdAt:
            data['createdAt'] != null
                ? (data['createdAt'] as Timestamp).toDate()
                : DateTime.now(),
        lastUpdated:
            data['lastUpdated'] != null
                ? (data['lastUpdated'] as Timestamp).toDate()
                : DateTime.now(),
      );
    }).toList();
  }

  // RECENT VEHICLE LOGS (LIMITED)
  Future<List<RecentLogEntry>> getRecentLogs(
    String vehicleId, {
    int limit = 10,
  }) async {
    final snap =
        await _db
            .collection('vehicle_logs')
            .where('vehicleId', isEqualTo: vehicleId)
            .orderBy('timeIn', descending: true)
            .limit(limit)
            .get();

    return snap.docs
        .map((doc) => RecentLogEntry.fromFirestore(doc.id, doc.data()))
        .toList();
  }

  Future<List<ChartDataModel>> getViolationByType(
    String vehicleId,
    DateRange range,
  ) async {
    final snap =
        await _db
            .collection('violations')
            .where('vehicleId', isEqualTo: vehicleId)
            .where(
              'createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(range.start),
            )
            .where(
              'createdAt',
              isLessThanOrEqualTo: Timestamp.fromDate(range.end),
            )
            .get();

    final Map<String, int> counts = {};

    for (final doc in snap.docs) {
      final type = doc.data()['violationType'] as String?;
      if (type == null) continue;
      counts[type] = (counts[type] ?? 0) + 1;
    }

    return counts.entries
        .map((e) => ChartDataModel(category: e.key, value: e.value.toDouble()))
        .toList();
  }
}
