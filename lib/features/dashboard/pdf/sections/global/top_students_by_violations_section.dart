import 'package:cvms_desktop/features/dashboard/models/dashboard/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/pdf/charts/pdf_horizontal_bar_chart.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../models/report/global_vehicle_report_model.dart';
import '../../core/pdf_section.dart';
import '../../components/sections/pdf_section_title.dart';
import '../../components/sections/pdf_insight_box.dart';
import '../../core/pdf_insight.dart';

class TopStudentsByViolationsSection
    implements PdfSection<GlobalVehicleReportModel> {
  final int limit;

  TopStudentsByViolationsSection({this.limit = 5});

  @override
  List<pw.Widget> build(GlobalVehicleReportModel report) {
    if (report.topStudentsByViolations.isEmpty) {
      return [];
    }

    final totalViolations = report.totalViolations;

    // Already sorted & limited in repository, but keep safe
    final displayed = report.topStudentsByViolations.take(limit).toList();

    return [
      PdfSectionTitle(
        title: '9. Top $limit Students with Most Violations',
        subTitle: 'Students with the highest number of recorded violations',
      ),

      pw.SizedBox(height: 10),

      PdfHorizontalBarChart(data: displayed),

      pw.SizedBox(height: 12),

      PdfInsightBox(_generateInsight(displayed, totalViolations)),

      pw.SizedBox(height: 24),
    ];
  }

  PdfInsight _generateInsight(
    List<ChartDataModel> entries,
    int totalViolations,
  ) {
    if (entries.isEmpty || totalViolations == 0) {
      return PdfInsight(
        title: 'No Violation Data',
        description:
            'No student violation data is available for the selected reporting period.',
      );
    }

    // Handle equal entries safely
    final highestValue = entries.first.value;
    final topStudents = entries.where((e) => e.value == highestValue).toList();

    final percent = (highestValue / totalViolations * 100).toStringAsFixed(1);

    if (topStudents.length == 1) {
      final student = topStudents.first.category;

      return PdfInsight(
        title: 'Top Violator',
        description:
            '$student recorded the highest number of violations '
            'with ${highestValue.toInt()} incidents, '
            'representing $percent% of all recorded violations '
            'during the reporting period.',
      );
    }

    // Multiple students tied
    final names = topStudents.map((e) => e.category).join(', ');

    return PdfInsight(
      title: 'Multiple Top Violators',
      description:
          'Several students ($names) recorded the highest number of violations '
          'with ${highestValue.toInt()} incidents each. '
          'Together, they account for $percent% of all recorded violations '
          'during the reporting period.',
    );
  }
}
