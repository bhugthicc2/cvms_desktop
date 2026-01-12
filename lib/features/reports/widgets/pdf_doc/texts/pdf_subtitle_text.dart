import 'package:pdf/widgets.dart' as pw;

class PdfSubtitleText extends pw.StatelessWidget {
  PdfSubtitleText({required this.label, required this.value});

  final String label;
  final String value;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Row(
      children: [
        pw.Text(
          '$label ',

          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(value, style: pw.TextStyle(fontSize: 11)),
      ],
    );
  }
}
