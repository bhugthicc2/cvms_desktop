import 'package:cvms_desktop/core/utils/date_time_formatter.dart';
import 'package:cvms_desktop/features/dashboard/pdf/components/sections/pdf_insight_box.dart';
import 'package:cvms_desktop/features/dashboard/pdf/core/pdf_insight.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../models/report/individual_vehicle_report_model.dart';
import '../../core/pdf_section.dart';
import '../../components/sections/pdf_section_title.dart';
import '../../components/tables/pdf_table.dart';

class ViolationHistorySection
    implements PdfSection<IndividualVehicleReportModel> {
  final int limit;

  ViolationHistorySection({this.limit = 10});

  @override
  List<pw.Widget> build(IndividualVehicleReportModel report) {
    if (report.recentViolations.isEmpty) {
      return [];
    }

    final rows =
        report.recentViolations.take(limit).map((v) {
          return [
            DateTimeFormatter.formatAbbreviated(v.dateTime).toString(),
            v.violationType.toString(),
            v.reportedBy.toString(),
            DateTimeFormatter.formatAbbreviated(v.createdAt).toString(),
            v.status.toString(),
          ];
        }).toList();

    return [
      PdfSectionTitle(
        title: '6. Violation History',
        subTitle: 'Most recent recorded violations',
      ),

      pw.SizedBox(height: 10),

      PdfTable(
        headers: const ['Date', 'Type', 'Reported by', 'Reported at', 'Status'],
        rows: rows,
      ),

      pw.SizedBox(height: 12),

      PdfInsightBox(_generateViolationHistoryInsight(report)),

      pw.SizedBox(height: 24),
    ];
  }

  PdfInsight _generateViolationHistoryInsight(
    IndividualVehicleReportModel report,
  ) {
    final violations = report.recentViolations;

    if (violations.isEmpty) {
      return PdfInsight(
        title: 'No Violation Records',
        description:
            'No violation records were found for this vehicle during the '
            'selected reporting period.',
      );
    }

    final total = violations.length;
    final pending =
        violations.where((v) => v.status.toLowerCase() == 'pending').length;

    final Map<String, int> typeCounts = {};
    for (final v in violations) {
      typeCounts[v.violationType] = (typeCounts[v.violationType] ?? 0) + 1;
    }

    final sortedTypes =
        typeCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    final topType = sortedTypes.first;
    final hasRepeatType = topType.value > 1;

    final mostRecent = violations
        .map((v) => v.createdAt)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    if (pending > 0) {
      return PdfInsight(
        title: 'Pending Violation Attention Required',
        description:
            '$pending out of $total recent violation(s) are currently marked '
            'as pending. Follow-up actions may be required to ensure timely '
            'resolution and compliance.',
      );
    }

    if (hasRepeatType) {
      return PdfInsight(
        title: 'Recurring Violation Pattern',
        description:
            'The violation type "${topType.key}" appears multiple times '
            '(${topType.value} occurrences) within the recent records. '
            'This may indicate a recurring compliance issue that could benefit '
            'from further review or preventive measures.',
      );
    }

    return PdfInsight(
      title: 'Resolved Violation Records',
      description:
          'All $total recorded violation(s) within this period have been '
          'resolved, with no single violation type dominating the records. '
          'The most recent report was recorded on '
          '${DateTimeFormatter.formatAbbreviated(mostRecent)}.',
    );
  }
}
