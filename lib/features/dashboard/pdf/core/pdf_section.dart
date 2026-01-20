import 'package:pdf/widgets.dart' as pw;

/// Base contract for all PDF content sections
abstract class PdfSection<T> {
  List<pw.Widget> build(T report);
}
