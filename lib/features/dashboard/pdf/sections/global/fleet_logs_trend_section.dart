import 'package:cvms_desktop/features/dashboard/models/dashboard/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/pdf/charts/pdf_bar_chart.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/pdf_section.dart';
import '../../core/pdf_insight.dart';
import '../../components/sections/pdf_section_title.dart';
import '../../components/sections/pdf_insight_box.dart';
import '../../../models/report/global_vehicle_report_model.dart';
import '../../../../../core/utils/date_time_formatter.dart';

class FleetLogsTrendSection implements PdfSection<GlobalVehicleReportModel> {
  @override
  List<pw.Widget> build(GlobalVehicleReportModel report) {
    if (report.fleetLogsTrend.isEmpty) return [];

    final sorted = [...report.fleetLogsTrend]
      ..sort((a, b) => b.value.compareTo(a.value));

    final peak = sorted.first;
    final average = report.totalFleetLogs / report.fleetLogsTrend.length;

    return [
      PdfSectionTitle(
        title: '8. Fleet Logs Activity Overview',
        subTitle: 'Vehicle log distribution within the selected period',
      ),

      pw.SizedBox(height: 10),

      PdfBarChart(
        data:
            report.fleetLogsTrend
                .map(
                  (e) => ChartDataModel(
                    category:
                        e.date != null
                            ? DateTimeFormatter.formatAbbreviated(e.date!)
                            : e.category,
                    value: e.value.toDouble(),
                  ),
                )
                .toList(),
      ),

      pw.SizedBox(height: 12),

      PdfInsightBox(
        PdfInsight(
          title: 'Activity Analysis',
          description:
              'A total of ${report.totalFleetLogs} vehicle logs were '
              'recorded during the selected period. '
              'The highest activity occurred on ${peak.date != null ? DateTimeFormatter.formatAbbreviated(peak.date!) : peak.category} '
              'with ${peak.value.toInt()} logs. '
              'On average, ${average.toStringAsFixed(1)} '
              'logs were recorded per active day.',
        ),
      ),

      pw.SizedBox(height: 24),
    ];
  }
}
