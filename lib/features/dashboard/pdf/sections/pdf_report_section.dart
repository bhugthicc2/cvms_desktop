import 'package:pdf/widgets.dart' as pw;

abstract class PdfReportSection<T> {
  List<pw.Widget> build(T data);
}
