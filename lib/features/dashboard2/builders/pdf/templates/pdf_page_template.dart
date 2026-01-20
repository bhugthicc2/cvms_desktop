import 'package:cvms_desktop/features/dashboard2/utils/pdf/pdf_branding.dart';
import 'package:pdf/widgets.dart' as pw;

abstract class PdfPageTemplate {
  pw.Page build({required pw.Widget child, required PdfBranding branding});
}
