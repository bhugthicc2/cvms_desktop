import 'package:pdf/widgets.dart' as pw;

import '../../../models/report/individual_vehicle_report_model.dart';
import '../../core/pdf_section.dart';
import '../../components/sections/pdf_section_title.dart';
import '../../components/tables/pdf_table.dart';
import '../../components/sections/pdf_insight_box.dart';
import '../../core/pdf_insight.dart';

class ViolationsByTypeSection
    implements PdfSection<IndividualVehicleReportModel> {
  @override
  List<pw.Widget> build(IndividualVehicleReportModel report) {
    final data = report.violationsByType;

    if (data.isEmpty) {
      return [];
    }

    final total = data.fold<int>(0, (sum, e) => sum + e.value.toInt());

    final sorted = [...data]..sort((a, b) => b.value.compareTo(a.value));

    final rows =
        sorted.map((e) {
          return [e.category, e.value.toInt().toString()];
        }).toList();

    return [
      pw.SizedBox(height: 24),
      PdfSectionTitle(
        title: '4. Violations by Type',
        subTitle: 'Distribution of violations recorded for this vehicle',
      ),

      pw.SizedBox(height: 10),

      PdfTable(
        headers: const ['Violation Type', 'Count'],
        rows: rows,
        columnWidths: const {
          0: pw.FlexColumnWidth(3),
          1: pw.FlexColumnWidth(1),
        },
      ),

      pw.SizedBox(height: 12),

      PdfInsightBox(_generateInsight(sorted, total)),

      pw.SizedBox(height: 24),
    ];
  }

  PdfInsight _generateInsight(List<dynamic> sorted, int total) {
    if (sorted.isEmpty || total == 0) {
      return PdfInsight(
        title: 'No Violation Pattern',
        description:
            'No violation records were found for this vehicle during the selected period.',
      );
    }

    final maxCount = sorted.first.value;
    final topViolations = sorted.where((e) => e.value == maxCount).toList();

    if (topViolations.length > 1) {
      return PdfInsight(
        title: 'No Dominant Violation Pattern',
        description:
            'Violation records for this vehicle are evenly distributed across '
            '${topViolations.length} types, with each recorded $maxCount time(s). '
            'No single violation type stands out as the primary pattern.',
      );
    }

    final top = topViolations.first;
    final percent = (top.value / total * 100).toStringAsFixed(1);

    return PdfInsight(
      title: 'Primary Violation Pattern',
      description:
          'The most frequent violation recorded for this vehicle is '
          '"${top.category}", accounting for ${top.value.toInt()} '
          'out of $total violations ($percent%).',
    );
  }
}
