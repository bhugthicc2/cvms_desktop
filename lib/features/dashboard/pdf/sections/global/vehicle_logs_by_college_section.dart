import 'package:pdf/widgets.dart' as pw;

import '../../../models/report/global_vehicle_report_model.dart';
import '../../core/pdf_section.dart';
import '../../components/sections/pdf_section_title.dart';
import '../../components/tables/pdf_table.dart';
import '../../components/sections/pdf_insight_box.dart';
import '../../core/pdf_insight.dart';

class VehicleLogsByCollegeSection
    implements PdfSection<GlobalVehicleReportModel> {
  final int limit;

  VehicleLogsByCollegeSection({this.limit = 5});

  @override
  List<pw.Widget> build(GlobalVehicleReportModel report) {
    if (report.logsByCollege.isEmpty) {
      return [];
    }

    final totalLogs = report.totalFleetLogs;

    final sorted =
        report.logsByCollege.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    final displayed = sorted.take(limit).toList();

    final rows =
        displayed.map((e) {
          final percent = totalLogs == 0 ? 0 : (e.value / totalLogs * 100);
          return [e.key, e.value.toString(), '${percent.toStringAsFixed(1)}%'];
        }).toList();

    return [
      PdfSectionTitle(
        title: '5. Vehicle Logs Distribution per College',
        subTitle:
            'Colleges generating the highest number of vehicle log entries',
      ),

      pw.SizedBox(height: 10),

      PdfTable(
        headers: const ['College', 'Log Count', 'Percentage'],
        rows: rows,
        columnWidths: const {
          0: pw.FlexColumnWidth(1),
          1: pw.FlexColumnWidth(1),
          2: pw.FlexColumnWidth(1),
        },
      ),

      pw.SizedBox(height: 12),

      PdfInsightBox(_generateInsight(displayed, totalLogs)),

      pw.SizedBox(height: 24),
    ];
  }

  PdfInsight _generateInsight(
    List<MapEntry<String, int>> entries,
    int totalLogs,
  ) {
    if (entries.isEmpty || totalLogs == 0) {
      return PdfInsight(
        title: 'No Log Distribution Data',
        description:
            'No vehicle log distribution data is available for the selected period.',
      );
    }

    final top = entries.first;
    final percent = (top.value / totalLogs * 100).toStringAsFixed(1);

    return PdfInsight(
      title: 'Log Activity Concentration',
      description:
          '${top.key} generated the highest number of vehicle logs '
          'with ${top.value} entries, accounting for $percent% '
          'of all recorded vehicle logs during the reporting period.',
    );
  }
}
