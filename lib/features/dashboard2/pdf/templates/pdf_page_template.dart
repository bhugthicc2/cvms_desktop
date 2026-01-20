import 'package:pdf/widgets.dart' as pw;

abstract class PdfPageTemplate {
  pw.PageTheme get theme;

  pw.Widget header(pw.Context context);

  pw.Widget footer(pw.Context context);
}
