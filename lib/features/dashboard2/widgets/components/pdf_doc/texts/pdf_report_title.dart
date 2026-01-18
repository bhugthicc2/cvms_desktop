import 'package:pdf/widgets.dart' as pw;

class PdfReportTitle extends pw.StatelessWidget {
  PdfReportTitle({required this.titleTxt});

  final String titleTxt;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Text(
      titleTxt,
      textAlign: pw.TextAlign.center,
      style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
    );
  }
}
