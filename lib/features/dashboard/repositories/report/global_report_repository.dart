import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/models/report/date_range.dart';

class GlobalReportRepository {
  final FirebaseFirestore _db;

  GlobalReportRepository(this._db);

  Future<int> getTotalVehicles() async {
    final snap = await _db.collection('vehicles').get();
    return snap.size;
  }

  Future<int> getTotalFleetLogs(DateRange range) async {
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

  Future<int> getTotalViolations(DateRange range) async {
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

  Future<int> getPendingViolations(DateRange range) async {
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

  Future<Map<String, int>> getViolationsByType(DateRange range) async {
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
    DateRange range, {
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
    DateRange range, {
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

  Future<Map<String, int>> getVehicleDistributionPerCollege() async {
    final snap = await _db.collection('vehicles').get();

    final Map<String, int> result = {};

    // Define valid college departments to filter out invalid entries
    final validColleges = [
      'CTED',
      'CBA',
      'CCS',
      'CAF-SOE',
      'SCJE',
      'LHS',
      'CTED',
    ];

    for (final doc in snap.docs) {
      final department = doc['department'] as String? ?? 'Unknown';

      // Only count valid college departments
      if (validColleges.contains(department)) {
        result[department] = (result[department] ?? 0) + 1;
      }
    }

    return result;
  }

  Future<Map<String, int>> getVehiclesByYearLevel() async {
    //step 3 for adding a report entry
    final snap = await _db.collection('vehicles').get();

    final Map<String, int> result = {};

    for (final doc in snap.docs) {
      final yearLevel = doc['yearLevel'] ?? 'Unknown';
      result[yearLevel] = (result[yearLevel] ?? 0) + 1;
    }

    return result;
  }

  Future<Map<String, int>> getVehiclesByCity() async {
    final snap = await _db.collection('vehicles').get();

    final Map<String, int> result = {};

    for (final doc in snap.docs) {
      final city = doc['city'] ?? doc['municipality'] ?? 'Unknown';
      result[city] = (result[city] ?? 0) + 1;
    }

    return result;
  }

  Future<Map<String, int>> getVehicleLogsByCollege(DateRange range) async {
    // Step 1: load vehicles
    final vehiclesSnap = await _db.collection('vehicles').get();

    final Map<String, String> vehicleToCollege = {};

    for (final doc in vehiclesSnap.docs) {
      final department = doc['department'];
      if (department != null) {
        vehicleToCollege[doc.id] = department;
      }
    }

    // Step 2: load logs within range
    final logsSnap =
        await _db
            .collection('vehicle_logs')
            .where(
              'timeIn',
              isGreaterThanOrEqualTo: Timestamp.fromDate(range.start),
            )
            .where('timeIn', isLessThanOrEqualTo: Timestamp.fromDate(range.end))
            .get();

    // Step 3: count logs per college
    final Map<String, int> collegeCounts = {};

    for (final doc in logsSnap.docs) {
      final vehicleId = doc['vehicleId'];
      if (vehicleId == null) continue;

      final college = vehicleToCollege[vehicleId];
      if (college == null) continue;

      collegeCounts[college] = (collegeCounts[college] ?? 0) + 1;
    }

    return collegeCounts;
  }

  Future<Map<String, int>> getViolationDistributionByCollege(
    DateRange range,
  ) async {
    // Step 1: load vehicles
    final vehiclesSnap = await _db.collection('vehicles').get();

    final Map<String, String> vehicleToCollege = {};

    for (final doc in vehiclesSnap.docs) {
      final department = doc['department'];
      if (department != null) {
        vehicleToCollege[doc.id] = department;
      }
    }

    // Step 2: load violations within date range
    final violationsSnap =
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

    // Step 3: count violations per college
    final Map<String, int> collegeCounts = {};

    for (final doc in violationsSnap.docs) {
      final vehicleId = doc['vehicleId'];
      if (vehicleId == null) continue;

      final college = vehicleToCollege[vehicleId];
      if (college == null) continue;

      collegeCounts[college] = (collegeCounts[college] ?? 0) + 1;
    }

    return collegeCounts;
  }

  Future<Map<DateTime, int>> getFleetLogsTrend(DateRange range) async {
    final snap =
        await _db
            .collection('vehicle_logs')
            .where(
              'timeIn',
              isGreaterThanOrEqualTo: Timestamp.fromDate(range.start),
            )
            .where('timeIn', isLessThanOrEqualTo: Timestamp.fromDate(range.end))
            .get();

    final Map<DateTime, int> dailyCounts = {};

    for (final doc in snap.docs) {
      final ts = doc['timeIn'] as Timestamp?;
      if (ts == null) continue;

      final date = ts.toDate();
      final key = DateTime(date.year, date.month, date.day);

      dailyCounts[key] = (dailyCounts[key] ?? 0) + 1;
    }

    return dailyCounts;
  }

  Future<List<ChartDataModel>> getTopStudentsByViolations(
    DateRange range, {
    int limit = 5,
  }) async {
    // Step 1: Load vehicles
    final vehiclesSnap = await _db.collection('vehicles').get();

    final Map<String, String> vehicleToOwner = {};
    for (final doc in vehiclesSnap.docs) {
      final ownerName = doc['ownerName'];
      if (ownerName != null && ownerName.toString().isNotEmpty) {
        vehicleToOwner[doc.id] = ownerName;
      }
    }

    // Step 2: Load violations in range
    final violationsSnap =
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

    // Step 3: Count violations per student
    final Map<String, int> counts = {};

    for (final doc in violationsSnap.docs) {
      final vehicleId = doc['vehicleId'];
      if (vehicleId == null) continue;

      final owner = vehicleToOwner[vehicleId];
      if (owner == null) continue;

      counts[owner] = (counts[owner] ?? 0) + 1;
    }

    // Step 4: Convert → sort → limit
    return counts.entries
        .map((e) => ChartDataModel(category: e.key, value: e.value.toDouble()))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value))
      ..removeRange(
        limit < counts.length ? limit : counts.length,
        counts.length,
      );
  }
}
