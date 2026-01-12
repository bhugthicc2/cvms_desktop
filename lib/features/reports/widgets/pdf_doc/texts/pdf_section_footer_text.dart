import 'package:pdf/widgets.dart' as pw;

class PdfSectionFooterText extends pw.StatelessWidget {
  PdfSectionFooterText({
    required this.footerTitle,
    required this.footerSubTitle,
  });

  final String footerTitle;
  final String footerSubTitle;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '$footerTitle ',

          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(
          footerSubTitle,
          style: pw.TextStyle(fontSize: 11, fontStyle: pw.FontStyle.italic),
        ),
      ],
    );
  }
}
