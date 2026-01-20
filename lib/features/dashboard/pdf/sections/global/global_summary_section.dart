import 'package:pdf/widgets.dart' as pw;

import '../../core/pdf_section.dart';
import '../../core/pdf_insight.dart';
import '../../components/sections/pdf_section_title.dart';
import '../../components/sections/pdf_insight_box.dart';
import '../../components/tables/pdf_table.dart';
import '../../../models/report/global_vehicle_report_model.dart';

class GlobalSummarySection implements PdfSection<GlobalVehicleReportModel> {
  @override
  List<pw.Widget> build(GlobalVehicleReportModel report) {
    final insight = _generateInsight(report);

    return [
      PdfSectionTitle(
        title: '1. Executive Summary',
        subTitle: 'Overall vehicle monitoring statistics',
      ),

      pw.SizedBox(height: 10),

      _buildSummaryTable(report),

      pw.SizedBox(height: 12),

      PdfInsightBox(insight),

      pw.SizedBox(height: 24),
    ];
  }

  pw.Widget _buildSummaryTable(GlobalVehicleReportModel report) {
    return PdfTable(
      headers: const ['Metric', 'Value', 'Metric', 'Value'],
      rows: [
        [
          'Total Vehicles',
          report.totalVehicles.toString(),
          'Total Logs',
          report.totalFleetLogs.toString(),
        ],
        [
          'Total Violations',
          report.totalViolations.toString(),
          'Pending Violations',
          report.pendingViolations.toString(),
        ],
      ],
      columnWidths: const {
        0: pw.FlexColumnWidth(2),
        1: pw.FlexColumnWidth(1),
        2: pw.FlexColumnWidth(2),
        3: pw.FlexColumnWidth(1),
      },
    );
  }

  PdfInsight _generateInsight(GlobalVehicleReportModel report) {
    if (report.totalVehicles == 0) {
      return PdfInsight(
        title: 'No Registered Vehicles',
        description:
            'There are currently no registered vehicles within the selected reporting period.',
      );
    }

    final violationRate = (report.totalViolations / report.totalVehicles * 100)
        .toStringAsFixed(1);

    return PdfInsight(
      title: 'Remarks: ',
      description:
          'A total of ${report.totalVehicles} vehicles were monitored during '
          'the selected period, generating ${report.totalFleetLogs} logs. '
          '${report.totalViolations} violations were recorded, '
          'with ${report.pendingViolations} pending cases. '
          'This represents an overall violation rate of $violationRate%.',
    );
  }
}
