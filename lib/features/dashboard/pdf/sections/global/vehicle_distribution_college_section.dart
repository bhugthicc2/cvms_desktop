import 'package:pdf/widgets.dart' as pw;

import '../../../models/report/global_vehicle_report_model.dart';
import '../../core/pdf_section.dart';
import '../../components/sections/pdf_section_title.dart';
import '../../components/sections/pdf_insight_box.dart';
import '../../core/pdf_insight.dart';
import '../../components/tables/pdf_table.dart';

class VehicleDistributionCollegeSection
    implements PdfSection<GlobalVehicleReportModel> {
  @override
  List<pw.Widget> build(GlobalVehicleReportModel report) {
    if (report.vehiclesPerCollege.isEmpty) {
      return [];
    }

    final totalVehicles = report.totalVehicles;
    final sortedEntries =
        report.vehiclesPerCollege.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    final rows =
        sortedEntries.map((entry) {
          final percentage =
              totalVehicles == 0 ? 0 : (entry.value / totalVehicles * 100);

          return [
            entry.key,
            entry.value.toString(),
            '${percentage.toStringAsFixed(1)}%',
          ];
        }).toList();

    return [
      PdfSectionTitle(
        title: '2. Vehicle Distribution per College',
        subTitle: 'Breakdown of registered vehicles by academic unit',
      ),

      pw.SizedBox(height: 10),

      PdfTable(
        headers: const ['College', 'Vehicle Count', 'Percentage'],
        rows: rows,
        columnWidths: const {
          0: pw.FlexColumnWidth(3),
          1: pw.FlexColumnWidth(1),
          2: pw.FlexColumnWidth(1),
        },
      ),

      pw.SizedBox(height: 12),

      PdfInsightBox(_generateInsight(sortedEntries, totalVehicles)),

      pw.SizedBox(height: 5),
    ];
  }

  PdfInsight _generateInsight(
    List<MapEntry<String, int>> entries,
    int totalVehicles,
  ) {
    if (entries.isEmpty || totalVehicles == 0) {
      return PdfInsight(
        title: 'No Distribution Data',
        description:
            'Vehicle distribution data is currently unavailable for the selected period.',
      );
    }

    final top = entries.first;

    // Add error handling for invalid data
    if (top.value <= 0 || totalVehicles <= 0) {
      return PdfInsight(
        title: 'Data Error',
        description:
            'Invalid vehicle count data detected. Please check the vehicle records.',
      );
    }

    final percentage = (top.value / totalVehicles * 100).toStringAsFixed(1);

    return PdfInsight(
      title: 'Distribution Insight',
      description:
          '${top.key} has the highest vehicle population with '
          '${top.value} registered vehicles, accounting for '
          '$percentage% of the total registered vehicles.',
    );
  }
}
