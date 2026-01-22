import 'package:cvms_desktop/features/dashboard/models/dashboard/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/pdf/charts/pdf_bar_chart.dart';
import 'package:cvms_desktop/features/dashboard/pdf/charts/pdf_horizontal_bar_chart.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../models/report/global_vehicle_report_model.dart';
import '../../core/pdf_section.dart';
import '../../components/sections/pdf_section_title.dart';
import '../../components/tables/pdf_table.dart';
import '../../components/sections/pdf_insight_box.dart';
import '../../core/pdf_insight.dart';

class TopViolationsByTypeSection
    implements PdfSection<GlobalVehicleReportModel> {
  final int limit;

  TopViolationsByTypeSection({this.limit = 5});

  @override
  List<pw.Widget> build(GlobalVehicleReportModel report) {
    if (report.violationsByType.isEmpty) {
      return [];
    }

    final totalViolations = report.totalViolations;

    // Step 1: sort by count
    final sorted =
        report.violationsByType.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    // Step 2: take top N (scalable)
    final displayed = sorted.take(limit).toList();

    return [
      PdfSectionTitle(
        title: '7. Top Violations by Type',
        subTitle: 'Most frequently recorded violation categories',
      ),

      pw.SizedBox(height: 10),
      PdfHorizontalBarChart(
        data:
            report.violationsByType.entries
                .map(
                  (e) => ChartDataModel(
                    category: e.key,
                    value: e.value.toDouble(),
                  ),
                )
                .toList(),
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
        title: 'No Violation Data',
        description:
            'No violation type data is available for the selected period.',
      );
    }

    final top = entries.first;
    final percent = (top.value / totalViolations * 100).toStringAsFixed(1);

    return PdfInsight(
      title: 'Most Common Violation',
      description:
          '"${top.key}" was the most frequently recorded violation type '
          'with ${top.value} occurrences, accounting for $percent% '
          'of all recorded violations during the reporting period.',
    );
  }
}
