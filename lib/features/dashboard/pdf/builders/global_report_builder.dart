import 'dart:typed_data';

import 'package:cvms_desktop/features/dashboard/pdf/components/layout/pdf_content_container.dart';
import 'package:cvms_desktop/features/dashboard/pdf/core/pdf_section.dart';
import 'package:cvms_desktop/features/dashboard/pdf/sections/global/global_summary_section.dart';
import 'package:cvms_desktop/features/dashboard/pdf/sections/global/vehicle_distribution_college_section.dart';
import 'package:cvms_desktop/features/dashboard/pdf/sections/global/year_level_breakdown_section.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../models/report/global_vehicle_report_model.dart';
import '../templates/default_pdf_page_template.dart';
import '../core/pdf_branding_config.dart';

// Sections
import '../sections/global/global_report_title_section.dart';
// (future)
// import '../sections/global_summary_section.dart';
// import '../sections/global_charts_section.dart';
// import '../sections/global_tables_section.dart';
// import '../sections/global_signatories_section.dart';

class GlobalReportBuilder {
  static Future<Uint8List> build({
    required GlobalVehicleReportModel report,
    required PdfBrandingConfig branding,
    PdfPageFormat pageFormat = PdfPageFormat.legal,
  }) async {
    final pdf = pw.Document();

    final template = DefaultPdfPageTemplate(
      branding: branding,
      pageFormat: pageFormat,
    );

    // Report sections (ORDER MATTERS)
    final List<PdfSection<GlobalVehicleReportModel>> sections = [
      GlobalReportTitleSection(),
      GlobalSummarySection(),
      VehicleDistributionCollegeSection(),
      YearLevelBreakdownSection(), //step 7 for adding a report entry
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
              PdfContentContainer(
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
