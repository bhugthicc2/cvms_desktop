import 'package:cvms_desktop/features/dashboard/models/dashboard/chart_data_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfHorizontalBarChart extends pw.StatelessWidget {
  final List<ChartDataModel> data;
  final double maxBarWidth;
  final double barHeight;

  PdfHorizontalBarChart({
    required this.data,
    this.maxBarWidth = 220,
    this.barHeight = 10,
  });

  @override
  pw.Widget build(pw.Context context) {
    if (data.isEmpty) {
      return pw.SizedBox();
    }

    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children:
          data.map((e) {
            final width =
                maxValue == 0 ? 0 : (e.value / maxValue) * maxBarWidth;

            return pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 6),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  // Label
                  pw.SizedBox(
                    width: 110,
                    child: pw.Text(
                      e.category,
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ),

                  pw.SizedBox(width: 6),

                  // Bar
                  pw.Container(
                    width: width.toDouble(),
                    height: barHeight,
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blueGrey700,
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                  ),

                  pw.SizedBox(width: 8),

                  // Value
                  pw.Text(
                    e.value.toInt().toString(),
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}

// usage
//   PdfHorizontalBarChart(
//         data: report.violationsByType,
//       ),
