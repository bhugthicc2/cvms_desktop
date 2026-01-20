import 'package:pdf/widgets.dart' as pw;

import '../../core/pdf_insight.dart';

class PdfInsightBox extends pw.StatelessWidget {
  final PdfInsight insight;

  PdfInsightBox(this.insight);

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          insight.title,
          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          insight.description,
          style: pw.TextStyle(
            fontSize: 10,
            fontStyle: pw.FontStyle.italic,
            fontWeight: pw.FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
