import 'dart:typed_data';

import 'package:cvms_desktop/features/reports/widgets/pdf_doc/texts/pdf_report_title.dart';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/texts/pdf_section_footer_text.dart';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/texts/pdf_section_text.dart';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/texts/pdf_subtitle_text.dart';
import 'package:cvms_desktop/features/reports/widgets/pdf_doc/tables/pdf_table.dart';
import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';
import 'package:cvms_desktop/features/reports/controllers/global_report_remarks_builder.dart';
import 'package:cvms_desktop/features/reports/models/fleet_summary.dart';
import 'package:pdf/widgets.dart' as pw;
import '../widgets/pdf_doc/letter_head/doc_signatory.dart';
import '../widgets/pdf_doc/templates/pdf_page_template.dart';

class GlobalChartReportBuilder {
  static Future<Uint8List> build(Map<String, dynamic>? globalData) async {
    final pdf = pw.Document();
    final template = const PdfPageTemplate();

    final fleetSummary = globalData?['fleetSummary'] as FleetSummary?;
    final vehicleDistribution =
        globalData?['vehicleDistribution'] as List<ChartDataModel>?;
    final yearLevelBreakdown =
        globalData?['yearLevelBreakdown'] as List<ChartDataModel>?;
    final cityBreakdown = globalData?['cityBreakdown'] as List<ChartDataModel>?;
    final studentWithMostViolations =
        globalData?['studentWithMostViolations'] as List<ChartDataModel>?;
    final logsData =
        (globalData?['logsData'] as List<ChartDataModel>?) ?? const [];

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

    final vehicleDistRemarks = GlobalReportRemarksBuilder.topCategoryRemark(
      data: vehicleDistribution,
      fallback:
          'Vehicle distribution is not available for the selected period.',
    );
    final yearLevelRemarks = GlobalReportRemarksBuilder.topCategoryRemark(
      data: yearLevelBreakdown,
      fallback:
          'Year level breakdown is not available for the selected period.',
    );
    final cityRemarks = GlobalReportRemarksBuilder.topCategoryRemark(
      data: cityBreakdown,
      fallback:
          'City/municipality breakdown is not available for the selected period.',
    );
    final studentRemarks = GlobalReportRemarksBuilder.topCategoryRemark(
      data: studentWithMostViolations,
      fallback:
          'Student violation ranking is not available for the selected period.',
    );
    final logsRemarks = GlobalReportRemarksBuilder.busiestDayRemark(
      data: logsData,
      fallback:
          'Vehicle log trend data is not available for the selected period.',
    );
    final topViolationRemarks = GlobalReportRemarksBuilder.topViolationTypeRemark(
      fleetSummary: fleetSummary,
      fallback:
          'Violation type distribution is not available for the selected period.',
    );

    // Page 1: Fleet Summary and Distributions
    final page1Content = pw.Column(
      children: [
        PdfReportTitle(titleTxt: 'Global Vehicle Monitoring Report w/ Charts'),
        pw.SizedBox(height: 10),
        PdfSubtitleText(
          label: 'Reporting period',
          value: 'January 1 - 7, 2026 (STATIC)',
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
                [
                  'Total Violations',
                  (fleetSummary?.totalViolations ??
                          globalData?['totalViolations'] ??
                          '—')
                      .toString(),
                ],
                [
                  'Pending Violations',
                  (fleetSummary?.activeViolations ??
                          globalData?['activeViolations'] ??
                          '—')
                      .toString(),
                ],
                [
                  'Total Vehicles',
                  (fleetSummary?.totalVehicles ??
                          globalData?['totalVehicles'] ??
                          '—')
                      .toString(),
                ],
                [
                  'Total Vehicle Entries / Exits',
                  (fleetSummary?.totalEntriesExits ??
                          globalData?['totalEntriesExits'] ??
                          '—')
                      .toString(),
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
              footerSubTitle: vehicleDistRemarks,
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
              footerSubTitle: yearLevelRemarks,
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
          footerSubTitle: cityRemarks,
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
          footerSubTitle: logsRemarks,
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
          footerSubTitle: GlobalReportRemarksBuilder.topCategoryRemark(
            data: fleetSummary?.deptViolationData,
            fallback:
                'Violation distribution per college is not available for the selected period.',
          ),
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
          footerSubTitle: topViolationRemarks,
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
          footerSubTitle: logsRemarks,
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
          footerSubTitle: studentRemarks,
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

    // Page 4: Top Violations, Logs, and High-Violation Students
    final page4Content = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 10),

        DocSignatory(
          preparer: 'Joven Ondog',
          preparerDesignation: 'CDRRMSU Office In-Charge',
          approver: 'Leonel Hidalgo, Ph.D.',
          approverDesignation: 'CDRRMSU Head',
        ),
      ],
    );
    pdf.addPage(template.build(child: page4Content));
    return Uint8List.fromList(await pdf.save());
  }
}
