import 'package:pdf/widgets.dart' as pw;

class PdfContentScope extends pw.StatelessWidget {
  final pw.Widget child;

  PdfContentScope({required this.child});

  @override
  pw.Widget build(pw.Context context) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: child,
    );
  }
}
