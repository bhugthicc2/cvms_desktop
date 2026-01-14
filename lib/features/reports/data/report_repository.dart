import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';
import 'package:cvms_desktop/features/reports/models/vehicle_logs_model.dart';
import 'package:cvms_desktop/features/reports/models/vehicle_search_result.dart';
import 'package:cvms_desktop/core/utils/registration_expiry_utils.dart';
import '../models/fleet_summary.dart';
import '../models/vehicle_profile.dart';
import '../models/violation_history_model.dart';

class ReportRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<VehicleSearchResult>> searchVehicles({
    required String query,
    int limit = 10,
  }) async {
    final q = query.trim();
    if (q.isEmpty) return [];

    Future<List<QueryDocumentSnapshot>> runPrefixQuery(String field) async {
      return await _firestore
          .collection('vehicles')
          .orderBy(field)
          .startAt([q])
          .endAt(['$q\uf8ff'])
          .limit(limit)
          .get()
          .then((snapshot) => snapshot.docs);
    }

    final Map<String, VehicleSearchResult> resultsById = {};

    Future<void> mergeFromField(String field) async {
      try {
        final docs = await runPrefixQuery(field);
        for (final doc in docs) {
          final data = doc.data() as Map<String, dynamic>?;
          if (data == null) continue;
          final plateNumber =
              (data['plateNumber'] ?? data['plateNo'] ?? '') as String;
          final schoolId = (data['schoolID'] ?? '') as String;
          final ownerName = (data['ownerName'] ?? '') as String;
          final model = (data['model'] ?? data['vehicleModel'] ?? '') as String;
          resultsById[doc.id] = VehicleSearchResult(
            vehicleId: doc.id,
            plateNumber: plateNumber,
            ownerName: ownerName,
            model: model,
            schoolID: schoolId,
          );
        }
      } catch (_) {
        // If a prefix query fails (missing index/field), skip it.
      }
    }

    await mergeFromField('plateNumber');
    await mergeFromField('schoolId');
    await mergeFromField('ownerName');
    await mergeFromField('model');

    if (resultsById.isEmpty) {
      try {
        final snapshot =
            await _firestore.collection('vehicles').limit(50).get();
        for (final doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>?;
          if (data == null) continue;
          final plateNumber =
              (data['plateNumber'] ?? data['plateNo'] ?? '') as String;
          final schoolId = (data['schoolID'] ?? '') as String;
          final ownerName = (data['ownerName'] ?? '') as String;
          final model = (data['model'] ?? data['vehicleModel'] ?? '') as String;

          final haystack =
              '$plateNumber $ownerName $model $schoolId'.toLowerCase();
          if (!haystack.contains(q.toLowerCase())) continue;

          resultsById[doc.id] = VehicleSearchResult(
            vehicleId: doc.id,
            plateNumber: plateNumber,
            ownerName: ownerName,
            model: model,
            schoolID: schoolId,
          );
          if (resultsById.length >= limit) break;
        }
      } catch (_) {
        // Ignore and return empty list.
      }
    }

    return resultsById.values.take(limit).toList();
  }

  // MAIN FLEET SUMMARY - Orchestrates all data
  Future<FleetSummary> fetchFleetSummary({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final now = DateTime.now();
    final end = endDate ?? now;
    final start = startDate ?? now.subtract(const Duration(days: 7));

    // Total Fleet Violations & Active Fleet Violations
    final violations = await _getViolationsInRange(start, end);
    final totalViolations = violations.length;
    final activeViolations = totalViolations;

    // Top 5 Violations by Type
    final topViolationTypes = _calculateTopViolationTypes(violations);

    // Total Vehicles in Fleet
    final totalVehicles = await _getTotalVehicles();

    // Total Entries/Exits (Vehicle Logs)
    final logs = await _getLogsInRange(start, end);
    final totalEntriesExits = logs.length * 2;

    // Violation Trend Calculation
    final violationTrendPercent = await _calculateViolationTrend(start);

    // Vehicle Logs per College Chart
    final departmentLogData = await _groupLogsByDepartment(logs);

    // Violation Distribution per College Chart
    final deptViolationData = await _groupViolationsByDepartment(violations);

    return FleetSummary(
      totalViolations: totalViolations,
      activeViolations: activeViolations,
      totalVehicles: totalVehicles,
      totalEntriesExits: totalEntriesExits,
      violationTrendPercent: violationTrendPercent,
      topViolationTypes: topViolationTypes,
      departmentLogData: departmentLogData,
      deptViolationData: deptViolationData,
    );
  }

  // VIOLATIONS DATA - Total Fleet & Active Violations

  Future<List<QueryDocumentSnapshot>> _getViolationsInRange(
    DateTime start,
    DateTime end,
  ) async {
    return await _firestore
        .collection('violations')
        .where('status', isEqualTo: 'pending')
        .where('reportedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('reportedAt', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .get()
        .then((snapshot) => snapshot.docs);
  }

  // TOP 5 VIOLATIONS BY TYPE

  List<ViolationTypeCount> _calculateTopViolationTypes(
    List<QueryDocumentSnapshot> violations,
  ) {
    final Map<String, int> typeCounts = {};

    for (final doc in violations) {
      final data = doc.data() as Map<String, dynamic>?;
      final violationType = data?['violationType'] as String? ?? 'Unknown';
      typeCounts[violationType] = (typeCounts[violationType] ?? 0) + 1;
    }

    final sortedEntries =
        typeCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries
        .take(5)
        .map((entry) => ViolationTypeCount(type: entry.key, count: entry.value))
        .toList();
  }

  // FLEET VEHICLE DATA

  Future<int> _getTotalVehicles() async {
    final snapshot = await _firestore.collection('vehicles').get();
    return snapshot.docs.length;
  }

  // VEHICLE LOGS DATA - Total Entries/Exits

  Future<List<QueryDocumentSnapshot>> _getLogsInRange(
    DateTime start,
    DateTime end,
  ) async {
    return await _firestore
        .collection('vehicle_logs')
        .where('timeIn', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('timeIn', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .get()
        .then((snapshot) => snapshot.docs);
  }

  // VIOLATION TREND CALCULATION

  Future<double> _calculateViolationTrend(DateTime currentStart) async {
    final priorStart = currentStart.subtract(const Duration(days: 7));
    final priorEnd = currentStart;

    final priorViolations = await _getViolationsInRange(priorStart, priorEnd);
    final priorCount = priorViolations.length;

    if (priorCount == 0) return 0.0;

    final currentCount = await _getViolationsInRange(
      currentStart,
      priorEnd.subtract(const Duration(seconds: 1)),
    );

    return ((currentCount.length - priorCount) / priorCount * 100);
  }

  // VEHICLE DISTRIBUTION PER COLLEGE CHART

  /// Fetches vehicle distribution data grouped by department/college
  Future<List<ChartDataModel>> fetchVehicleDistributionByCollege({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // For now, get all vehicles without date filtering to ensure data is available
      final vehiclesSnapshot = await _firestore.collection('vehicles').get();

      // Group vehicles by department
      final Map<String, int> departmentCounts = {};

      for (final doc in vehiclesSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        final department = data?['department'] as String? ?? 'Unknown';
        departmentCounts[department] = (departmentCounts[department] ?? 0) + 1;
      }

      return _createChartDataFromCounts(departmentCounts);
    } catch (e) {
      throw Exception('Failed to fetch vehicle distribution: $e');
    }
  }

  /// Fetches year level breakdown data for students/vehicles
  Future<List<ChartDataModel>> fetchYearLevelBreakdown({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // For now, get all vehicles without date filtering to ensure data is available
      final vehiclesSnapshot = await _firestore.collection('vehicles').get();

      // Group by year level
      final Map<String, int> yearLevelCounts = {};

      for (final doc in vehiclesSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        final yearLevel = data?['yearLevel'] as String? ?? 'Unknown';
        yearLevelCounts[yearLevel] = (yearLevelCounts[yearLevel] ?? 0) + 1;
      }

      return _createChartDataFromCounts(yearLevelCounts);
    } catch (e) {
      throw Exception('Failed to fetch year level breakdown: $e');
    }
  }

  /// Fetches student with most violations data
  Future<List<ChartDataModel>> fetchStudentWithMostViolations({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Get all violations
      final violationsSnapshot =
          await _firestore.collection('violations').get();

      // Group violations by vehicle owner
      final Map<String, int> studentViolationCounts = {};

      for (final violationDoc in violationsSnapshot.docs) {
        final violationData = violationDoc.data() as Map<String, dynamic>?;
        final vehicleId = violationData?['vehicleId'] as String?;

        if (vehicleId == null) continue;

        // Get vehicle details to find owner
        final vehicleDoc =
            await _firestore.collection('vehicles').doc(vehicleId).get();
        if (!vehicleDoc.exists) continue;

        final vehicleData = vehicleDoc.data();
        final ownerName = vehicleData?['ownerName'] as String? ?? 'Unknown';

        // Increment violation count for this owner
        studentViolationCounts[ownerName] =
            (studentViolationCounts[ownerName] ?? 0) + 1;
      }

      return _createChartDataFromCounts(studentViolationCounts);
    } catch (e) {
      throw Exception('Failed to fetch student violation data: $e');
    }
  }

  /// Fetches city/municipality breakdown data
  Future<List<ChartDataModel>> fetchCityBreakdown({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // For now, get all vehicles without date filtering to ensure data is available
      final vehiclesSnapshot = await _firestore.collection('vehicles').get();

      // Group by city
      final Map<String, int> cityCounts = {};

      for (final doc in vehiclesSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        final city = data?['city'] as String? ?? 'Unknown';
        cityCounts[city] = (cityCounts[city] ?? 0) + 1;
      }

      return _createChartDataFromCounts(cityCounts);
    } catch (e) {
      throw Exception('Failed to fetch city breakdown: $e');
    }
  }

  Future<List<ChartDataModel>> _groupLogsByDepartment(
    List<QueryDocumentSnapshot> logs,
  ) async {
    return await _groupItemsByDepartment(logs);
  }

  // VIOLATION DISTRIBUTION PER COLLEGE CHART

  Future<List<ChartDataModel>> _groupViolationsByDepartment(
    List<QueryDocumentSnapshot> violations,
  ) async {
    return await _groupItemsByDepartment(violations);
  }

  // SHARED HELPER - Groups items by department for charts

  Future<List<ChartDataModel>> _groupItemsByDepartment(
    List<QueryDocumentSnapshot> items,
  ) async {
    final Map<String, int> deptCounts = {};

    for (final itemDoc in items) {
      final data = itemDoc.data() as Map<String, dynamic>?;
      final vehicleId = data?['vehicleId'] as String?;

      if (vehicleId == null) continue;

      final vehicleDoc =
          await _firestore.collection('vehicles').doc(vehicleId).get();
      if (vehicleDoc.exists) {
        final vehicleData = vehicleDoc.data();
        final dept = vehicleData?['department'] as String? ?? 'Unknown';
        deptCounts[dept] = (deptCounts[dept] ?? 0) + 1;
      }
    }

    return _createChartDataFromCounts(deptCounts);
  }

  // CHART DATA HELPER - Creates chart data from department counts

  List<ChartDataModel> _createChartDataFromCounts(Map<String, int> counts) {
    final sortedEntries =
        counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    // Return ALL departments
    final chartData =
        sortedEntries
            .map(
              (entry) => ChartDataModel(
                category: entry.key,
                value: entry.value.toDouble(),
              ),
            )
            .toList();

    return chartData;
  }

  Future<VehicleProfile?> fetchVehicleBySearchKey(String vehicleId) async {
    try {
      final vehicleDoc =
          await _firestore.collection('vehicles').doc(vehicleId).get();
      if (!vehicleDoc.exists) return null;

      final data = vehicleDoc.data()!;
      final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
      final expiryDate =
          createdAt != null
              ? RegistrationExpiryUtils.computeExpiryDate(createdAt)
              : null;

      return VehicleProfile(
        vehicleId: vehicleId,
        plateNumber: data['plateNumber'] ?? data['plateNo'] ?? '',
        ownerName: data['ownerName'] ?? '',
        model: data['model'] ?? data['vehicleModel'] ?? '',
        vehicleType: data['vehicleType'] ?? '',
        department: data['department'] ?? '',
        status: data['status'] ?? '',
        registeredDate: (data['registeredDate'] as Timestamp?)?.toDate(),
        createdAt: createdAt,
        expiryDate: expiryDate,
        activeViolations: 0,
        totalViolations: 0,
        totalEntriesExits: 0,
      );
    } catch (_) {
      return null;
    }
  }

  Future<List<ViolationHistoryEntry>> fetchPendingViolationsByVehicleId(
    String vehicleId,
  ) async {
    try {
      final snapshot =
          await _firestore
              .collection('violations')
              .where('vehicleId', isEqualTo: vehicleId)
              .where('status', isEqualTo: 'pending')
              .get();

      final violations = <ViolationHistoryEntry>[];
      for (final doc in snapshot.docs) {
        final data = doc.data();

        final reportedAt = data['reportedAt'] as Timestamp?;
        final createdAt = data['createdAt'] as Timestamp?;
        final lastUpdated = data['lastUpdated'] as Timestamp?;

        violations.add(
          ViolationHistoryEntry(
            violationId: doc.id,
            dateTime: reportedAt?.toDate() ?? DateTime.now(),
            violationType: data['violationType'] as String? ?? 'Unknown',
            reportedBy: data['reportedBy'] as String? ?? 'Unknown',
            status: data['status'] as String? ?? 'pending',
            createdAt: createdAt?.toDate() ?? DateTime.now(),
            lastUpdated: lastUpdated?.toDate() ?? DateTime.now(),
          ),
        );
      }

      return violations;
    } catch (_) {
      return [];
    }
  }

  Future<int> fetchTotalViolationsByVehicleId(String vehicleId) async {
    try {
      final snapshot =
          await _firestore
              .collection('violations')
              .where('vehicleId', isEqualTo: vehicleId)
              .get();

      return snapshot.docs.length;
    } catch (_) {
      return 0;
    }
  }

  // Future<int> fetchVehicleLogsByVehicleId(String vehicleId) async {
  //   try {
  //     final snapshot =
  //         await _firestore
  //             .collection('vehicle_logs')
  //             .where('vehicleId', isEqualTo: vehicleId)
  //             .get();

  //     return snapshot.docs.length;
  //   } catch (_) {
  //     return 0;
  //   }
  // }

  Future<List<ChartDataModel>> fetchViolationsByTypeByVehicleId(
    String vehicleId,
  ) async {
    try {
      final snapshot =
          await _firestore
              .collection('violations')
              .where('vehicleId', isEqualTo: vehicleId)
              .get();

      final Map<String, int> typeCounts = {};

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final violationType = data['violationType'] as String? ?? 'Unknown';
        typeCounts[violationType] = (typeCounts[violationType] ?? 0) + 1;
      }

      return typeCounts.entries
          .map(
            (entry) => ChartDataModel(
              category: entry.key,
              value: entry.value.toDouble(),
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<ChartDataModel>> fetchVehicleLogsByVehicleIdForLast7Days(
    String vehicleId,
  ) async {
    try {
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));

      final snapshot =
          await _firestore
              .collection('vehicle_logs')
              .where('vehicleId', isEqualTo: vehicleId)
              .where(
                'timeIn',
                isGreaterThanOrEqualTo: Timestamp.fromDate(sevenDaysAgo),
              )
              .where('timeIn', isLessThanOrEqualTo: Timestamp.fromDate(now))
              .get();

      final Map<DateTime, int> dailyCounts = {};

      // Initialize all 7 days with 0 count
      for (int i = 6; i >= 0; i--) {
        final day = now.subtract(Duration(days: i));
        final dayKey = DateTime(day.year, day.month, day.day);
        dailyCounts[dayKey] = 0;
      }

      // Count logs per day
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final timeIn = (data['timeIn'] as Timestamp?)?.toDate();
        if (timeIn != null) {
          final dayKey = DateTime(timeIn.year, timeIn.month, timeIn.day);
          if (dailyCounts.containsKey(dayKey)) {
            dailyCounts[dayKey] = (dailyCounts[dayKey] ?? 0) + 1;
          }
        }
      }

      return dailyCounts.entries
          .map(
            (entry) => ChartDataModel(
              category: _formatDayLabel(entry.key),
              value: entry.value.toDouble(),
              date: entry.key,
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  String _formatDayLabel(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final checkDay = DateTime(day.year, day.month, day.day);

    if (checkDay == today) return 'Today';
    if (checkDay == yesterday) return 'Yesterday';

    // For other days, show abbreviated day name
    return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][day.weekday - 1];
  }

  Future<List<ViolationHistoryEntry>> fetchViolationHistoryByVehicleId(
    String vehicleId,
  ) async {
    try {
      final snapshot =
          await _firestore
              .collection('violations')
              .where('vehicleId', isEqualTo: vehicleId)
              .orderBy('reportedAt', descending: true)
              .limit(10)
              .get();

      // Extract unique user IDs from violations
      final Set<String> userIds = {};
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final reportedByUserId = data['reportedByUserId'] as String?;
        if (reportedByUserId != null && reportedByUserId.isNotEmpty) {
          userIds.add(reportedByUserId);
        }
      }

      // Batch fetch user names
      final Map<String, String> userNames = {};
      if (userIds.isNotEmpty) {
        final usersSnapshot =
            await _firestore
                .collection('users')
                .where(FieldPath.documentId, whereIn: userIds.take(10).toList())
                .get();

        for (final userDoc in usersSnapshot.docs) {
          final userData = userDoc.data();
          final fullname = userData['fullname'] as String?;
          if (fullname != null && fullname.isNotEmpty) {
            userNames[userDoc.id] = fullname;
          }
        }
      }

      return snapshot.docs.map((doc) {
        final data = doc.data();
        final reportedAt = (data['reportedAt'] as Timestamp?)?.toDate();
        final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
        final reportedByUserId = data['reportedByUserId'] as String?;

        // Resolve user name or fallback
        final reportedByName =
            reportedByUserId != null
                ? (userNames[reportedByUserId] ?? 'Unknown User')
                : 'Unknown User';

        return ViolationHistoryEntry(
          violationId: doc.id,
          dateTime: reportedAt ?? createdAt ?? DateTime.now(),
          violationType: data['violationType'] as String? ?? 'Unknown',
          status: data['status'] as String? ?? 'Unknown',
          reportedBy: reportedByName,
          createdAt: createdAt ?? DateTime.now(),
          lastUpdated: reportedAt ?? createdAt ?? DateTime.now(),
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<VehicleLogsEntry>> fetchVehicleLogsByVehicleId(
    String vehicleId,
  ) async {
    try {
      final snapshot =
          await _firestore
              .collection('vehicle_logs')
              .where('vehicleId', isEqualTo: vehicleId)
              .orderBy('timeIn', descending: true)
              .limit(10)
              .get();

      // Extract unique user IDs from logs
      final Set<String> userIds = {};
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final updatedByUserId = data['updatedByUserId'] as String?;
        if (updatedByUserId != null && updatedByUserId.isNotEmpty) {
          userIds.add(updatedByUserId);
        }
      }

      // Batch fetch user names
      final Map<String, String> userNames = {};
      if (userIds.isNotEmpty) {
        final usersSnapshot =
            await _firestore
                .collection('users')
                .where(FieldPath.documentId, whereIn: userIds.take(10).toList())
                .get();

        for (final userDoc in usersSnapshot.docs) {
          final userData = userDoc.data();
          final fullname = userData['fullname'] as String?;
          if (fullname != null && fullname.isNotEmpty) {
            userNames[userDoc.id] = fullname;
          }
        }
      }

      return snapshot.docs.map((doc) {
        final data = doc.data();
        final timeIn = (data['timeIn'] as Timestamp?)?.toDate();
        final timeOut = (data['timeOut'] as Timestamp?)?.toDate();
        final durationMinutes = data['durationMinutes'] as int? ?? 0;
        final updatedByUserId = data['updatedByUserId'] as String?;

        // Resolve user name or fallback
        final updatedByName =
            updatedByUserId != null
                ? (userNames[updatedByUserId] ?? 'Unknown User')
                : 'Unknown User';

        return VehicleLogsEntry(
          logId: doc.id,
          timeIn: timeIn ?? DateTime.now(),
          timeOut: timeOut ?? DateTime.now(),
          durationMinutes: durationMinutes,
          status: data['status'] as String? ?? 'Unknown',
          updatedBy: updatedByName,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }
}
