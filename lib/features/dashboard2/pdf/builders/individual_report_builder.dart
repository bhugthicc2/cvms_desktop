import 'dart:typed_data';

import 'package:cvms_desktop/features/dashboard2/models/report/individual_vehicle_report_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../templates/default_pdf_page_template.dart';
import '../core/pdf_branding_config.dart';

// Sections
import '../sections/individual/individual_report_title_section.dart';
// (future)
// import '../sections/global_summary_section.dart';
// import '../sections/global_charts_section.dart';
// import '../sections/global_tables_section.dart';
// import '../sections/global_signatories_section.dart';

class IndividualReportBuilder {
  static Future<Uint8List> build({
    required IndividualVehicleReportModel report,
    required PdfBrandingConfig branding,
    PdfPageFormat pageFormat = PdfPageFormat.legal,
    double marginH = 40,
    double marginV = 5,
  }) async {
    final pdf = pw.Document();

    final template = DefaultPdfPageTemplate(
      branding: branding,
      pageFormat: pageFormat,
    );

    // Report sections (ORDER MATTERS)
    final sections = [
      IndividualReportTitleSection(),
      // GlobalSummarySection(),
      // GlobalChartsSection(),
      // GlobalTablesSection(),
    ];

    pdf.addPage(
      pw.MultiPage(
        pageTheme: template.theme,
        header: template.header,
        footer: template.footer,
        build: (context) {
          final widgets = <pw.Widget>[];
          for (final section in sections) {
            widgets.add(
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(
                  horizontal: marginH,
                  vertical: marginV,
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: section.build(report),
                ),
              ),
            );
          }

          return widgets;
        },
      ),
    );

    return Uint8List.fromList(await pdf.save());
  }
}
