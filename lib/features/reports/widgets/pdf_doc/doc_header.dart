import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class DocHeader extends pw.StatelessWidget {
  final String republicText;
  final String universityText;
  final String taglineText;
  final String campusText;
  final String registrationText;
  final String institutionLog;
  final String isoLogo;
  final String department;

  DocHeader({
    required this.republicText,
    required this.universityText,
    required this.taglineText,
    required this.campusText,
    required this.registrationText,
    required this.institutionLog,
    required this.isoLogo,
    required this.department,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      children: [
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(horizontal: 53),
          decoration: pw.BoxDecoration(color: PdfColors.white),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              // Top row: Left logo/seal, Center text, Right certifications
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  // Left: University Seal/Logo (placeholder; replace with pw.Image)
                  pw.Column(
                    children: [
                      pw.SizedBox(height: 16),
                      pw.Image(
                        height: 70,
                        width: 70,
                        pw.MemoryImage(
                          File(
                            'assets/images/$institutionLog.png',
                          ).readAsBytesSync(),
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        registrationText,
                        style: pw.TextStyle(
                          fontSize: 7,
                          color: PdfColors.black,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ],
                  ),

                  // Center: Main Titles
                  pw.Padding(
                    padding: pw.EdgeInsets.only(top: 25),
                    child: pw.Expanded(
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Text(
                            republicText,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.black,
                            ),
                          ),
                          pw.Text(
                            universityText,
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.black,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                          pw.Text(
                            taglineText,
                            style: pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.red,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                          pw.Text(
                            campusText,
                            style: pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.black,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                          pw.Text(
                            department,
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.black,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.only(top: 25),
                    child: pw.Image(
                      height: 80,
                      width: 80,
                      pw.MemoryImage(
                        File('assets/images/$isoLogo.jpg').readAsBytesSync(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Container(
          width: 794.0,
          height: 0.9,
          color: PdfColors.black,
        ), //bottom line
        pw.SizedBox(height: 3),
        pw.Container(
          width: 794.0,
          height: 1.7,
          decoration: pw.BoxDecoration(
            color: PdfColors.black,
            boxShadow: [
              pw.BoxShadow(
                color: PdfColors.black,
                spreadRadius: 1,
                blurRadius: 1,
              ),
            ],
          ),
        ), //bottom line
      ],
    );
  }
}
