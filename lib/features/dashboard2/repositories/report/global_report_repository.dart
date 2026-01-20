import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/report/date_range_filter.dart';

class GlobalReportRepository {
  final FirebaseFirestore _db;

  GlobalReportRepository(this._db);

  Future<int> getTotalVehicles() async {
    final snap = await _db.collection('vehicles').get();
    return snap.size;
  }

  Future<int> getTotalFleetLogs(DateRangeFilter range) async {
    final snap =
        await _db
            .collection('vehicle_logs')
            .where(
              'timeIn',
              isGreaterThanOrEqualTo: Timestamp.fromDate(range.start),
            )
            .where('timeIn', isLessThanOrEqualTo: Timestamp.fromDate(range.end))
            .get();
    return snap.size;
  }

  Future<int> getTotalViolations(DateRangeFilter range) async {
    final snap =
        await _db
            .collection('violations')
            .where(
              'createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(range.start),
            )
            .where(
              'createdAt',
              isLessThanOrEqualTo: Timestamp.fromDate(range.end),
            )
            .get();
    return snap.size;
  }

  Future<int> getPendingViolations(DateRangeFilter range) async {
    final snap =
        await _db
            .collection('violations')
            .where('status', isEqualTo: 'pending')
            .where(
              'createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(range.start),
            )
            .where(
              'createdAt',
              isLessThanOrEqualTo: Timestamp.fromDate(range.end),
            )
            .get();
    return snap.size;
  }

  Future<Map<String, int>> getViolationsByType(DateRangeFilter range) async {
    final snap =
        await _db
            .collection('violations')
            .where(
              'createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(range.start),
            )
            .where(
              'createdAt',
              isLessThanOrEqualTo: Timestamp.fromDate(range.end),
            )
            .get();

    final Map<String, int> result = {};

    for (final doc in snap.docs) {
      final type = doc['violationType'] ?? 'Unknown';
      result[type] = (result[type] ?? 0) + 1;
    }

    return result;
  }

  Future<List<Map<String, dynamic>>> getRecentViolations(
    DateRangeFilter range, {
    int limit = 10,
  }) async {
    final snap =
        await _db
            .collection('violations')
            .where(
              'createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(range.start),
            )
            .where(
              'createdAt',
              isLessThanOrEqualTo: Timestamp.fromDate(range.end),
            )
            .orderBy('createdAt', descending: true)
            .limit(limit)
            .get();

    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<List<Map<String, dynamic>>> getRecentLogs(
    DateRangeFilter range, {
    int limit = 10,
  }) async {
    final snap =
        await _db
            .collection('vehicle_logs')
            .where(
              'timeIn',
              isGreaterThanOrEqualTo: Timestamp.fromDate(range.start),
            )
            .where('timeIn', isLessThanOrEqualTo: Timestamp.fromDate(range.end))
            .orderBy('timeIn', descending: true)
            .limit(limit)
            .get();

    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  Future<Map<String, int>> getFleetLogsTrend(DateRangeFilter range) async {
    final snap =
        await _db
            .collection('vehicle_logs')
            .where(
              'timeIn',
              isGreaterThanOrEqualTo: Timestamp.fromDate(range.start),
            )
            .where('timeIn', isLessThanOrEqualTo: Timestamp.fromDate(range.end))
            .get();

    final Map<String, int> dailyCounts = {};

    for (final doc in snap.docs) {
      final date = (doc['timeIn'] as Timestamp).toDate();
      final key = '${date.year}-${date.month}-${date.day}';

      dailyCounts[key] = (dailyCounts[key] ?? 0) + 1;
    }

    return dailyCounts;
  }
}
