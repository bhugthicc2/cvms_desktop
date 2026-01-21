import 'package:cvms_desktop/features/dashboard/pdf/components/sections/pdf_insight_box.dart';
import 'package:cvms_desktop/features/dashboard/pdf/core/pdf_insight.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../models/report/individual_vehicle_report_model.dart';
import '../../core/pdf_section.dart';
import '../../components/sections/pdf_section_title.dart';
import '../../components/tables/pdf_table.dart';
import '../../../../../core/utils/date_time_formatter.dart';

class VehicleLogsSection implements PdfSection<IndividualVehicleReportModel> {
  @override
  List<pw.Widget> build(IndividualVehicleReportModel report) {
    if (report.vehicleLogsTrend.isEmpty) {
      return [];
    }

    final rows =
        report.vehicleLogsTrend.map((e) {
          return [
            e.date != null ? DateTimeFormatter.formatAbbreviated(e.date!) : '—',
            e.value.toInt().toString(),
          ];
        }).toList();

    return [
      PdfSectionTitle(
        title: '5. Vehicle Logs Summary',
        subTitle: 'Log frequency within the selected period',
      ),

      pw.SizedBox(height: 10),

      PdfTable(
        headers: const ['Date', 'Log Count'],
        rows: rows,
        columnWidths: const {
          0: pw.FlexColumnWidth(3),
          1: pw.FlexColumnWidth(1),
        },
      ),

      pw.SizedBox(height: 12),

      PdfInsightBox(_generateLogsInsight(report)),

      pw.SizedBox(height: 24),
    ];
  }

  PdfInsight _generateLogsInsight(IndividualVehicleReportModel report) {
    final logs = report.vehicleLogsTrend;

    if (logs.isEmpty) {
      return PdfInsight(
        title: 'No Log Activity',
        description:
            'No vehicle log activity was recorded during the selected reporting '
            'period.',
      );
    }

    final values = logs.map((e) => e.value.toInt()).toList();
    final totalLogs = values.fold<int>(0, (a, b) => a + b);
    final periods = values.length;

    final maxLogs = values.reduce((a, b) => a > b ? a : b);
    final minLogs = values.reduce((a, b) => a < b ? a : b);
    final avgLogs = totalLogs / periods;

    if (totalLogs == 0) {
      return PdfInsight(
        title: 'Inactive Vehicle',
        description:
            'The vehicle recorded no log activity across all measured periods '
            'during the selected reporting window. This may indicate inactivity '
            'or limited operational deployment.',
      );
    }

    if (maxLogs >= avgLogs * 2 && maxLogs > 1) {
      return PdfInsight(
        title: 'Irregular Usage Pattern',
        description:
            'Vehicle log activity shows a noticeable spike, with up to $maxLogs '
            'log(s) recorded in a single period compared to an average of '
            '${avgLogs.toStringAsFixed(1)} per period. This suggests irregular or '
            'event-based usage during the reporting period.',
      );
    }

    if ((maxLogs - minLogs) <= 1) {
      return PdfInsight(
        title: 'Consistent Vehicle Usage',
        description:
            'Log activity remains relatively consistent across the reporting '
            'period, averaging ${avgLogs.toStringAsFixed(1)} log(s) per period. '
            'This indicates stable and routine vehicle utilization.',
      );
    }

    return PdfInsight(
      title: 'Variable Usage Pattern',
      description:
          'The vehicle recorded a total of $totalLogs log(s) across $periods '
          'periods. Activity levels varied throughout the reporting window, '
          'indicating fluctuating usage intensity.',
    );
  }
}
