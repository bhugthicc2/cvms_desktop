import 'package:cvms_desktop/features/dashboard2/models/report/individual_report_options.dart';

class IndividualReportQuery {
  final String vehicleId;
  final DateTime start;
  final DateTime end;
  final IndividualReportOptions options;

  IndividualReportQuery({
    required this.vehicleId,
    required this.start,
    required this.end,
    required this.options,
  });
}
