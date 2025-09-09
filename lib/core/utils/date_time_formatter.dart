import 'package:intl/intl.dart';

class DateTimeFormatter {
  ///January 12, 2025 10:12 AM
  static String formatFull(DateTime dateTime) {
    final formatter = DateFormat('MMMM d, y hh:mm a');
    return formatter.format(dateTime);
  }

  ///01/12/2025 10:12 AM
  static String formatNumeric(DateTime dateTime) {
    final formatter = DateFormat('MM/dd/yyyy hh:mm a');
    return formatter.format(dateTime);
  }
}
