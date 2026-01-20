import 'package:cvms_desktop/features/dashboard/utils/year_level_formatter.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../models/report/global_vehicle_report_model.dart';
import '../../core/pdf_section.dart';
import '../../components/sections/pdf_section_title.dart';
import '../../components/tables/pdf_table.dart';
import '../../components/sections/pdf_insight_box.dart';
import '../../core/pdf_insight.dart';

//step 6 for adding a report entry

class YearLevelBreakdownSection
    implements PdfSection<GlobalVehicleReportModel> {
  @override
  List<pw.Widget> build(GlobalVehicleReportModel report) {
    if (report.vehiclesByYearLevel.isEmpty) {
      return [];
    }

    final total = report.totalVehicles;
    final entries =
        report.vehiclesByYearLevel.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    final rows =
        entries.map((e) {
          final percent = total == 0 ? 0 : (e.value / total * 100);

          // Format year level with suffix (1st, 2nd, 3rd, 4th, etc.)
          String formattedYearLevel = YearLevelFormatter().formatYearLevel(
            e.key,
          );

          return [
            formattedYearLevel,
            e.value.toString(),
            '${percent.toStringAsFixed(1)}%',
          ];
        }).toList();

    return [
      PdfSectionTitle(
        title: '3. Year Level Breakdown',
        subTitle: 'Distribution of registered vehicles by student year level',
      ),

      pw.SizedBox(height: 10),

      PdfTable(
        headers: const ['Year Level', 'Vehicle Count', 'Percentage'],
        rows: rows,
        columnWidths: const {
          0: pw.FlexColumnWidth(2),
          1: pw.FlexColumnWidth(1),
          2: pw.FlexColumnWidth(1),
        },
      ),

      pw.SizedBox(height: 12),

      PdfInsightBox(_generateInsight(entries, total)),

      pw.SizedBox(height: 24),
    ];
  }

  PdfInsight _generateInsight(List<MapEntry<String, int>> entries, int total) {
    if (entries.isEmpty || total == 0) {
      return PdfInsight(
        title: 'No Year Level Data',
        description:
            'No vehicle registration data by year level is available for the selected period.',
      );
    }

    final top = entries.first;
    final percent = (top.value / total * 100).toStringAsFixed(1);
    final formattedYearLevel = YearLevelFormatter().formatYearLevel(top.key);

    return PdfInsight(
      title: 'Year Level Insight',
      description:
          '$formattedYearLevel students registered the highest number of vehicles '
          'with ${top.value} vehicles, accounting for $percent% '
          'of the total registered vehicles.',
    );
  }
}
