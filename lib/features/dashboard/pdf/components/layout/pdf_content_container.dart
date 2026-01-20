import 'package:pdf/widgets.dart' as pw;

/// Applies padding ONLY to report content (not header/footer)
class PdfContentContainer extends pw.StatelessWidget {
  final pw.Widget child;

  PdfContentContainer({required this.child});

  @override
  pw.Widget build(pw.Context context) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: child,
    );
  }
}
