import 'package:cvms_desktop/features/dashboard/models/dashboard/chart_data_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfBarChart extends pw.StatelessWidget {
  final List<ChartDataModel> data;
  final double maxBarHeight;

  PdfBarChart({required this.data, this.maxBarHeight = 120});

  @override
  pw.Widget build(pw.Context context) {
    if (data.isEmpty) {
      return pw.SizedBox();
    }

    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children:
          data.map((e) {
            final height =
                maxValue == 0 ? 0 : (e.value / maxValue) * maxBarHeight;

            return pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                  e.value.toInt().toString(),
                  style: const pw.TextStyle(fontSize: 8),
                ),
                pw.SizedBox(height: 4),
                pw.Container(
                  width: 14,
                  height: height.toInt().toDouble(),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blueGrey700,
                    borderRadius: pw.BorderRadius.circular(3),
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  e.category,
                  style: const pw.TextStyle(fontSize: 7),
                  maxLines: 2,
                  textAlign: pw.TextAlign.center,
                ),
              ],
            );
          }).toList(),
    );
  }
}

// usage sample
//  PdfBarChart(
//         data:
//             report.violationsByType.entries
//                 .map(
//                   (e) => ChartDataModel(
//                     category: e.key,
//                     value: e.value.toDouble(),
//                   ),
//                 )
//                 .toList(),
//       ),
