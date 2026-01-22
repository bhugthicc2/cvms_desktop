import 'dart:typed_data';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class PdfPrintService {
  Future<void> printPdf({
    required Uint8List pdfBytes,
    PdfPageFormat? pageFormat,
  }) async {
    await Printing.layoutPdf(
      onLayout: (_) async => pdfBytes,
      format: pageFormat ?? PdfPageFormat.a4,
      name: 'CVMS Report',
    );
  }
}
