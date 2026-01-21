import 'package:pdf/widgets.dart' as pw;

import '../../../models/report/global_vehicle_report_model.dart';
import '../../../utils/city_formatter.dart';
import '../../core/pdf_section.dart';
import '../../components/sections/pdf_section_title.dart';
import '../../components/tables/pdf_table.dart';
import '../../components/sections/pdf_insight_box.dart';
import '../../core/pdf_insight.dart';

class TopCitiesSection implements PdfSection<GlobalVehicleReportModel> {
  final int limit;
  final CityFormatter _cityFormatter = CityFormatter();

  TopCitiesSection({this.limit = 5});

  @override
  List<pw.Widget> build(GlobalVehicleReportModel report) {
    if (report.vehiclesByCity.isEmpty) {
      return [];
    }

    final total = report.totalVehicles;

    final sorted =
        report.vehiclesByCity.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    final displayed = sorted.take(limit).toList();

    final rows =
        displayed.map((e) {
          final percent = total == 0 ? 0 : (e.value / total * 100);
          return [
            _cityFormatter.formatCity(e.key),
            e.value.toString(),
            '${percent.toStringAsFixed(1)}%',
          ];
        }).toList();

    return [
      PdfSectionTitle(
        title: '4. Top ${displayed.length} Cities / Municipalities',
        subTitle: 'Locations with the highest number of registered vehicles',
      ),

      pw.SizedBox(height: 10),

      PdfTable(
        headers: const ['City / Municipality', 'Vehicle Count', 'Percentage'],
        rows: rows,
        columnWidths: const {
          0: pw.FlexColumnWidth(3),
          1: pw.FlexColumnWidth(1),
          2: pw.FlexColumnWidth(1),
        },
      ),

      pw.SizedBox(height: 12),

      PdfInsightBox(_generateInsight(displayed, total)),

      pw.SizedBox(height: 24),
    ];
  }

  PdfInsight _generateInsight(List<MapEntry<String, int>> entries, int total) {
    if (entries.isEmpty || total == 0) {
      return PdfInsight(
        title: 'No Location Data',
        description:
            'No vehicle registration data by city or municipality is available.',
      );
    }

    final top = entries.first;
    final percent = (top.value / total * 100).toStringAsFixed(1);

    return PdfInsight(
      title: 'Geographic Concentration',
      description:
          '${_cityFormatter.formatCity(top.key)} recorded the highest number of registered vehicles '
          'with ${top.value} vehicles, representing $percent% '
          'of the total vehicle population.',
    );
  }
}
