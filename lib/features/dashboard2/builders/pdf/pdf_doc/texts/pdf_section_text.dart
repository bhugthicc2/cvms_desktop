import 'package:pdf/widgets.dart' as pw;

class PdfSectionText extends pw.StatelessWidget {
  PdfSectionText({required this.title, this.subTitle, this.hasSubtitle = true});

  final String title;
  final String? subTitle;
  final bool hasSubtitle;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,

          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
        ),
        hasSubtitle
            ? pw.Text(
              subTitle!,
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.normal,
              ),
            )
            : pw.SizedBox.shrink(),
      ],
    );
  }
}
