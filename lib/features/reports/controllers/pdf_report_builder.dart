import 'dart:typed_data';

import 'package:cvms_desktop/features/reports/widgets/pdf_doc/texts/pdf_report_title.dart';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/texts/pdf_section_footer_text.dart';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/texts/pdf_section_text.dart';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/texts/pdf_subtitle_text.dart';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/tables/pdf_table.dart';
import 'package:pdf/widgets.dart' as pw;
import '../widgets/pdf_doc/letter_head/doc_signatory.dart';
import '../widgets/pdf_doc/templates/pdf_page_template.dart';

class PdfReportBuilder {
  static Future<Uint8List> buildVehicleReport({
    bool isGlobal = true,
    bool isChart = true,
    Map<String, dynamic>? globalData,
    Map<String, dynamic>? individualData,
  }) async {
    if (isGlobal && !isChart) {
      return await buildGlobalReport(globalData);
    }
    if (isGlobal && isChart) {
      return await buildGlobalChartReport(globalData);
    } else {
      return await buildIndividualVehicleReport(individualData);
    }
  }

  // -----------------------------------INDIVIDUAL---------------------------------------------

  static Future<Uint8List> buildIndividualVehicleReport(
    Map<String, dynamic>? globalData,
  ) async {
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

  // ------------------------------------GLOBAL------------------------------------------------

  static Future<Uint8List> buildGlobalReport(
    Map<String, dynamic>? globalData,
  ) async {
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

  // -------------------------------------GLOBAL W/ CHART----------------------------------

  static Future<Uint8List> buildGlobalChartReport(
    Map<String, dynamic>? globalData,
  ) async {
    final pdf = pw.Document();
    final template = const PdfPageTemplate();

    // Page 1: Fleet Summary and Distributions
    final page1Content = pw.Column(
      children: [
        PdfReportTitle(titleTxt: 'Global Vehicle Monitoring Report w/ Charts'),
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
            // Section 2: Vehicle Distribution per College - donut chart
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
