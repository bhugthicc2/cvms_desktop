import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard2/models/dashboard/recent_log_entry.dart';
import 'package:cvms_desktop/features/dashboard2/models/dashboard/time_grouping.dart';
import 'package:cvms_desktop/features/dashboard2/models/dashboard/violation_history_entry.dart';
import 'package:cvms_desktop/features/dashboard2/utils/time_bucket_helper.dart';

class IndividualDashboardRepository {
  final FirebaseFirestore _db;

  IndividualDashboardRepository(this._db);

  // TOTAL VIOLATIONS (REALTIME)
  Stream<int> watchTotalViolations(String vehicleId) {
    return _db
        .collection('violations')
        .where('vehicleId', isEqualTo: vehicleId)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  // PENDING VIOLATIONS (REALTIME)
  Stream<int> watchPendingViolations(String vehicleId) {
    return _db
        .collection('violations')
        .where('vehicleId', isEqualTo: vehicleId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  // TOTAL VEHICLE LOGS
  Stream<int> watchTotalVehicleLogs(String vehicleId) {
    return _db
        .collection('vehicle_logs')
        .where('vehicleId', isEqualTo: vehicleId)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  // VIOLATION DISTRIBUTION BY TYPE
  Stream<List<ChartDataModel>> watchViolationByType(String vehicleId) {
    return _db
        .collection('violations')
        .where('vehicleId', isEqualTo: vehicleId)
        .snapshots()
        .map((snapshot) {
          final Map<String, int> counts = {};

          for (final doc in snapshot.docs) {
            final type = doc['violationType'];
            if (type == null) continue;
            counts[type] = (counts[type] ?? 0) + 1;
          }

          return counts.entries
              .map(
                (e) =>
                    ChartDataModel(category: e.key, value: e.value.toDouble()),
              )
              .toList();
        });
  }

  //VEHICLE LOGS
  Stream<List<ChartDataModel>> watchVehicleLogsTrend({
    required String vehicleId, // step 1: scope to ONE vehicle
    required DateTime start, // step 2: date filter start
    required DateTime end, // step 3: date filter end
    required TimeGrouping grouping, // step 4: day/week/month/year
  }) {
    return _db
        .collection('vehicle_logs')
        .where('vehicleId', isEqualTo: vehicleId) //  ONLY difference vs global
        .where('timeIn', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('timeIn', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .snapshots()
        .map((snapshot) {
          final Map<String, int> buckets = {};

          // step 5: initialize empty buckets
          final bucketKeys = TimeBuckerHelper().generateTimeBuckets(
            start,
            end,
            grouping,
          );
          for (final key in bucketKeys) {
            buckets[key] = 0;
          }

          // step 6: aggregate logs
          for (final doc in snapshot.docs) {
            final data = doc.data();
            final Timestamp ts = data['timeIn'];
            final date = ts.toDate();

            final bucketKey = TimeBuckerHelper().formatBucket(date, grouping);

            if (!buckets.containsKey(bucketKey)) continue;

            buckets[bucketKey] = buckets[bucketKey]! + 1;
          }

          // step 7: map to chart data
          return buckets.entries.map((e) {
            final date = TimeBuckerHelper().parseBucket(e.key, grouping);

            return ChartDataModel(
              category: e.key,
              value: e.value.toDouble(),
              date: date,
            );
          }).toList();
        });
  }

  //VIOLATION HISTORY
  Stream<List<ViolationHistoryEntry>> watchViolationHistory({
    required String vehicleId,
    int limit = 10,
  }) {
    return _db
        .collection('violations')
        .where('vehicleId', isEqualTo: vehicleId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .asyncMap((snapshot) async {
          // step 1: collect userIds
          final userIds =
              snapshot.docs
                  .map((doc) => doc['reportedByUserId'] as String?)
                  .whereType<String>()
                  .toSet();

          // step 2: fetch users in batch
          final usersMap = <String, String>{};

          if (userIds.isNotEmpty) {
            final usersSnap = await _db.collection('users').get();

            for (final doc in usersSnap.docs) {
              if (userIds.contains(doc.id)) {
                usersMap[doc.id] = doc.data()['fullname'] ?? 'Unknown';
              }
            }
          }

          // step 3: build table rows
          return snapshot.docs.map((doc) {
            final data = doc.data();

            return ViolationHistoryEntry(
              violationId: doc.id,
              dateTime: (data['reportedAt'] as Timestamp).toDate(),
              violationType: data['violationType'] ?? '',
              reportedBy: usersMap[data['reportedByUserId']] ?? 'Unknown',
              status: data['status'] ?? '',
              createdAt: (data['createdAt'] as Timestamp).toDate(),
              lastUpdated: (data['createdAt'] as Timestamp).toDate(),
            );
          }).toList();
        });
  }

  //RECENT LOGS
  Stream<List<RecentLogEntry>> watchRecentVehicleLogs({
    required String vehicleId,
    int limit = 10,
  }) {
    return _db
        .collection('vehicle_logs')
        .where('vehicleId', isEqualTo: vehicleId)
        .orderBy('timeIn', descending: true)
        .limit(limit)
        .snapshots()
        .asyncMap((snapshot) async {
          // step 1: collect userIds
          final userIds =
              snapshot.docs
                  .map((doc) => doc['updatedByUserId'] as String?)
                  .whereType<String>()
                  .toSet();

          // step 2: batch fetch users
          final usersMap = <String, String>{};

          if (userIds.isNotEmpty) {
            final usersSnap = await _db.collection('users').get();

            for (final doc in usersSnap.docs) {
              if (userIds.contains(doc.id)) {
                usersMap[doc.id] = doc.data()['fullname'] ?? 'Unknown';
              }
            }
          }

          // step 3: map to table rows
          return snapshot.docs.map((doc) {
            final data = doc.data();

            final timeIn = (data['timeIn'] as Timestamp).toDate();
            final timeOut =
                data['timeOut'] != null
                    ? (data['timeOut'] as Timestamp).toDate()
                    : null;

            return RecentLogEntry(
              logId: doc.id,
              timeIn: timeIn,
              timeOut: timeOut,
              durationMinutes: data['durationMinutes'] ?? 0,
              status: data['status'] ?? '',
              updatedBy: usersMap[data['updatedByUserId']] ?? 'Unknown',
            );
          }).toList();
        });
  }
}
