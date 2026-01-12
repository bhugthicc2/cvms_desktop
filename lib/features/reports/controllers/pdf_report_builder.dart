import 'dart:typed_data';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/texts/pdf_report_title.dart';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/texts/pdf_section_footer_text.dart';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/texts/pdf_section_text.dart';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/texts/pdf_subtitle_text.dart';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/tables/pdf_table.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../widgets/pdf_doc/letter_head/doc_footer.dart';
import '../widgets/pdf_doc/letter_head/doc_header.dart';
import '../widgets/pdf_doc/letter_head/doc_signatory.dart';

class PdfReportBuilder {
  static Future<Uint8List> buildVehicleReport() async {
    final pdf = pw.Document();

    // Page 1: Header, Title, Summary Metrics, Vehicle Identification
    pdf.addPage(
      pw.Page(
        pageTheme: const pw.PageTheme(
          pageFormat: PdfPageFormat.legal,
          margin: pw.EdgeInsets.zero,
        ),
        build:
            (_) => pw.Column(
              children: [
                DocHeader(
                  department: 'CDRRMS Unit',
                  republicText: 'REPUBLIC OF THE PHILIPPINES',
                  universityText: 'JOSE RIZAL MEMORIAL STATE UNIVERSITY',
                  taglineText: 'The Premier University in Zamboanga del Norte',
                  campusText:
                      'Katipunan Campus, Katipunan, Zamboanga del Norte',
                  registrationText: 'Registration No. 621082',
                  institutionLog: 'jrmsu-logo',
                  isoLogo: 'iso',
                ),
                //main-content
                pw.Expanded(
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 53,
                      vertical: 10,
                    ),
                    child: pw.Column(
                      children: [
                        PdfReportTitle(
                          titleTxt: 'Vehicle Monitoring & Violation Report',
                        ),
                        pw.SizedBox(height: 10),
                        PdfSubtitleText(
                          label: 'Reporting period',
                          value: 'January 1 - 7, 2026',
                        ),
                        PdfSubtitleText(
                          label: 'Generated On',
                          value: 'January 11, 2026',
                        ),
                        pw.SizedBox(height: 20),
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              //section 1
                              PdfSectionText(
                                title: '1. Summary Metrics',
                                subTitle:
                                    "This section provides a high-level overview of the vehicle's activity and compliance status during the reporting period.",
                              ),
                              pw.SizedBox(height: 5),
                              PdfTable(
                                headers: ['Metric', 'Value'],
                                rows: [
                                  ['Days Until MVP Expiration', '150 days'],
                                  ['Active Violations', '22'],
                                  ['Total Recorded Violations', '230'],
                                  ['Total Vehicle Entries / Exits', '540'],
                                ],
                                columnWidths: {
                                  0: pw.FlexColumnWidth(2),
                                  1: pw.FlexColumnWidth(2),
                                },
                              ),
                              pw.SizedBox(height: 20),
                              //section 2
                              PdfSectionText(
                                title: '2. Vehicle Identification',
                                subTitle:
                                    "This section identifies the vehicle and its registered owner.",
                              ),
                              pw.SizedBox(height: 5),
                              PdfTable(
                                headers: ['Field', 'Details'],
                                rows: [
                                  ['Owner Name', 'Jesie P. Gapol'],
                                  ['Vehicle Model', 'XRM'],
                                  ['Vehicle Type', 'Four-Wheeled'],
                                  ['Vehicle Color', 'Red'],
                                  ['Plate Number', 'ABC-1234'],
                                ],
                                columnWidths: {
                                  0: pw.FlexColumnWidth(2),
                                  1: pw.FlexColumnWidth(2),
                                },
                              ),
                              pw.SizedBox(height: 20),
                              //section 3
                              PdfSectionText(
                                title: '3. Legal and Registration Details',
                                subTitle:
                                    "These details confirm the vehicle's registration and authorization to operate within the campus.",
                              ),
                              pw.SizedBox(height: 5),
                              PdfTable(
                                headers: ['Field', 'Value'],
                                rows: [
                                  ['License Number', '0890775'],
                                  ['Official Receipt (OR) Number', 'OR-5638'],
                                  [
                                    'Certificate of Registration (CR) Number',
                                    'CR-5779',
                                  ],
                                ],
                                columnWidths: {
                                  0: pw.FlexColumnWidth(2),
                                  1: pw.FlexColumnWidth(2),
                                },
                              ),
                              pw.SizedBox(height: 20),
                              //section 4
                              PdfSectionText(
                                title: '4. Motor Vehicle Pass (MVP) Status',
                                hasSubtitle: false,
                              ),
                              pw.SizedBox(height: 5),
                              PdfTable(
                                headers: ['Field', 'Value'],
                                rows: [
                                  ['MVP Validity Status', 'Valid'],
                                  ['Date Registered', 'January 5, 2025'],
                                  ['Expiration Date', 'December 2, 2026'],
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
                        ),
                      ],
                    ),
                  ),
                ),
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
                ),
              ],
            ),
      ),
    );

    // Page 2: Legal Details, MVP Status, Violation Summary
    pdf.addPage(
      pw.Page(
        pageTheme: const pw.PageTheme(
          pageFormat: PdfPageFormat.legal,
          margin: pw.EdgeInsets.zero,
        ),
        build:
            (_) => pw.Column(
              children: [
                DocHeader(
                  department: 'CDRRMS Unit',
                  republicText: 'REPUBLIC OF THE PHILIPPINES',
                  universityText: 'JOSE RIZAL MEMORIAL STATE UNIVERSITY',
                  taglineText: 'The Premier University in Zamboanga del Norte',
                  campusText:
                      'Katipunan Campus, Katipunan, Zamboanga del Norte',
                  registrationText: 'Registration No. 621082',
                  institutionLog: 'jrmsu-logo',
                  isoLogo: 'iso',
                ),
                pw.Expanded(
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 53,
                      vertical: 10,
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.SizedBox(height: 10),

                        //section 5
                        PdfSectionText(
                          title: '5. Violation Summary by Type',
                          subTitle:
                              "This section summarizes violations recorded for the vehicle based on classification.",
                        ),
                        pw.SizedBox(height: 5),
                        PdfTable(
                          headers: [
                            'Violation Type',
                            'Number of Violations',
                            'Percentage',
                          ],
                          rows: [
                            ['Horn', '200', '34.7%'],
                            ['Illegal Parking', '140', '24.3%'],
                            ['Speeding', '100', '17.1%'],
                            ['Muffler', '100', '15.9%'],
                            ['Over Speeding', '30', '5.2%'],
                            ['No License', '15', '2.6%'],
                          ],
                          columnWidths: {
                            0: pw.FlexColumnWidth(2),
                            1: pw.FlexColumnWidth(1.5),
                            2: pw.FlexColumnWidth(1),
                          },
                        ),
                        pw.SizedBox(height: 5),
                        PdfSectionFooterText(
                          footerTitle: 'Analysis: ',
                          footerSubTitle:
                              "Horn-related violations account for the highest proportion of total violations, indicating a recurring behavioral concern that may require stricter enforcement or awareness measures.",
                        ),

                        pw.SizedBox(height: 20),
                        //section 6
                        PdfSectionText(
                          title: '6. Vehicle Activity Summary (Last 7 Days)',
                          subTitle:
                              "This section shows the number of recorded vehicle entries and exits during the reporting period.",
                        ),
                        pw.SizedBox(height: 5),
                        PdfSubtitleText(
                          label: 'Date Range',
                          value: 'January 1-7, 2026',
                        ),
                        pw.SizedBox(height: 5),
                        PdfTable(
                          headers: ['Day', 'Number of Logs'],
                          rows: [
                            ['January 1', '120'],
                            ['January 2', '50'],
                            ['January 3', '68'],
                            ['January 4', '90'],
                            ['January 5', '200'],
                            ['January 6', '80'],
                            ['January 7', '136'],
                          ],
                          columnWidths: {
                            0: pw.FlexColumnWidth(2),
                            1: pw.FlexColumnWidth(1),
                          },
                        ),
                        pw.SizedBox(height: 5),
                        PdfSectionFooterText(
                          footerTitle: 'Observation: ',
                          footerSubTitle:
                              "Vehicle activity peaked on January 5, 2026, indicating increased campus traffic on that day.",
                        ),
                        pw.SizedBox(height: 20),

                        //section 7
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
                            [
                              'V001',
                              'Jan 11, 2025',
                              'Over Speeding',
                              'John Doe',
                              'Pending',
                            ],
                            [
                              'V002',
                              'Jan 12, 2025',
                              'No Parking',
                              'Jessa Pagat',
                              'Resolved',
                            ],
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
                              'Camelle Prats',
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

                        pw.SizedBox(height: 5),
                        PdfSectionFooterText(
                          footerTitle: 'Note: ',
                          footerSubTitle:
                              "Complete violation records are available within the system.",
                        ),
                      ],
                    ),
                  ),
                ),
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
                ),
              ],
            ),
      ),
    );
    // Page 3: Logs
    pdf.addPage(
      pw.Page(
        pageTheme: const pw.PageTheme(
          pageFormat: PdfPageFormat.legal,
          margin: pw.EdgeInsets.zero,
        ),
        build:
            (_) => pw.Column(
              children: [
                DocHeader(
                  department: 'CDRRMS Unit',
                  republicText: 'REPUBLIC OF THE PHILIPPINES',
                  universityText: 'JOSE RIZAL MEMORIAL STATE UNIVERSITY',
                  taglineText: 'The Premier University in Zamboanga del Norte',
                  campusText:
                      'Katipunan Campus, Katipunan, Zamboanga del Norte',
                  registrationText: 'Registration No. 621082',
                  institutionLog: 'jrmsu-logo',
                  isoLogo: 'iso',
                ),
                pw.Expanded(
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 53,
                      vertical: 10,
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.SizedBox(height: 10),

                        //section 8
                        PdfSectionText(
                          title: '8. Recent Vehicle Log Entries',
                          subTitle:
                              "This section presents most recent vehicle entry and exit records.",
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
                            [
                              'L005',
                              'Feb 9, 2026',
                              '8:30 AM',
                              '11:00 AM',
                              '60 mins',
                              'Active',
                            ],
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
                          footerTitle: 'Report Disclaimer',
                          footerSubTitle:
                              "This report is system-generated and intended for official documentation, monitoring, and record-keeping purposes. Any detailed or historical data not shown in this report may be accessed through Vehicle Monitoring System.",
                        ),
                        pw.SizedBox(height: 20),
                        DocSignatory(
                          preparer: 'Joven Ondog',
                          preparerDesignation: 'CDRRMSU Office In-Charge',
                          approver: 'Leonel Hidalgo, Ph.D.',
                          approverDesignation: 'CDRRMSU Head',
                        ),
                      ],
                    ),
                  ),
                ),
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
                ),
              ],
            ),
      ),
    );

    return Uint8List.fromList(await pdf.save());
  }
}
