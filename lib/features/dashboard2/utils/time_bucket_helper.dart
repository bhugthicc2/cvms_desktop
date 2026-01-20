import 'package:cvms_desktop/features/dashboard2/models/dashboard/time_grouping.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class TimeBuckerHelper {
  List<String> generateTimeBuckets(
    DateTime start,
    DateTime end,
    TimeGrouping grouping,
  ) {
    final buckets = <String>[];
    DateTime cursor = start;

    while (!cursor.isAfter(end)) {
      buckets.add(formatBucket(cursor, grouping));

      switch (grouping) {
        case TimeGrouping.day:
          cursor = cursor.add(const Duration(days: 1));
          break;
        case TimeGrouping.week:
          cursor = cursor.add(const Duration(days: 7));
          break;
        case TimeGrouping.month:
          cursor = DateTime(cursor.year, cursor.month + 1);
          break;
        case TimeGrouping.year:
          cursor = DateTime(cursor.year + 1);
          break;
      }
    }

    return buckets;
  }

  String formatBucket(DateTime date, TimeGrouping grouping) {
    switch (grouping) {
      case TimeGrouping.day:
        return DateFormat('yyyy-MM-dd').format(date); // 2025-01-20
      case TimeGrouping.week:
        return 'W${weekNumber(date)}';
      case TimeGrouping.month:
        return DateFormat('yyyy-MM').format(date); // 2025-01
      case TimeGrouping.year:
        return date.year.toString();
    }
  }

  int weekNumber(DateTime date) {
    // step 1: get first day of the year
    final firstDayOfYear = DateTime(date.year, 1, 1);

    // step 2: calculate difference in days
    final daysDifference = date.difference(firstDayOfYear).inDays;

    // step 3: calculate week number (starting at 1)
    return (daysDifference / 7).floor() + 1;
  }

  DateTime? parseBucket(String bucketKey, TimeGrouping grouping) {
    try {
      switch (grouping) {
        case TimeGrouping.day:
          // Parse date format like "2025-01-20"
          return DateTime.parse(bucketKey);

        case TimeGrouping.week:
          // Parse week format like "W1", "W2" to date
          final weekNum = int.tryParse(bucketKey.substring(1));
          if (weekNum != null) {
            final year = DateTime.now().year;
            return DateTime(year, 1, 1).add(Duration(days: (weekNum - 1) * 7));
          }
          break;

        case TimeGrouping.month:
          // Parse month format like "2025-01"
          final parts = bucketKey.split('-');
          if (parts.length == 2) {
            final year = int.tryParse(parts[0]);
            final month = int.tryParse(parts[1]);
            if (year != null && month != null) {
              return DateTime(year, month, 1);
            }
          }
          break;

        case TimeGrouping.year:
          // Parse year string to date
          final year = int.tryParse(bucketKey);
          if (year != null) {
            return DateTime(year, 1, 1);
          }
          break;
      }
    } catch (e) {
      debugPrint('Error parsing bucket key "$bucketKey": $e');
    }
    return null;
  }
}
