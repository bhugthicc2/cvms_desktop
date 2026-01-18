import 'package:cvms_desktop/features/dashboard/bloc/dashboard/dashboard_state.dart';

/// Extension methods for TimeRange enum to handle display name conversion
extension TimeRangeExtension on TimeRange {
  /// Converts TimeRange to user-friendly display name
  String get displayName {
    switch (this) {
      case TimeRange.days7:
        return '7 days';
      case TimeRange.month:
        return 'Month';
      case TimeRange.year:
        return 'Year';
    }
  }
}

/// Extension methods for String to handle TimeRange parsing
extension StringExtension on String? {
  /// Converts string to TimeRange enum
  TimeRange? toTimeRange() {
    switch (this) {
      case '7 days':
        return TimeRange.days7;
      case 'Month':
        return TimeRange.month;
      case 'Year':
        return TimeRange.year;
      default:
        return null;
    }
  }
}
