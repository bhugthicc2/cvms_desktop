import 'package:cvms_desktop/features/dashboard2/models/report/date_range.dart';
import 'package:flutter/material.dart';

Future<DateRange?> showCustomDatePicker(BuildContext context) async {
  DateTimeRange? picked = await showDateRangePicker(
    context: context,
    firstDate: DateTime(2020),
    lastDate: DateTime.now(),
    initialDateRange: DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 7)),
      end: DateTime.now(),
    ),
  );

  if (picked == null) return null;

  return DateRange(picked.start, picked.end);
}
