import 'package:cvms_desktop/features/dashboard2/models/time_grouping.dart';
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
        return DateFormat('EEE').format(date); // Mon, Tue
      case TimeGrouping.week:
        return 'W${weekNumber(date)}';
      case TimeGrouping.month:
        return DateFormat('MMM').format(date); // Jan, Feb
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
          // Parse day names like "Mon", "Tue" to recent date
          final now = DateTime.now();
          final dayMap = {
            'Mon': now.subtract(Duration(days: (now.weekday - 1) % 7)),
            'Tue': now.subtract(Duration(days: (now.weekday - 2) % 7)),
            'Wed': now.subtract(Duration(days: (now.weekday - 3) % 7)),
            'Thu': now.subtract(Duration(days: (now.weekday - 4) % 7)),
            'Fri': now.subtract(Duration(days: (now.weekday - 5) % 7)),
            'Sat': now.subtract(Duration(days: (now.weekday - 6) % 7)),
            'Sun': now.subtract(Duration(days: (now.weekday - 7) % 7)),
          };
          return dayMap[bucketKey];

        case TimeGrouping.week:
          // Parse week format like "W1", "W2" to date
          final weekNum = int.tryParse(bucketKey.substring(1));
          if (weekNum != null) {
            final year = DateTime.now().year;
            return DateTime(year, 1, 1).add(Duration(days: (weekNum - 1) * 7));
          }
          break;

        case TimeGrouping.month:
          // Parse month names like "Jan", "Feb" to date
          final monthMap = {
            'Jan': 1,
            'Feb': 2,
            'Mar': 3,
            'Apr': 4,
            'May': 5,
            'Jun': 6,
            'Jul': 7,
            'Aug': 8,
            'Sep': 9,
            'Oct': 10,
            'Nov': 11,
            'Dec': 12,
          };
          final month = monthMap[bucketKey];
          if (month != null) {
            final year = DateTime.now().year;
            return DateTime(year, month, 1);
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
