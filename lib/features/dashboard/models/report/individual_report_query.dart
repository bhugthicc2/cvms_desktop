import 'package:cvms_desktop/features/dashboard/models/report/individual_report_options.dart';
import 'package:cvms_desktop/features/dashboard/models/report/date_range.dart';

class IndividualReportQuery {
  final String vehicleId;
  final DateRange range;
  final IndividualReportOptions options;

  IndividualReportQuery({
    required this.vehicleId,
    required this.range,
    required this.options,
  });
}
