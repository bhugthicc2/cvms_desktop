import 'package:pdf/widgets.dart' as pw;

class PdfSubtitleText extends pw.StatelessWidget {
  PdfSubtitleText({
    required this.label,
    required this.value,
    this.mainAxisAlignment = pw.MainAxisAlignment.center,
    this.crossAxisAlignment = pw.CrossAxisAlignment.center,
  });

  final String label;
  final String value;
  final pw.MainAxisAlignment mainAxisAlignment;
  final pw.CrossAxisAlignment crossAxisAlignment;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
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
