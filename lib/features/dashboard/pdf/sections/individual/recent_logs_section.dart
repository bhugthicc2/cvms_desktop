import 'package:cvms_desktop/core/utils/date_time_formatter.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../models/report/individual_vehicle_report_model.dart';
import '../../core/pdf_section.dart';
import '../../components/sections/pdf_section_title.dart';
import '../../components/tables/pdf_table.dart';
import '../../components/sections/pdf_insight_box.dart';
import '../../core/pdf_insight.dart';

class RecentLogsSection implements PdfSection<IndividualVehicleReportModel> {
  final int limit;

  RecentLogsSection({this.limit = 10});

  @override
  List<pw.Widget> build(IndividualVehicleReportModel report) {
    if (report.recentLogs.isEmpty) {
      return [];
    }

    final rows =
        report.recentLogs.take(limit).map((l) {
          return [
            l.logId,
            DateTimeFormatter.formatFull(l.timeIn),
            l.timeOut == null
                ? 'Still onsite'
                : DateTimeFormatter.formatFull(l.timeOut!),
            l.durationMinutes == null ? '—' : '${l.durationMinutes} mins',
            l.status,
          ];
        }).toList();

    return [
      PdfSectionTitle(
        title: '7. Recent Vehicle Logs',
        subTitle: 'Latest log entries associated with this vehicle',
      ),

      pw.SizedBox(height: 10),

      PdfTable(
        headers: const ['Log ID', 'Time In', 'Time Out', 'Duration', 'Status'],
        rows: rows,
      ),

      pw.SizedBox(height: 12),

      PdfInsightBox(_generateRecentLogsInsight(report)),

      pw.SizedBox(height: 24),
    ];
  }

  PdfInsight _generateRecentLogsInsight(IndividualVehicleReportModel report) {
    final logs = report.recentLogs;

    if (logs.isEmpty) {
      return PdfInsight(
        title: 'No Recent Log Activity',
        description:
            'No recent vehicle log entries were recorded during the selected '
            'reporting period.',
      );
    }

    final total = logs.length;
    final activeLogs = logs.where((l) => l.timeOut == null).length;
    final longStays = logs.where((l) => (l.durationMinutes ?? 0) >= 240).length;

    if (activeLogs > 0) {
      return PdfInsight(
        title: 'Active Vehicle Presence',
        description:
            '$activeLogs out of $total recent log entr${activeLogs > 1 ? 'ies are' : 'y is'} '
            'still marked as onsite, indicating ongoing vehicle activity.',
      );
    }

    if (longStays > 0) {
      return PdfInsight(
        title: 'Extended Vehicle Stay Detected',
        description:
            '$longStays recent log entr${longStays > 1 ? 'ies show' : 'y shows'} '
            'extended onsite durations exceeding standard operational periods.',
      );
    }

    return PdfInsight(
      title: 'Normal Log Activity',
      description:
          'Recent vehicle log entries were properly recorded and completed, '
          'reflecting normal vehicle movement within the facility.',
    );
  }
}
