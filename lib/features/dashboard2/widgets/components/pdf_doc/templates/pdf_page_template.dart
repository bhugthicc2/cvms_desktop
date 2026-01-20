import 'package:pdf/widgets.dart' as pw;

abstract class PdfPageTemplate {
  pw.Page build({required pw.Widget child});
}
