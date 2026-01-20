import 'package:cvms_desktop/core/utils/date_time_formatter.dart';

class DateRange {
  final DateTime start;
  final DateTime end;

  const DateRange(this.start, this.end);

  Duration get duration => end.difference(start);

  bool contains(DateTime date) {
    return !date.isBefore(start) && !date.isAfter(end);
  }

  @override
  String toString() {
    return '${DateTimeFormatter.formatAbbreviated(start)} - ${DateTimeFormatter.formatAbbreviated(end)}';
  }
}
