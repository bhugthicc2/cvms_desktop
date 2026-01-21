import 'package:cvms_desktop/features/dashboard/pdf/components/sections/pdf_insight_box.dart';
import 'package:cvms_desktop/features/dashboard/pdf/core/pdf_insight.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../models/report/individual_vehicle_report_model.dart';
import '../../core/pdf_section.dart';
import '../../components/sections/pdf_section_title.dart';
import '../../components/tables/pdf_table.dart';

class IndividualSummaryMetricsSection
    implements PdfSection<IndividualVehicleReportModel> {
  @override
  List<pw.Widget> build(IndividualVehicleReportModel report) {
    return [
      PdfSectionTitle(
        title: '3. Summary Metrics',
        subTitle: 'Key statistics for the selected reporting period',
      ),

      pw.SizedBox(height: 10),

      PdfTable(
        headers: const ['Metric', 'Value'],
        rows: [
          ['Total Violations', report.totalViolations.toString()],
          ['Pending Violations', report.pendingViolations.toString()],
          ['Total Vehicle Logs', report.totalLogs.toString()],
        ],
        columnWidths: const {
          0: pw.FlexColumnWidth(1),
          1: pw.FlexColumnWidth(1),
        },
      ),

      pw.SizedBox(height: 12),

      PdfInsightBox(_generateSummaryInsight(report)),

      pw.SizedBox(height: 24),
    ];
  }

  PdfInsight _generateSummaryInsight(IndividualVehicleReportModel report) {
    final totalViolations = report.totalViolations;
    final pendingViolations = report.pendingViolations;
    final totalLogs = report.totalLogs;
    final period = report.period;

    if (totalLogs == 0 && totalViolations == 0) {
      return PdfInsight(
        title: 'No Recorded Activity',
        description:
            'No vehicle logs or violations were recorded during the selected '
            'reporting period ($period). This may indicate that the '
            'vehicle was inactive or not in regular use.',
      );
    }

    if (pendingViolations > 0) {
      return PdfInsight(
        title: 'Pending Compliance Issues',
        description:
            'There are $pendingViolations pending violation(s) associated with this '
            'vehicle during the selected period ($period). '
            'These violations require review or resolution to ensure compliance '
            'with vehicle usage policies.',
      );
    }

    if (totalViolations > 0 && totalLogs > 0) {
      final ratio = totalViolations / totalLogs;

      if (ratio >= 0.5) {
        return PdfInsight(
          title: 'High Violation Frequency',
          description:
              'This vehicle recorded $totalViolations violation(s) across '
              '$totalLogs usage log(s) during the reporting period ($period). '
              'The frequency of violations relative to usage suggests a higher '
              'risk usage pattern and may warrant closer monitoring.',
        );
      }

      return PdfInsight(
        title: 'Moderate Usage Compliance',
        description:
            'The vehicle recorded $totalViolations violation(s) over '
            '$totalLogs usage log(s) during the reporting period ($period). '
            'Overall usage appears generally compliant, with isolated incidents '
            'noted.',
      );
    }

    if (totalLogs > 0 && totalViolations == 0) {
      return PdfInsight(
        title: 'Compliant Vehicle Usage',
        description:
            'This vehicle recorded $totalLogs usage log(s) with no violations '
            'during the selected reporting period ($period). '
            'Usage patterns indicate good compliance with vehicle regulations.',
      );
    }

    return PdfInsight(
      title: 'Summary Overview',
      description:
          'The summary metrics provide an overview of vehicle usage and '
          'violation activity for the selected reporting period.',
    );
  }
}
