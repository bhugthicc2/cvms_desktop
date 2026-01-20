import 'package:cvms_desktop/features/dashboard/models/report/date_range.dart';

import 'report_period_type.dart';

class ReportPeriod {
  final ReportPeriodType type;

  /// Used only for customRange
  final DateTime? start;
  final DateTime? end;

  /// Used only for specificDate
  final DateTime? date;

  const ReportPeriod._({required this.type, this.start, this.end, this.date});

  // ---------- FACTORIES ----------

  factory ReportPeriod.today() => ReportPeriod._(type: ReportPeriodType.today);

  factory ReportPeriod.yesterday() =>
      ReportPeriod._(type: ReportPeriodType.yesterday);

  factory ReportPeriod.last7Days() =>
      ReportPeriod._(type: ReportPeriodType.last7Days);

  factory ReportPeriod.last30Days() =>
      ReportPeriod._(type: ReportPeriodType.last30Days);

  factory ReportPeriod.thisWeek() =>
      ReportPeriod._(type: ReportPeriodType.thisWeek);

  factory ReportPeriod.thisMonth() =>
      ReportPeriod._(type: ReportPeriodType.thisMonth);

  factory ReportPeriod.thisYear() =>
      ReportPeriod._(type: ReportPeriodType.thisYear);

  factory ReportPeriod.customRange({
    required DateTime start,
    required DateTime end,
  }) => ReportPeriod._(
    type: ReportPeriodType.customRange,
    start: start,
    end: end,
  );

  factory ReportPeriod.specificDate(DateTime date) =>
      ReportPeriod._(type: ReportPeriodType.specificDate, date: date);

  // ---------- RESOLUTION ----------

  DateRange resolve() {
    final now = DateTime.now();

    switch (type) {
      case ReportPeriodType.today:
        return DateRange.day(DateTime(now.year, now.month, now.day));

      case ReportPeriodType.yesterday:
        final y = now.subtract(const Duration(days: 1));
        return DateRange.day(DateTime(y.year, y.month, y.day));

      case ReportPeriodType.last7Days:
        return DateRange.customRange(
          now.subtract(const Duration(days: 6)),
          now,
        );

      case ReportPeriodType.last30Days:
        return DateRange.customRange(
          now.subtract(const Duration(days: 29)),
          now,
        );

      case ReportPeriodType.thisWeek:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return DateRange.customRange(
          DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
          now,
        );

      case ReportPeriodType.thisMonth:
        return DateRange.month(now.year, now.month);

      case ReportPeriodType.thisYear:
        return DateRange.year(now.year);

      case ReportPeriodType.customRange:
        return DateRange.customRange(start!, end!);

      case ReportPeriodType.specificDate:
        return DateRange.day(DateTime(date!.year, date!.month, date!.day));
    }
  }

  // ---------- LABELS ----------

  String get label {
    switch (type) {
      case ReportPeriodType.today:
        return 'Today';
      case ReportPeriodType.yesterday:
        return 'Yesterday';
      case ReportPeriodType.last7Days:
        return 'Last 7 Days';
      case ReportPeriodType.last30Days:
        return 'Last 30 Days';
      case ReportPeriodType.thisWeek:
        return 'This Week';
      case ReportPeriodType.thisMonth:
        return 'This Month';
      case ReportPeriodType.thisYear:
        return 'This Year';
      case ReportPeriodType.customRange:
        return 'Custom Range';
      case ReportPeriodType.specificDate:
        return 'Specific Date';
    }
  }

  bool get isCustom =>
      type == ReportPeriodType.customRange ||
      type == ReportPeriodType.specificDate;
}
