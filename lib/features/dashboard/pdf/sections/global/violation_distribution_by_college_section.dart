import 'package:pdf/widgets.dart' as pw;

import '../../../models/report/global_vehicle_report_model.dart';
import '../../core/pdf_section.dart';
import '../../components/sections/pdf_section_title.dart';
import '../../components/tables/pdf_table.dart';
import '../../components/sections/pdf_insight_box.dart';
import '../../core/pdf_insight.dart';

class ViolationDistributionByCollegeSection
    implements PdfSection<GlobalVehicleReportModel> {
  final int limit;

  ViolationDistributionByCollegeSection({this.limit = 5});

  @override
  List<pw.Widget> build(GlobalVehicleReportModel report) {
    if (report.violationsByCollege.isEmpty) {
      return [];
    }

    final totalViolations = report.totalViolations;

    final sorted =
        report.violationsByCollege.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    final displayed = sorted.take(limit).toList();

    final rows =
        displayed.map((e) {
          final percent =
              totalViolations == 0 ? 0 : (e.value / totalViolations * 100);
          return [e.key, e.value.toString(), '${percent.toStringAsFixed(1)}%'];
        }).toList();

    return [
      PdfSectionTitle(
        title: '6. Violation Distribution per College',
        subTitle: 'Colleges with the highest recorded vehicle violations',
      ),

      pw.SizedBox(height: 10),

      PdfTable(
        headers: const ['College', 'Violation Count', 'Percentage'],
        rows: rows,
        columnWidths: const {
          0: pw.FlexColumnWidth(3),
          1: pw.FlexColumnWidth(1),
          2: pw.FlexColumnWidth(1),
        },
      ),

      pw.SizedBox(height: 12),

      PdfInsightBox(_generateInsight(displayed, totalViolations)),

      pw.SizedBox(height: 24),
    ];
  }

  PdfInsight _generateInsight(
    List<MapEntry<String, int>> entries,
    int totalViolations,
  ) {
    if (entries.isEmpty || totalViolations == 0) {
      return PdfInsight(
        title: 'No Violation Distribution Data',
        description:
            'No violation distribution data is available for the selected period.',
      );
    }

    final top = entries.first;
    final percent = (top.value / totalViolations * 100).toStringAsFixed(1);

    return PdfInsight(
      title: 'Violation Concentration',
      description:
          '${top.key} recorded the highest number of vehicle violations '
          'with ${top.value} cases, accounting for $percent% '
          'of all violations during the reporting period.',
    );
  }
}
