import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chart_data_model.dart';
import 'analytics_repository.dart';

class FirestoreAnalyticsRepository implements AnalyticsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<ChartDataModel>> fetchVehicleDistribution() async {
    final snapshot = await _firestore.collection('vehicles').get();

    // Group vehicles by department/college field
    final Map<String, int> counts = {};
    for (final doc in snapshot.docs) {
      final dept = doc['department'] ?? 'Unknown';
      counts[dept] = (counts[dept] ?? 0) + 1;
    }

    return counts.entries
        .map((e) => ChartDataModel(category: e.key, value: e.value.toDouble()))
        .toList();
  }

  @override
  Future<List<ChartDataModel>> fetchTopViolations() async {
    final snapshot = await _firestore.collection('violations').get();

    final Map<String, int> counts = {};
    for (final doc in snapshot.docs) {
      final type = doc['violation'] ?? 'Unknown';
      counts[type] = (counts[type] ?? 0) + 1;
    }

    // Sort and take top 5
    final sorted =
        counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return sorted
        .take(5)
        .map((e) => ChartDataModel(category: e.key, value: e.value.toDouble()))
        .toList();
  }

  //--------------------------------vehicle logs for the last 7 days of the year----------------------------------------------

  @override
  Future<List<ChartDataModel>> fetchWeeklyTrend() async {
    // Determine the last 7 days normalized to midnight (local time)
    final now = DateTime.now();
    final last7Days = List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      return DateTime(d.year, d.month, d.day); // normalize to midnight
    });

    final startDate = last7Days.first; // earliest day in the window

    // Query Firestore for logs from the start of the window to reduce reads
    final snapshot =
        await _firestore
            .collection('vehicle_logs')
            .where(
              'timeIn',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
            )
            .get();

    // Track number of logs per day
    final Map<DateTime, int> dayCounts = {};
    for (final doc in snapshot.docs) {
      final ts = doc['timeIn'] as Timestamp;
      final dt = ts.toDate();
      final dayKey = DateTime(dt.year, dt.month, dt.day);
      // Only consider days within our last7Days window
      if (!dayKey.isBefore(startDate) && !dayKey.isAfter(last7Days.last)) {
        dayCounts[dayKey] = (dayCounts[dayKey] ?? 0) + 1;
      }
    }

    // Build chart data: value is total number of logs recorded that day
    final data =
        last7Days.map((date) {
          final count = (dayCounts[date] ?? 0).toDouble();
          return ChartDataModel(
            category: 'Day ${date.dayOfYear}',
            value: count,
            date: date,
          );
        }).toList();

    // Already in chronological order due to how last7Days is constructed
    return data;
  }

  // --------------------------------vehicle logs for the last 7 days of the year----------------------------------------------
  // --------------------------------vehicle logs for the last month----------------------------------------------
  @override
  Future<List<ChartDataModel>> fetchMonthlyTrend() async {
    final now = DateTime.now();
    final last30Days = List.generate(30, (i) {
      final d = now.subtract(Duration(days: 29 - i));
      return DateTime(d.year, d.month, d.day);
    });

    final startDate = last30Days.first;

    final snapshot =
        await _firestore
            .collection('vehicle_logs')
            .where(
              'timeIn',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
            )
            .get();

    final Map<DateTime, int> dayCounts = {};
    for (final doc in snapshot.docs) {
      final ts = doc['timeIn'] as Timestamp;
      final dt = ts.toDate();
      final dayKey = DateTime(dt.year, dt.month, dt.day);
      if (!dayKey.isBefore(startDate) && !dayKey.isAfter(last30Days.last)) {
        dayCounts[dayKey] = (dayCounts[dayKey] ?? 0) + 1;
      }
    }

    final data =
        last30Days.map((date) {
          final count = (dayCounts[date] ?? 0).toDouble();
          return ChartDataModel(
            category: '${date.month}/${date.day}',
            value: count,
            date: date,
          );
        }).toList();

    return data;
  }

  // --------------------------------vehicle logs for the last year----------------------------------------------
  @override
  Future<List<ChartDataModel>> fetchYearlyTrend() async {
    final now = DateTime.now();
    final last12Months =
        List.generate(12, (i) {
          final month = DateTime(now.year, now.month - i, 1);
          return DateTime(month.year, month.month, 1);
        }).reversed.toList();

    final startDate = last12Months.first;

    final snapshot =
        await _firestore
            .collection('vehicle_logs')
            .where(
              'timeIn',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
            )
            .get();

    final Map<DateTime, int> monthCounts = {};
    for (final doc in snapshot.docs) {
      final ts = doc['timeIn'] as Timestamp;
      final dt = ts.toDate();
      final monthKey = DateTime(dt.year, dt.month, 1);
      if (!monthKey.isBefore(startDate) &&
          !monthKey.isAfter(last12Months.last)) {
        monthCounts[monthKey] = (monthCounts[monthKey] ?? 0) + 1;
      }
    }

    final data =
        last12Months.map((month) {
          final count = (monthCounts[month] ?? 0).toDouble();
          final monthNames = [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec',
          ];
          return ChartDataModel(
            category: monthNames[month.month - 1],
            value: count,
            date: month,
          );
        }).toList();

    return data;
  }

  @override
  Future<List<ChartDataModel>> fetchTopViolators() async {
    final snapshot = await _firestore.collection('violations').get();

    final Map<String, int> counts = {};
    for (final doc in snapshot.docs) {
      final owner = doc['owner'] ?? 'Unknown';
      counts[owner] = (counts[owner] ?? 0) + 1;
    }

    final sorted =
        counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return sorted
        .take(5)
        .map((e) => ChartDataModel(category: e.key, value: e.value.toDouble()))
        .toList();
  }
}

// Extension to get day of year (must be top-level in Dart)
extension DateTimeExtension on DateTime {
  int get dayOfYear {
    final startOfYear = DateTime(year, 1, 1);
    return difference(startOfYear).inDays + 1;
  }
}
