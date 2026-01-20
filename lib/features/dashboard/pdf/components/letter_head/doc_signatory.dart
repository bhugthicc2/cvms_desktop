import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class DocSignatory extends pw.StatelessWidget {
  //preparer
  final String preparer;
  final String preparerDesignation;

  //approve
  final String approver;
  final String approverDesignation;

  DocSignatory({
    //preparer
    required this.preparer,
    required this.preparerDesignation,

    //approve
    required this.approver,
    required this.approverDesignation,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        //prepared
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(height: 12),
            pw.Text(
              'Prepared by:',
              style: pw.TextStyle(fontSize: 12, color: PdfColors.black),
              textAlign: pw.TextAlign.start,
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.SizedBox(height: 20),
                pw.Text(
                  preparer,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 2),
                pw.Container(width: 130, height: 0.9, color: PdfColors.black),
                pw.SizedBox(height: 2),
                pw.Text(
                  preparerDesignation,
                  style: pw.TextStyle(fontSize: 12),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 12),
              ],
            ),
          ],
        ),
        //approved
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(height: 12),
            pw.Text(
              'Approved by:',
              style: pw.TextStyle(fontSize: 12, color: PdfColors.black),
              textAlign: pw.TextAlign.start,
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.SizedBox(height: 20),
                pw.Text(
                  approver,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 2),
                pw.Container(width: 130, height: 0.9, color: PdfColors.black),
                pw.SizedBox(height: 2),
                pw.Text(
                  approverDesignation,
                  style: pw.TextStyle(fontSize: 12),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 12),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
