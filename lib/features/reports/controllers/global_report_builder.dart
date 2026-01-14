import 'dart:typed_data';

import 'package:cvms_desktop/features/reports/widgets/pdf_doc/texts/pdf_report_title.dart';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/texts/pdf_section_footer_text.dart';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/texts/pdf_section_text.dart';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/texts/pdf_subtitle_text.dart';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/tables/pdf_table.dart';
import 'package:pdf/widgets.dart' as pw;
import '../widgets/pdf_doc/letter_head/doc_signatory.dart';
import '../widgets/pdf_doc/templates/pdf_page_template.dart';

class GlobalReportBuilder {
  static Future<Uint8List> build(Map<String, dynamic>? globalData) async {
    final pdf = pw.Document();
    final template = const PdfPageTemplate();

    // Page 1: Fleet Summary and Distributions
    final page1Content = pw.Column(
      children: [
        PdfReportTitle(titleTxt: 'Global Vehicle Monitoring Report'),
        pw.SizedBox(height: 10),
        PdfSubtitleText(
          label: 'Reporting period',
          value: 'January 1 - 7, 2026',
        ),
        PdfSubtitleText(label: 'Generated On', value: 'January 11, 2026'),
        pw.SizedBox(height: 20),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Section 1: Fleet Summary Metrics
            PdfSectionText(
              title: '1. Fleet Summary Metrics',
              subTitle:
                  "This section provides an overview of the fleet's activity and compliance status during the reporting period.",
            ),
            pw.SizedBox(height: 5),
            PdfTable(
              headers: ['Metric', 'Value'],
              rows: [
                ['Total Violations', globalData?['totalViolations'] ?? '150'],
                ['Pending Violations', globalData?['activeViolations'] ?? '22'],
                ['Total Vehicles', globalData?['totalVehicles'] ?? '230'],
                [
                  'Total Vehicle Entries / Exits',
                  globalData?['totalEntriesExits'] ?? '540',
                ],
              ],
              columnWidths: {
                0: pw.FlexColumnWidth(2),
                1: pw.FlexColumnWidth(2),
              },
            ),
            pw.SizedBox(height: 20),
            // Section 2: Vehicle Distribution per College
            PdfSectionText(
              title: '2. Vehicle Distribution per College',
              subTitle:
                  "This section shows the distribution of vehicles across colleges.",
            ),
            pw.SizedBox(height: 5),
            PdfTable(
              headers: ['College', 'Number of Vehicles', 'Percentage'],
              rows: [
                [
                  'Laboratory High School',
                  globalData?['labHighSchoolVehicles'] ?? '15',
                  '15%',
                ],
                [
                  'College of Education',
                  globalData?['educationVehicles'] ?? '20',
                  '20%',
                ],
                [
                  'School of Engineering',
                  globalData?['engineeringVehicles'] ?? '25',
                  '25%',
                ],
                [
                  'College of Computing Studies',
                  globalData?['computingVehicles'] ?? '30',
                  '30%',
                ],
                [
                  'College of Business Administration',
                  globalData?['businessVehicles'] ?? '10',
                  '10%',
                ],
                [
                  'College of Agriculture & Forestry',
                  globalData?['agriForestryVehicles'] ?? '10',
                  '10%',
                ],
                ['School of Criminal Justice Education', '10', '10%'],
              ],
              columnWidths: {
                0: pw.FlexColumnWidth(2),
                1: pw.FlexColumnWidth(1),
                2: pw.FlexColumnWidth(1),
              },
            ),
            pw.SizedBox(height: 20),
            // Section 3: Year Level Breakdown
            PdfSectionText(
              title: '3. Year Level Breakdown',
              subTitle:
                  "This section shows the distribution of vehicles by year level.",
            ),
            pw.SizedBox(height: 5),
            PdfTable(
              headers: ['Year Level', 'Number of Vehicles', 'Percentage'],
              rows: [
                [
                  'Junior High School',
                  globalData?['juniorHighVehicles'] ?? '15',
                  '15%',
                ],
                ['First Year', globalData?['firstYearVehicles'] ?? '15', '15%'],
                [
                  'Second Year',
                  globalData?['secondYearVehicles'] ?? '20',
                  '20%',
                ],
                ['Third Year', globalData?['thirdYearVehicles'] ?? '25', '25%'],
                [
                  'Fourth Year',
                  globalData?['fourthYearVehicles'] ?? '30',
                  '30%',
                ],
              ],
              columnWidths: {
                0: pw.FlexColumnWidth(2),
                1: pw.FlexColumnWidth(1),
                2: pw.FlexColumnWidth(1),
              },
            ),
            pw.SizedBox(height: 20),
          ],
        ),
      ],
    );
    pdf.addPage(template.build(child: page1Content));

    // Page 2: Geographic and Log Distributions
    final page2Content = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 10),
        // Section 4: City/Municipality Breakdown
        PdfSectionText(
          title: '4. City/Municipality Breakdown',
          subTitle:
              "This section shows the distribution of vehicles by city/municipality.",
        ),
        pw.SizedBox(height: 5),
        PdfTable(
          headers: ['City/Municipality', 'Number of Vehicles', 'Percentage'],
          rows: [
            [globalData?['polancoVehicles'] ?? 'Polanco', '10', '10%'],
            [globalData?['katipunanVehicles'] ?? 'Katipunan', '9', '9%'],
            [globalData?['dipologVehicles'] ?? 'Dipolog City', '8', '8%'],
            [globalData?['sindanganVehicles'] ?? 'Sindangan', '7', '7%'],
            [globalData?['osmeñaVehicles'] ?? 'Sergio Osmeña', '6', '6%'],
          ],
          columnWidths: {
            0: pw.FlexColumnWidth(2),
            1: pw.FlexColumnWidth(1),
            2: pw.FlexColumnWidth(1),
          },
        ),
        pw.SizedBox(height: 20),
        PdfSectionFooterText(
          footerTitle: 'Remarks: ',
          footerSubTitle:
              "Polanco has the highest number of registered vehicles with 10 vehicles.",
        ),
        pw.SizedBox(height: 20),
        // Section 5: Vehicle Logs Distribution per College
        PdfSectionText(
          title: '5. Vehicle Logs Distribution per College',
          subTitle:
              "This section shows the distribution of vehicle logs across colleges.",
        ),
        pw.SizedBox(height: 5),
        PdfTable(
          headers: ['College/Department', 'Number of Logs', 'Percentage'],
          rows: [
            ['College of Business Administration', '16', '76%'],
            ['College of Computing Studies', '5', '24%'],
            ['College of Business Administration', '16', '76%'],
            ['College of Computing Studies', '5', '24%'],
            ['College of Business Administration', '16', '76%'],
            ['College of Computing Studies', '5', '24%'],
          ],
          columnWidths: {
            0: pw.FlexColumnWidth(2),
            1: pw.FlexColumnWidth(1),
            2: pw.FlexColumnWidth(1),
          },
        ),
        pw.SizedBox(height: 20),
        // Section 6: Violation Distribution per College
        PdfSectionText(
          title: '6. Violation Distribution per College',
          subTitle:
              "This section shows the distribution of violations across colleges.",
        ),
        pw.SizedBox(height: 5),
        PdfTable(
          headers: ['College/Department', 'Number of Violations', 'Percentage'],
          rows: [
            ['College of Business Administration', '16', '76%'],
            ['College of Computing Studies', '5', '24%'],
            ['College of Education', '5', '24%'],
            ['College of Agriculture and Forestry', '5', '24%'],
            ['College of Arts and Sciences', '5', '24%'],
          ],
          columnWidths: {
            0: pw.FlexColumnWidth(2),
            1: pw.FlexColumnWidth(1),
            2: pw.FlexColumnWidth(1),
          },
        ),
        pw.SizedBox(height: 10),
        PdfSectionFooterText(
          footerTitle: 'Remarks: ',
          footerSubTitle:
              "The College of Business Administration has the highest number of violations with 16 total violations.",
        ),
        pw.SizedBox(height: 20),
        PdfSectionFooterText(
          footerTitle: 'Fleet Report Disclaimer',
          footerSubTitle:
              "This fleet report is system-generated and intended for official documentation, monitoring, and record-keeping purposes. Any detailed or historical data not shown in this report may be accessed through the Vehicle Monitoring System.",
        ),
      ],
    );
    pdf.addPage(template.build(child: page2Content));

    // Page 3: Top Violations, Logs, and High-Violation Students
    final page3Content = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 10),
        // Section 7: Top 5 Violations by Type
        PdfSectionText(
          title: '7. Top 5 Violations by Type',
          subTitle:
              "This section shows the top 5 violations by type across the fleet.",
        ),
        pw.SizedBox(height: 5),
        PdfTable(
          headers: ['Violation Type', 'Number of Violations', 'Percentage'],
          rows: [
            [
              globalData?['topViolation1'] ?? 'Vehicle Modification',
              '10',
              '10%',
            ],
            [globalData?['topViolation2'] ?? 'Reckless Driving', '9', '9%'],
            [globalData?['topViolation3'] ?? 'Invalid MVP Sticker', '8', '8%'],
            [globalData?['topViolation4'] ?? 'Improper Parking', '7', '7%'],
            [globalData?['topViolation5'] ?? 'Other', '66', '66%'],
          ],
          columnWidths: {
            0: pw.FlexColumnWidth(2),
            1: pw.FlexColumnWidth(1),
            2: pw.FlexColumnWidth(1),
          },
        ),
        pw.SizedBox(height: 20),
        PdfSectionFooterText(
          footerTitle: 'Remarks: ',
          footerSubTitle:
              "Vehicle Modification is the most common violation type with 10 occurrences.",
        ),
        pw.SizedBox(height: 20),
        // Section 8: Vehicle Logs for the Last 7 Days
        PdfSectionText(
          title: '8. Vehicle Logs for the Last 7 Days',
          subTitle: "This section shows the vehicle logs for the last 7 days.",
        ),
        pw.SizedBox(height: 5),
        PdfTable(
          headers: ['Date', 'Number of Logs'],
          rows: [
            ['January 1, 2026', '16'],
            ['January 2, 2026', '5'],
            ['January 3, 2026', '12'],
            ['January 4, 2026', '8'],
            ['January 5, 2026', '20'],
            ['January 6, 2026', '10'],
            ['January 7, 2026', '14'],
          ],
          columnWidths: {0: pw.FlexColumnWidth(2), 1: pw.FlexColumnWidth(1)},
        ),
        pw.SizedBox(height: 10),
        PdfSectionFooterText(
          footerTitle: 'Remarks: ',
          footerSubTitle:
              "Vehicle activity peaked on January 5, 2026, with 20 logs, indicating higher campus traffic on that day.",
        ),
        pw.SizedBox(height: 20),
        // Section 9: Students with Most Violations
        PdfSectionText(
          title: '9. Students with Most Violations',
          subTitle:
              "This section identifies the students/owners with the highest number of violations.",
        ),
        pw.SizedBox(height: 5),
        PdfTable(
          headers: ['Student Name', 'Number of Violations', 'Percentage'],
          rows: [
            [globalData?['topViolator1'] ?? 'Jesie Gapol', '10', '10%'],
            [globalData?['topViolator2'] ?? 'Junjun Gapol', '9', '9%'],
            [globalData?['topViolator3'] ?? 'Jerry Gapol', '8', '8%'],
            [globalData?['topViolator4'] ?? 'Joshua Gapol', '7', '7%'],
            [globalData?['topViolator5'] ?? 'Yow Gapol', '6', '6%'],
          ],
          columnWidths: {
            0: pw.FlexColumnWidth(2),
            1: pw.FlexColumnWidth(1),
            2: pw.FlexColumnWidth(1),
          },
        ),
        PdfSectionFooterText(
          footerTitle: 'Remarks: ',
          footerSubTitle:
              "Jesie Gapol has the highest number of violations with 10 occurrences.",
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
    pdf.addPage(template.build(child: page3Content));

    return Uint8List.fromList(await pdf.save());
  }
}
