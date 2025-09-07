import 'package:cvms_desktop/features/report_and_analytics/models/report_model.dart';

abstract class ReportDataSource {
  Future<List<ReportModel>> fetchReports({DateTime? from, DateTime? to});
}
