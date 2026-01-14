import 'dart:typed_data';

import 'package:cvms_desktop/features/reports/widgets/pdf_doc/texts/pdf_report_title.dart';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/texts/pdf_section_footer_text.dart';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/texts/pdf_section_text.dart';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/texts/pdf_subtitle_text.dart';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/tables/pdf_table.dart';
import 'package:pdf/widgets.dart' as pw;
import '../widgets/pdf_doc/letter_head/doc_signatory.dart';
import '../widgets/pdf_doc/templates/pdf_page_template.dart';

class GlobalChartReportBuilder {
  static Future<Uint8List> build(Map<String, dynamic>? globalData) async {
    final pdf = pw.Document();
    final template = const PdfPageTemplate();

    final vehicleDistributionChartBytes =
        globalData?['vehicleDistributionChartBytes'] as Uint8List?;
    final yearLevelBreakdownChartBytes =
        globalData?['yearLevelBreakdownChartBytes'] as Uint8List?;
    final studentwithMostViolationChartBytes =
        globalData?['studentwithMostViolationChartBytes'] as Uint8List?;
    final vehicleLogsDistributionChartBytes =
        globalData?['vehicleLogsDistributionChartBytes'] as Uint8List?;
    final top5ViolationByTypeChartBytes =
        globalData?['top5ViolationByTypeChartBytes'] as Uint8List?;
    final cityBreakdownChartBytes =
        globalData?['cityBreakdownChartBytes'] as Uint8List?;
    final violationDistributionPerCollegeChartBytes =
        globalData?['violationDistributionPerCollegeChartBytes'] as Uint8List?;
    final fleetLogsChartBytes =
        globalData?['fleetLogsChartBytes'] as Uint8List?;

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

            if (vehicleDistributionChartBytes != null) ...[
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Image(
                  pw.MemoryImage(vehicleDistributionChartBytes),
                  height: 220,
                  fit: pw.BoxFit.contain,
                ),
              ),
            ],
            pw.SizedBox(height: 10),
            PdfSectionFooterText(
              footerTitle: 'Remarks: ',
              footerSubTitle:
                  "Vehicle activity peaked on January 5, 2026, with 20 logs, indicating higher campus traffic on that day.",
            ),
            pw.SizedBox(height: 20),
            // Section 3: Year Level Breakdown
            PdfSectionText(
              title: '3. Year Level Breakdown',
              subTitle:
                  "This section shows the distribution of vehicles by year level.",
            ),
            pw.SizedBox(height: 5),
            if (yearLevelBreakdownChartBytes != null) ...[
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Image(
                  pw.MemoryImage(yearLevelBreakdownChartBytes),
                  height: 220,
                  fit: pw.BoxFit.contain,
                ),
              ),
            ],
            pw.SizedBox(height: 10),
            PdfSectionFooterText(
              footerTitle: 'Remarks: ',
              footerSubTitle:
                  "Vehicle activity peaked on January 5, 2026, with 20 logs, indicating higher campus traffic on that day.",
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
        if (cityBreakdownChartBytes != null) ...[
          pw.SizedBox(height: 10),
          pw.Center(
            child: pw.Image(
              pw.MemoryImage(cityBreakdownChartBytes),
              height: 220,
              fit: pw.BoxFit.contain,
            ),
          ),
        ],

        PdfSectionFooterText(
          footerTitle: 'Remarks: ',
          footerSubTitle:
              "Polanco has the highest number of registered vehicles with 10 vehicles.",
        ),
        pw.SizedBox(height: 10),
        // Section 5: Vehicle Logs Distribution per College
        PdfSectionText(
          title: '5. Vehicle Logs Distribution per College',
          subTitle:
              "This section shows the distribution of vehicle logs across colleges.",
        ),
        pw.SizedBox(height: 5),
        if (vehicleLogsDistributionChartBytes != null) ...[
          pw.SizedBox(height: 10),
          pw.Center(
            child: pw.Image(
              pw.MemoryImage(vehicleLogsDistributionChartBytes),
              height: 220,
              fit: pw.BoxFit.contain,
            ),
          ),
        ],

        PdfSectionFooterText(
          footerTitle: 'Remarks: ',
          footerSubTitle:
              "Vehicle activity peaked on January 5, 2026, with 20 logs, indicating higher campus traffic on that day.",
        ),
        pw.SizedBox(height: 10),
        // Section 6: Violation Distribution per College
        PdfSectionText(
          title: '6. Violation Distribution per College',
          subTitle:
              "This section shows the distribution of violations across colleges.",
        ),
        pw.SizedBox(height: 5),
        if (violationDistributionPerCollegeChartBytes != null) ...[
          pw.SizedBox(height: 10),
          pw.Center(
            child: pw.Image(
              pw.MemoryImage(violationDistributionPerCollegeChartBytes),
              height: 220,
              fit: pw.BoxFit.contain,
            ),
          ),
        ],
        pw.SizedBox(height: 10),

        PdfSectionFooterText(
          footerTitle: 'Remarks',
          footerSubTitle: "The LHS got all the entry for violations.",
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
        if (top5ViolationByTypeChartBytes != null) ...[
          pw.SizedBox(height: 10),
          pw.Center(
            child: pw.Image(
              pw.MemoryImage(top5ViolationByTypeChartBytes),
              height: 220,
              fit: pw.BoxFit.contain,
            ),
          ),
        ],
        pw.SizedBox(height: 10),

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
        if (fleetLogsChartBytes != null) ...[
          pw.SizedBox(height: 10),
          pw.Center(
            child: pw.Image(
              pw.MemoryImage(fleetLogsChartBytes),
              height: 220,
              fit: pw.BoxFit.contain,
            ),
          ),
        ],

        PdfSectionFooterText(
          footerTitle: 'Remarks: ',
          footerSubTitle:
              "Vehicle Modification is the most common violation type with 10 occurrences.",
        ),
        pw.SizedBox(height: 20),
        // Section 9: Students with Most Violations
        PdfSectionText(
          title: '9. Students with Most Violations',
          subTitle:
              "This section identifies the students/owners with the highest number of violations.",
        ),
        pw.SizedBox(height: 5),
        if (studentwithMostViolationChartBytes != null) ...[
          pw.SizedBox(height: 10),
          pw.Center(
            child: pw.Image(
              pw.MemoryImage(studentwithMostViolationChartBytes),
              height: 220,
              fit: pw.BoxFit.contain,
            ),
          ),
        ],

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
