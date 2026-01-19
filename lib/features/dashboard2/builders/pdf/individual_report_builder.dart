import 'dart:typed_data';

import 'package:cvms_desktop/features/dashboard/widgets/pdf_doc/texts/pdf_report_title.dart';
import 'package:cvms_desktop/features/dashboard/widgets/pdf_doc/texts/pdf_section_footer_text.dart';
import 'package:cvms_desktop/features/dashboard/widgets/pdf_doc/texts/pdf_section_text.dart';
import 'package:cvms_desktop/features/dashboard/widgets/pdf_doc/texts/pdf_subtitle_text.dart';
import 'package:cvms_desktop/features/dashboard/widgets/pdf_doc/tables/pdf_table.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/components/pdf_doc/letter_head/doc_signatory.dart';
import 'package:cvms_desktop/features/dashboard2/widgets/components/pdf_doc/templates/pdf_page_template.dart';
import 'package:pdf/widgets.dart' as pw;

class IndividualReportBuilder {
  static Future<Uint8List> build(Map<String, dynamic>? globalData) async {
    final pdf = pw.Document();
    final template = const PdfPageTemplate();

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
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Section 1: Vehicle Summary Metrics
            PdfSectionText(
              title: '1. Vehicle Summary Metrics',
              subTitle:
                  "This section provides an overview of this specific vehicle's activity and compliance status during the reporting period.",
            ),
            pw.SizedBox(height: 5),
            PdfTable(
              headers: ['Metric', 'Value'],
              rows: [
                [
                  'Days Until MVP Expiration',
                  globalData?['daysUntilExpiration'] ?? '150 days',
                ],
                ['Active Violations', globalData?['activeViolations'] ?? '22'],
                [
                  'Total Recorded Violations',
                  globalData?['totalViolations'] ?? '230',
                ],
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
            // Section 2: Vehicle Identification
            PdfSectionText(
              title: '2. Vehicle Identification',
              subTitle:
                  "This section identifies the vehicle and its registered owner.",
            ),
            pw.SizedBox(height: 5),
            PdfTable(
              headers: ['Field', 'Details'],
              rows: [
                ['Owner Name', globalData?['ownerName'] ?? 'Jesie P. Gapol'],
                ['Vehicle Model', globalData?['vehicleModel'] ?? 'XRM'],
                ['Vehicle Type', globalData?['vehicleType'] ?? 'Four-Wheeled'],
                ['Vehicle Color', globalData?['vehicleColor'] ?? 'Red'],
                ['Plate Number', globalData?['plateNumber'] ?? 'ABC-1234'],
              ],
              columnWidths: {
                0: pw.FlexColumnWidth(2),
                1: pw.FlexColumnWidth(2),
              },
            ),
            pw.SizedBox(height: 20),
            // Section 3: Legal and Registration Details
            PdfSectionText(
              title: '3. Legal and Registration Details',
              subTitle:
                  "These details confirm the vehicle's registration and authorization to operate within the campus.",
            ),
            pw.SizedBox(height: 5),
            PdfTable(
              headers: ['Field', 'Value'],
              rows: [
                ['License Number', globalData?['licenseNumber'] ?? '0890775'],
                [
                  'Official Receipt (OR) Number',
                  globalData?['orNumber'] ?? 'OR-5638',
                ],
                [
                  'Certificate of Registration (CR) Number',
                  globalData?['crNumber'] ?? 'CR-5779',
                ],
              ],
              columnWidths: {
                0: pw.FlexColumnWidth(2),
                1: pw.FlexColumnWidth(2),
              },
            ),
            pw.SizedBox(height: 20),
            // Section 4: Motor Vehicle Pass (MVP) Status
            PdfSectionText(
              title: '4. Motor Vehicle Pass (MVP) Status',
              hasSubtitle: false,
            ),
            pw.SizedBox(height: 5),
            PdfTable(
              headers: ['Field', 'Value'],
              rows: [
                ['MVP Validity Status', globalData?['mvpStatus'] ?? 'Valid'],
                [
                  'Date Registered',
                  globalData?['dateRegistered'] ?? 'January 5, 2025',
                ],
                [
                  'Expiration Date',
                  globalData?['expirationDate'] ?? 'December 2, 2026',
                ],
              ],
              columnWidths: {
                0: pw.FlexColumnWidth(2),
                1: pw.FlexColumnWidth(2),
              },
            ),
            PdfSectionFooterText(
              footerTitle: 'Remarks: ',
              footerSubTitle:
                  "The vehicle's Motor Vehicle Pass (MVP) is valid and active throughout the reporting period.",
            ),
            pw.SizedBox(height: 20),
          ],
        ),
      ],
    );
    pdf.addPage(template.build(child: page1Content));

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
        PdfTable(
          headers: ['Violation Type', 'Number of Violations', 'Percentage'],
          rows: [
            ['Horn', globalData?['hornViolations'] ?? '200', '34.7%'],
            ['No Helmet', globalData?['noHelmetViolations'] ?? '150', '26.0%'],
            [
              'No Driver\'s License',
              globalData?['noDriverLicenseViolations'] ?? '100',
              '17.3%',
            ],
            [
              'Overloading',
              globalData?['overloadingViolations'] ?? '80',
              '13.9%',
            ],
            [
              'No Reflectors',
              globalData?['noReflectorsViolations'] ?? '43',
              '7.5%',
            ],
          ],
          columnWidths: {
            0: pw.FlexColumnWidth(2),
            1: pw.FlexColumnWidth(1.5),
            2: pw.FlexColumnWidth(1),
          },
        ),
        pw.SizedBox(height: 20),
        PdfSectionFooterText(
          footerTitle: 'Analysis: ',
          footerSubTitle:
              "Horn-related violations account for the highest proportion of total violations for this vehicle, indicating a recurring behavioral concern that may require targeted enforcement or awareness measures for this specific driver.",
        ),
        pw.SizedBox(height: 20),
        // Section 6: Vehicle Activity Summary
        PdfSectionText(
          title: '6. Vehicle Activity Summary (Last 7 Days)',
          subTitle:
              "This section shows the number of recorded entries and exits for this specific vehicle during the reporting period.",
        ),
        pw.SizedBox(height: 5),
        PdfSubtitleText(label: 'Date Range', value: 'January 1-7, 2026'),
        pw.SizedBox(height: 5),
        PdfTable(
          headers: ['Day', 'Number of Logs'],
          rows: [
            ['January 1', globalData?['jan1Logs'] ?? '120'],
            ['January 2', globalData?['jan2Logs'] ?? '50'],
            ['January 3', globalData?['jan3Logs'] ?? '68'],
            ['January 4', globalData?['jan4Logs'] ?? '90'],
            ['January 5', globalData?['jan5Logs'] ?? '200'],
            ['January 6', globalData?['jan6Logs'] ?? '80'],
            ['January 7', globalData?['jan7Logs'] ?? '136'],
          ],
          columnWidths: {0: pw.FlexColumnWidth(2), 1: pw.FlexColumnWidth(1)},
        ),
        pw.SizedBox(height: 5),
        PdfSectionFooterText(
          footerTitle: 'Observation: ',
          footerSubTitle:
              "This vehicle's activity peaked on January 5, 2026, indicating increased usage on that day. This pattern may correlate with the driver's schedule or specific campus activities.",
        ),
        pw.SizedBox(height: 20),
        // Section 7: Recent Violation Records
        PdfSectionText(
          title: '7. Recent Violation Records',
          subTitle:
              "This table lists the most recent and relevant violation records for the vehicle. (Only summarized records are shown for clarity.)",
        ),
        pw.SizedBox(height: 5),
        PdfTable(
          headers: [
            'Violation ID',
            'Date',
            'Violation Type',
            'Reported By',
            'Status',
          ],
          rows: [
            ['V001', 'Jan 11, 2025', 'Over Speeding', 'John Doe', 'Pending'],
            ['V002', 'Jan 12, 2025', 'No Parking', 'Jessa Pagat', 'Resolved'],
            [
              'V003',
              'Jan 25, 2025',
              'Invalid License',
              'Jesie Gapol',
              'Pending',
            ],
            [
              'V004',
              'Feb 4, 2025',
              'No Helmet',
              'Jelly Mae Panlimutan',
              'Resolved',
            ],
            [
              'V005',
              'Feb 10, 2025',
              'Wrong Overtaking',
              'Joven Ondog',
              'In Progress',
            ],
            [
              'V006',
              'May 3, 2025',
              'Traffic Signal Violation',
              'Carl Pusoy',
              'Resolved',
            ],
            [
              'V007',
              'Jan 1, 2026',
              'Overloading',
              'Camille Prats',
              'In Progress',
            ],
          ],
          columnWidths: {
            0: pw.FlexColumnWidth(1),
            1: pw.FlexColumnWidth(1.5),
            2: pw.FlexColumnWidth(2),
            3: pw.FlexColumnWidth(2),
            4: pw.FlexColumnWidth(1.5),
          },
        ),
        pw.SizedBox(height: 20),
        PdfSectionFooterText(
          footerTitle: 'Note: ',
          footerSubTitle:
              "Complete violation records for this vehicle are available within the system.",
        ),
      ],
    );
    pdf.addPage(template.build(child: page2Content));

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
    pdf.addPage(template.build(child: page3Content));

    return Uint8List.fromList(await pdf.save());
  }
}
