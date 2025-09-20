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

  //--------------------------------todo----------------------------------------------

  @override
  Future<List<ChartDataModel>> fetchWeeklyTrend() async {
    //todo
    final snapshot = await _firestore.collection('vehicle_logs').get();

    final Map<String, int> counts = {};
    for (final doc in snapshot.docs) {
      final ts = doc['timeIn'] as Timestamp;
      final dt = ts.toDate();

      // Get week number of year
      final firstDayOfYear = DateTime(dt.year, 1, 1);
      final daysOffset = dt.difference(firstDayOfYear).inDays;
      final weekOfYear = (daysOffset ~/ 7) + 1;

      final key = "${dt.year}-W${weekOfYear.toString().padLeft(2, '0')}";

      counts[key] = (counts[key] ?? 0) + 1;
    }

    return counts.entries.map((e) {
        final parts = e.key.split('-W');
        final year = int.parse(parts[0]);
        final week = int.parse(parts[1]);

        // Approximate the start date of the week
        final startOfYear = DateTime(year, 1, 1);
        final startOfWeek = startOfYear.add(Duration(days: (week - 1) * 7));

        return ChartDataModel(
          category: e.key, // "2025-W37"
          value: e.value.toDouble(),
          date: startOfWeek,
        );
      }).toList()
      ..sort((a, b) => a.date!.compareTo(b.date!)); // sort chronologically
  }

  // --------------------------------todo----------------------------------------------
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
