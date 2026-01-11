import 'dart:typed_data';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/doc_footer.dart';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/doc_header.dart';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/doc_signatory.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdfx/pdfx.dart' as pdfx;

class PdfPreviewerContent extends StatefulWidget {
  const PdfPreviewerContent({super.key});

  @override
  State<PdfPreviewerContent> createState() => _PdfPreviewerContentState();
}

class _PdfPreviewerContentState extends State<PdfPreviewerContent> {
  Uint8List? _pdfBytes;
  bool _isLoading = true;
  late pdfx.PdfController _pdfController;
  double bodyFontSize = 11;

  @override
  void initState() {
    super.initState();
    _generatePdfWithLetterHead();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  Future<void> _generatePdfWithLetterHead() async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageTheme: pw.PageTheme(
            pageFormat: PdfPageFormat.legal,
            margin: const pw.EdgeInsets.all(0),
          ),
          build:
              (pw.Context context) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  DocHeader(
                    department: 'CDRRMS Unit',
                    republicText: 'REPUBLIC OF THE PHILIPPINES',
                    universityText: 'JOSE RIZAL MEMORIAL STATE UNIVERSITY',
                    taglineText:
                        'The Premier University in Zamboanga del Norte',
                    campusText:
                        'Katipunan Campus, Katipunan, Zamboanga del Norte',
                    registrationText: 'Registration No. 621082',
                    institutionLog: 'jrmsu-logo',
                    isoLogo: 'iso',
                  ), //header

                  pw.Expanded(
                    child: pw.Container(
                      width: 794.0, //full page width
                      child: pw.Padding(
                        padding: pw.EdgeInsets.symmetric(
                          horizontal: 53,
                          vertical: 10,
                        ), //content margin
                        //main content --start--
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisSize: pw.MainAxisSize.min,
                          children: [
                            pw.Text(
                              'Vehicle Report',
                              style: pw.TextStyle(
                                lineSpacing: 1.0,
                                fontSize: bodyFontSize,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ), //title
                            //main content here....

                            //main content here....
                          ],
                        ),
                        //main content --end--
                      ),
                    ),
                  ),
                  // --signatory--only show the signatory at the very last page of the document
                  DocSignatory(
                    //preparer
                    preparer: 'Joven Ondog',
                    preparerDesignation: 'CDRRMSU office in-charge',

                    //approve
                    approver: 'Leonel Hidalgo, Ph. D.',
                    approverDesignation: 'CDRRSMU Head',
                  ),

                  // --footer--
                  DocFooter(
                    isoCertifiedLogo: 'iso_certified_logo',
                    aacupLogo: 'aaccup_logo',
                    homeText:
                        'Barangay Dos, Katipunan, Zamboanga del Norte Philippines',
                    email: 'cdrrsmukatipunan@jrmsu.edu.ph',
                    phone: '+639123456789',
                    homeIcon: 'home_icon',
                    mailIcon: 'mail_icon',
                    phoneIcon: 'call_icon',
                  ), //footer
                ],
              ),
        ),
      );

      final bytes = await pdf.save();
      setState(() {
        _pdfBytes = Uint8List.fromList(bytes);
        _isLoading = false;
      });

      // Initialize controller after bytes ready
      _pdfController = pdfx.PdfController(
        document: pdfx.PdfDocument.openData(_pdfBytes!),
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      // error
      if (mounted) {
        CustomSnackBar.show(
          context: context,
          message: 'Error generating PDF: $error',
          type: SnackBarType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _pdfBytes == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return pdfx.PdfView(
      controller: _pdfController,
      scrollDirection: Axis.vertical,
      backgroundDecoration: BoxDecoration(color: AppColors.greySurface),
      builders: pdfx.PdfViewBuilders<pdfx.DefaultBuilderOptions>(
        options: const pdfx.DefaultBuilderOptions(
          loaderSwitchDuration: Duration(seconds: 1),
        ),
        documentLoaderBuilder:
            (_) => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
        pageLoaderBuilder:
            (_) => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
        errorBuilder: (_, error) => Center(child: Text(error.toString())),
      ),
    );
  }
}
