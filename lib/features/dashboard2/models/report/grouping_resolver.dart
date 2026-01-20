import 'report_period_type.dart';
import 'time_grouping.dart';

class GroupingResolver {
  static TimeGrouping resolve(ReportPeriodType type) {
    switch (type) {
      case ReportPeriodType.today:
      case ReportPeriodType.specificDate:
        return TimeGrouping.hour;

      case ReportPeriodType.last7Days:
      case ReportPeriodType.thisWeek:
        return TimeGrouping.day;

      case ReportPeriodType.last30Days:
      case ReportPeriodType.thisMonth:
        return TimeGrouping.day;

      case ReportPeriodType.thisYear:
        return TimeGrouping.month;

      case ReportPeriodType.customRange:
        return TimeGrouping.day;

      default:
        throw UnimplementedError();
    }
  }
}
