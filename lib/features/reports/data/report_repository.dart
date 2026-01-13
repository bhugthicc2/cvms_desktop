import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';
import '../models/fleet_summary.dart';

class ReportRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

    // Return ALL departments, not just top 5
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
}
