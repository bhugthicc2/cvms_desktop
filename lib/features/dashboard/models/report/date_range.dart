import 'package:cvms_desktop/core/utils/date_time_formatter.dart';

enum DatePeriodType { day, week, month, year, customRange }

class DateRange {
  final DateTime start;
  final DateTime end;
  final DatePeriodType type;

  const DateRange(
    this.start,
    this.end, [
    this.type = DatePeriodType.customRange,
  ]);

  // Factory constructors for different period types
  factory DateRange.day(DateTime date) {
    return DateRange(date, date, DatePeriodType.day);
  }

  factory DateRange.week(DateTime startOfWeek, DateTime endOfWeek) {
    return DateRange(startOfWeek, endOfWeek, DatePeriodType.week);
  }

  factory DateRange.month(int year, int month) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0); // Last day of month
    return DateRange(start, end, DatePeriodType.month);
  }

  factory DateRange.year(int year) {
    final start = DateTime(year, 1, 1);
    final end = DateTime(year, 12, 31);
    return DateRange(start, end, DatePeriodType.year);
  }

  factory DateRange.customRange(DateTime start, DateTime end) {
    return DateRange(start, end, DatePeriodType.customRange);
  }

  Duration get duration => end.difference(start);

  bool contains(DateTime date) {
    return !date.isBefore(start) && !date.isAfter(end);
  }

  @override
  String toString() {
    switch (type) {
      case DatePeriodType.day:
        return DateTimeFormatter.formatAbbreviated(start);
      case DatePeriodType.week:
        return '${DateTimeFormatter.formatAbbreviated(start)} - ${DateTimeFormatter.formatAbbreviated(end)}';
      case DatePeriodType.month:
        // Get full month name and year
        final monthNames = [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December',
        ];
        return '${monthNames[start.month - 1]} ${start.year}';
      case DatePeriodType.year:
        return start.year.toString();
      case DatePeriodType.customRange:
        return '${DateTimeFormatter.formatAbbreviated(start)} - ${DateTimeFormatter.formatAbbreviated(end)}';
    }
  }
}
