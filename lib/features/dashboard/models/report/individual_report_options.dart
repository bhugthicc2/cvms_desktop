import 'package:cvms_desktop/features/dashboard/utils/pdf/pdf_branding.dart';

class IndividualReportOptions {
  final bool includeViolationSummary;
  final bool includeRecentLogs;
  final bool includeCharts;
  final PdfBranding branding;

  const IndividualReportOptions({
    this.includeViolationSummary = true,
    this.includeRecentLogs = true,
    this.includeCharts = false,
    required this.branding,
  });
}
