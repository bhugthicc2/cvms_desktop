import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard2/models/dashboard/time_grouping.dart';
import 'package:cvms_desktop/features/dashboard2/utils/time_bucket_helper.dart';
import 'package:cvms_desktop/features/dashboard2/utils/year_level_formatter.dart';
import 'package:rxdart/rxdart.dart';

class GlobalDashboardRepository {
  final FirebaseFirestore _db;

  GlobalDashboardRepository(this._db);
  //realtime implementation step 1
  /// Real-time total entries/exits
  Stream<int> watchTotalEntriesExits() {
    return _db.collection('vehicle_logs').snapshots().map((snapshot) {
      return snapshot.docs.length;
    });
  }

  Stream<int> watchTotalVehicles() {
    return _db.collection('vehicles').snapshots().map((snapshot) {
      return snapshot.docs.length;
    });
  }

  Stream<int> watchTotalViolations() {
    return _db.collection('violations').snapshots().map((snapshot) {
      return snapshot.docs.length;
    });
  }

  //realtime data retrieval based on collection field step 1
  Stream<int> watchTotalPendingViolations() {
    return _db
        .collection('violations')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  //real time grouped aggregation impl step 1
  Stream<List<ChartDataModel>> watchVehicleDistributionByDepartment() {
    return _db.collection('vehicles').snapshots().map((snapshot) {
      final Map<String, int> counts = {};

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final department = data['department'];

        if (department == null) continue;

        counts[department] = (counts[department] ?? 0) + 1;
      }

      return counts.entries
          .map(
            (entry) => ChartDataModel(
              category: entry.key,
              // uncomment if you want to format the department name
              // category: DepartmentFormatter().formatDepartment(entry.key),
              value: entry.value.toDouble(),
            ),
          )
          .toList();
    });
  }

  // Listen to vehicles collection and group by yearLevel
  Stream<List<ChartDataModel>> watchYearLevelBreakdown() {
    return _db.collection('vehicles').snapshots().map((snapshot) {
      final Map<String, int> counts = {}; // step 2: accumulator

      for (final doc in snapshot.docs) {
        final data = doc.data(); // step 3: read document data
        final yearLevel = data['yearLevel']; // step 4: extract yearLevel

        if (yearLevel == null) continue; // step 5: ignore invalid data

        counts[yearLevel] = (counts[yearLevel] ?? 0) + 1; // step 6: count
      }

      return counts.entries
          .map(
            (e) => ChartDataModel(
              category: YearLevelFormatter().formatYearLevel(
                e.key,
              ), // step 7: label formatting
              value: e.value.toDouble(), // step 8: chart requires double
            ),
          )
          .toList();
    });
  }

  // realtime implementation step 1:
  // Watch top students with most violations (configurable limit)
  Stream<List<ChartDataModel>> watchTopStudentsWithMostViolations({
    int limit = 5,
  }) {
    final vehiclesStream = _db.collection('vehicles').snapshots();
    final violationsStream = _db.collection('violations').snapshots();

    return Rx.combineLatest2(vehiclesStream, violationsStream, (
      vehiclesSnap,
      violationsSnap,
    ) {
      // step 2: map vehicleId -> student info
      final Map<String, Map<String, dynamic>> vehicleToStudent = {};

      for (final doc in vehiclesSnap.docs) {
        final data = doc.data();
        vehicleToStudent[doc.id] = {
          'schoolID': data['schoolID'],
          'ownerName': data['ownerName'],
        };
      }

      // step 3: count violations per student
      final Map<String, int> studentViolationCounts = {};
      final Map<String, String> studentNames = {};

      for (final doc in violationsSnap.docs) {
        final data = doc.data();
        final vehicleId = data['vehicleId'];

        if (vehicleId == null) continue;
        final student = vehicleToStudent[vehicleId];
        if (student == null) continue;

        final schoolID = student['schoolID'];
        final name = student['ownerName'];

        if (schoolID == null) continue;

        studentViolationCounts[schoolID] =
            (studentViolationCounts[schoolID] ?? 0) + 1;

        studentNames[schoolID] = name;
      }

      // step 4: convert to chart data
      final results =
          studentViolationCounts.entries
              .map(
                (e) => ChartDataModel(
                  category: studentNames[e.key] ?? e.key,
                  value: e.value.toDouble(),
                ),
              )
              .toList();

      // step 5: sort descending
      results.sort((a, b) => b.value.compareTo(a.value));

      // step 6: return top N
      return results.take(limit).toList();
    });
  }

  // realtime implementation step 1:
  // Returns top N cities with vehicle counts, scalable for future
  Stream<List<ChartDataModel>> watchCityBreakdown({int limit = 5}) {
    return _db.collection('vehicles').snapshots().map((snapshot) {
      final Map<String, int> counts = {}; // step 2: accumulator

      for (final doc in snapshot.docs) {
        final data = doc.data(); // step 3: read document data
        final city = data['city']; // step 4: extract city

        if (city == null || city.toString().isEmpty) continue; // step 5

        counts[city] = (counts[city] ?? 0) + 1; // step 6: increment count
      }

      // step 7: Sort cities by count in descending order
      final sortedCities =
          counts.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value)); // sort descending

      // step 8: Take the top N cities, based on the limit
      final topCities = sortedCities.take(limit).toList();

      // step 9: Convert the result into ChartDataModel for charting
      return topCities
          .map(
            (e) => ChartDataModel(
              category: e.key, // city name
              value: e.value.toDouble(), // convert count to double
            ),
          )
          .toList();
    });
  }

  // realtime implementation step 1:
  // Groups vehicle logs by vehicle department (college)
  Stream<List<ChartDataModel>> watchVehicleLogsDistributionPerCollege({
    int limit = 5,
  }) {
    final vehiclesStream = _db.collection('vehicles').snapshots();
    final logsStream = _db.collection('vehicle_logs').snapshots();

    return Rx.combineLatest2(vehiclesStream, logsStream, (
      vehiclesSnap,
      logsSnap,
    ) {
      // step 2: map vehicleId -> department
      final Map<String, String> vehicleToDepartment = {};

      for (final doc in vehiclesSnap.docs) {
        final data = doc.data();
        final department = data['department'];

        if (department == null) continue;

        vehicleToDepartment[doc.id] = department;
      }

      // step 3: count logs per department
      final Map<String, int> departmentCounts = {};

      for (final doc in logsSnap.docs) {
        final data = doc.data();
        final vehicleId = data['vehicleId'];

        if (vehicleId == null) continue;

        final department = vehicleToDepartment[vehicleId];
        if (department == null) continue;

        departmentCounts[department] = (departmentCounts[department] ?? 0) + 1;
      }

      // step 4: sort by count (descending)
      final sorted =
          departmentCounts.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

      // step 5: take top N
      final topDepartments = sorted.take(limit).toList();

      // step 6: convert to ChartDataModel
      return topDepartments
          .map(
            (e) => ChartDataModel(
              category: e.key, // department name
              value: e.value.toDouble(),
            ),
          )
          .toList();
    });
  }

  // realtime implementation step 1:
  // Groups violations by vehicle department (college)
  Stream<List<ChartDataModel>> watchViolationDistributionPerCollege({
    int limit = 5,
  }) {
    final vehiclesStream = _db.collection('vehicles').snapshots();
    final violationsStream = _db.collection('violations').snapshots();

    return Rx.combineLatest2(vehiclesStream, violationsStream, (
      vehiclesSnap,
      violationsSnap,
    ) {
      // step 2: map vehicleId -> department
      final Map<String, String> vehicleToDepartment = {};

      for (final doc in vehiclesSnap.docs) {
        final data = doc.data();
        final department = data['department'];

        if (department == null) continue;

        vehicleToDepartment[doc.id] = department;
      }

      // step 3: count violations per department
      final Map<String, int> departmentCounts = {};

      for (final doc in violationsSnap.docs) {
        final data = doc.data();
        final vehicleId = data['vehicleId'];

        if (vehicleId == null) continue;

        final department = vehicleToDepartment[vehicleId];
        if (department == null) continue;

        departmentCounts[department] = (departmentCounts[department] ?? 0) + 1;
      }

      // step 4: sort by count descending
      final sorted =
          departmentCounts.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

      // step 5: take top N (scalable)
      final topDepartments = sorted.take(limit).toList();

      // step 6: convert to ChartDataModel
      return topDepartments
          .map(
            (e) => ChartDataModel(
              category: e.key, // department name
              value: e.value.toDouble(),
            ),
          )
          .toList();
    });
  }

  // realtime implementation step 1:
  // Groups violations by violationType and returns top N
  Stream<List<ChartDataModel>> watchViolationTypeDistribution({int limit = 5}) {
    return _db.collection('violations').snapshots().map((snapshot) {
      final Map<String, int> counts = {}; // step 2: accumulator

      for (final doc in snapshot.docs) {
        final data = doc.data(); // step 3: read document data
        final type = data['violationType']; // step 4: extract violation type

        if (type == null || type.toString().isEmpty) continue; // step 5

        counts[type] = (counts[type] ?? 0) + 1; // step 6: increment count
      }

      // step 7: sort by count descending
      final sorted =
          counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

      // step 8: take top N (scalable)
      final topTypes = sorted.take(limit).toList();

      // step 9: convert to chart data
      return topTypes
          .map(
            (e) => ChartDataModel(
              category: e.key, // violation type
              value: e.value.toDouble(), // chart expects double
            ),
          )
          .toList();
    });
  }

  Stream<List<ChartDataModel>> watchFleetLogsTrend({
    required DateTime start,
    required DateTime end,
    required TimeGrouping grouping,
  }) {
    return _db
        .collection('vehicle_logs')
        .where('timeIn', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('timeIn', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .snapshots()
        .map((snapshot) {
          final Map<String, int> buckets = {};

          // step 1: initialize empty buckets
          final bucketKeys = TimeBuckerHelper().generateTimeBuckets(
            start,
            end,
            grouping,
          );
          for (final key in bucketKeys) {
            buckets[key] = 0;
          }

          // step 2: aggregate logs
          for (final doc in snapshot.docs) {
            final data = doc.data();
            final Timestamp ts = data['timeIn'];
            final date = ts.toDate();

            final bucketKey = TimeBuckerHelper().formatBucket(date, grouping);
            if (!buckets.containsKey(bucketKey)) continue;

            buckets[bucketKey] = buckets[bucketKey]! + 1;
          }

          // step 3: map to chart data
          return buckets.entries.map((e) {
            // Parse the bucket key back to DateTime for proper chart rendering
            final date = TimeBuckerHelper().parseBucket(e.key, grouping);

            return ChartDataModel(
              category: e.key,
              value: e.value.toDouble(),
              date: date,
            );
          }).toList();
        });
  }
}
