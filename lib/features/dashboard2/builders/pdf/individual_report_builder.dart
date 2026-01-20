import 'dart:typed_data';

import 'package:cvms_desktop/features/dashboard/widgets/pdf_doc/texts/pdf_report_title.dart';
import 'package:cvms_desktop/features/dashboard/widgets/pdf_doc/texts/pdf_section_footer_text.dart';
import 'package:cvms_desktop/features/dashboard/widgets/pdf_doc/texts/pdf_section_text.dart';
import 'package:cvms_desktop/features/dashboard/widgets/pdf_doc/texts/pdf_subtitle_text.dart';
import 'package:cvms_desktop/features/dashboard/widgets/pdf_doc/tables/pdf_table.dart';
import 'package:cvms_desktop/features/dashboard2/models/report/individual_vehicle_report_model.dart';
import 'package:cvms_desktop/features/dashboard2/utils/pdf/pdf_branding.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/components/pdf_doc/letter_head/doc_signatory.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/components/pdf_doc/templates/default_pdf_page_template.dart';
import 'package:pdf/widgets.dart' as pw;

class IndividualReportBuilder {
  static Future<Uint8List> build(
    IndividualVehicleReportModel? globalData,
  ) async {
    final pdf = pw.Document();
    final DefaultPdfPageTemplate template = DefaultPdfPageTemplate();

    // Page 1: Vehicle Information and Summary
    final page1Content = pw.Column(
      children: [
        PdfReportTitle(titleTxt: 'Individual Vehicle Monitoring Report'),
        pw.SizedBox(height: 10),
        PdfSubtitleText(
          label: 'Reporting period',
          value: 'January 1 - 7, 2026',
        ),
        PdfSubtitleText(label: 'Generated On', value: 'January 11, 2026'),
        pw.SizedBox(height: 20),

        PdfSectionFooterText(
          footerTitle: 'Remarks: ',
          footerSubTitle:
              "The vehicle's Motor Vehicle Pass (MVP) is valid and active throughout the reporting period.",
        ),
        pw.SizedBox(height: 20),
      ],
    );
    pdf.addPage(
      template.build(
        child: page1Content,
        branding: PdfBranding(
          title: 'Individual Vehicle Monitoring Report',
          department: 'Department',
        ),
      ),
    );

    // Page 2: Activity Summary, Recent Violations
    final page2Content = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 10),
        // Section 5: Violation Summary by Type
        PdfSectionText(
          title: '5. Violation Summary by Type',
          subTitle:
              "This section summarizes violations recorded for the vehicle based on classification.",
        ),
        pw.SizedBox(height: 5),
      ],
    );
    pdf.addPage(
      template.build(
        child: page2Content,
        branding: PdfBranding(
          title: 'Individual Vehicle Monitoring Report',
          department: 'Department',
        ),
      ),
    );

    // Page 3: Disclaimer, Signatory
    final page3Content = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 10),
        // Section 8: Recent Vehicle Log Entries
        PdfSectionText(
          title: '8. Recent Vehicle Log Entries',
          subTitle:
              "This section presents the most recent entry and exit records for this specific vehicle.",
        ),
        pw.SizedBox(height: 5),
        PdfTable(
          headers: [
            'Log ID',
            'Date',
            'Time In',
            'Time Out',
            'Duration',
            'Status',
          ],
          rows: [
            [
              'L001',
              'Jan 2, 2026',
              '8:11 AM',
              '5:00 PM',
              '120 mins',
              'Completed',
            ],
            [
              'L002',
              'Jan 3, 2026',
              '9:00 AM',
              '5:00 PM',
              '120 mins',
              'Completed',
            ],
            [
              'L003',
              'Jan 4, 2026',
              '8:00 AM',
              '5:00 PM',
              '120 mins',
              'Completed',
            ],
            [
              'L004',
              'Jan 5, 2026',
              '10:30 AM',
              '5:00 PM',
              '120 mins',
              'Completed',
            ],
            ['L005', 'Feb 9, 2026', '8:30 AM', '11:00 AM', '60 mins', 'Active'],
            [
              'L006',
              'Feb 10, 2026',
              '8:00 AM',
              '12:00 PM',
              '60 mins',
              'Completed',
            ],
            [
              'L007',
              'Mar 1, 2026',
              '9:00 AM',
              '12:30 PM',
              '60 mins',
              'Completed',
            ],
          ],
          columnWidths: {
            0: pw.FlexColumnWidth(1),
            1: pw.FlexColumnWidth(1.5),
            2: pw.FlexColumnWidth(1),
            3: pw.FlexColumnWidth(1),
            4: pw.FlexColumnWidth(1),
            5: pw.FlexColumnWidth(1.5),
          },
        ),
        pw.SizedBox(height: 10),
        PdfSectionFooterText(
          footerTitle: 'Vehicle Report Disclaimer',
          footerSubTitle:
              "This vehicle report is system-generated and intended for official documentation, monitoring, and record-keeping purposes. Any detailed or historical data not shown in this report may be accessed through the Vehicle Monitoring System.",
        ),
        pw.SizedBox(height: 20),
        DocSignatory(
          preparer: 'Joven Ondog',
          preparerDesignation: 'CDRRMSU Office In-Charge',
          approver: 'Leonel Hidalgo, Ph.D.',
          approverDesignation: 'CDRRMSU Head',
        ),
      ],
    );
    pdf.addPage(
      template.build(
        child: page3Content,
        branding: PdfBranding(
          title: 'Individual Vehicle Monitoring Report',
          department: 'Department',
        ),
      ),
    );

    return Uint8List.fromList(await pdf.save());
  }
}
