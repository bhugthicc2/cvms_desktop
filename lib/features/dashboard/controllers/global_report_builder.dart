import 'dart:typed_data';

import 'package:cvms_desktop/features/dashboard/data/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/widgets/pdf_doc/texts/pdf_report_title.dart';
import 'package:cvms_desktop/features/dashboard/widgets/pdf_doc/texts/pdf_section_footer_text.dart';
import 'package:cvms_desktop/features/dashboard/widgets/pdf_doc/texts/pdf_section_text.dart';
import 'package:cvms_desktop/features/dashboard/widgets/pdf_doc/texts/pdf_subtitle_text.dart';
import 'package:cvms_desktop/features/dashboard/widgets/pdf_doc/tables/pdf_table.dart';
import 'package:cvms_desktop/features/dashboard/controllers/global_report_remarks_builder.dart';
import 'package:cvms_desktop/features/dashboard/models/fleet_summary.dart';
import 'package:pdf/widgets.dart' as pw;
import '../widgets/pdf_doc/letter_head/doc_signatory.dart';
import '../widgets/pdf_doc/templates/pdf_page_template.dart';

class GlobalReportBuilder {
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

    double sumValues(List<ChartDataModel>? data) {
      if (data == null || data.isEmpty) return 0;
      return data.fold<double>(0, (sum, item) => sum + item.value);
    }

    List<List<String>> rowsWithPercent(List<ChartDataModel>? data) {
      if (data == null || data.isEmpty) return const [];
      final total = sumValues(data);
      return data.map((d) {
        final pct = total <= 0 ? 0 : (d.value / total) * 100;
        return [
          d.category,
          d.value.toStringAsFixed(0),
          '${pct.toStringAsFixed(1)}%',
        ];
      }).toList();
    }

    // Page 1: Fleet Summary and Distributions
    final page1Content = pw.Column(
      children: [
        PdfReportTitle(titleTxt: 'Global Vehicle Monitoring Report'),
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
            // Section 2: Vehicle Distribution per College
            PdfSectionText(
              title: '2. Vehicle Distribution per College',
              subTitle:
                  "This section shows the distribution of vehicles across colleges.",
            ),
            pw.SizedBox(height: 5),
            PdfTable(
              headers: ['College', 'Number of Vehicles', 'Percentage'],
              rows: rowsWithPercent(vehicleDistribution),
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
              rows: rowsWithPercent(yearLevelBreakdown),
              columnWidths: {
                0: pw.FlexColumnWidth(2),
                1: pw.FlexColumnWidth(1),
                2: pw.FlexColumnWidth(1),
              },
            ),
            pw.SizedBox(height: 20),
            PdfSectionFooterText(
              footerTitle: 'Remarks: ',
              footerSubTitle: GlobalReportRemarksBuilder.topCategoryRemark(
                data: yearLevelBreakdown,
                fallback:
                    'Year level breakdown is not available for the selected period.',
              ),
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
          rows: rowsWithPercent(cityBreakdown),
          columnWidths: {
            0: pw.FlexColumnWidth(2),
            1: pw.FlexColumnWidth(1),
            2: pw.FlexColumnWidth(1),
          },
        ),
        pw.SizedBox(height: 20),
        PdfSectionFooterText(
          footerTitle: 'Remarks: ',
          footerSubTitle: GlobalReportRemarksBuilder.topCategoryRemark(
            data: cityBreakdown,
            fallback:
                'City/municipality breakdown is not available for the selected period.',
          ),
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
          rows: rowsWithPercent(fleetSummary?.departmentLogData),
          columnWidths: {
            0: pw.FlexColumnWidth(2),
            1: pw.FlexColumnWidth(1),
            2: pw.FlexColumnWidth(1),
          },
        ),
        pw.SizedBox(height: 20),
        PdfSectionFooterText(
          footerTitle: 'Remarks: ',
          footerSubTitle: GlobalReportRemarksBuilder.topCategoryRemark(
            data: fleetSummary?.departmentLogData,
            fallback:
                'Vehicle logs distribution per college is not available for the selected period.',
          ),
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
          rows: rowsWithPercent(fleetSummary?.deptViolationData),
          columnWidths: {
            0: pw.FlexColumnWidth(2),
            1: pw.FlexColumnWidth(1),
            2: pw.FlexColumnWidth(1),
          },
        ),
        pw.SizedBox(height: 10),
        PdfSectionFooterText(
          footerTitle: 'Remarks: ',
          footerSubTitle: GlobalReportRemarksBuilder.topCategoryRemark(
            data: fleetSummary?.deptViolationData,
            fallback:
                'Violation distribution per college is not available for the selected period.',
          ),
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
          rows: () {
            final types = fleetSummary?.topViolationTypes;
            if (types == null || types.isEmpty) return const <List<String>>[];
            final total = types.fold<int>(0, (sum, t) => sum + t.count);
            return types.map((t) {
              final pct = total <= 0 ? 0 : (t.count / total) * 100;
              return [t.type, t.count.toString(), '${pct.toStringAsFixed(1)}%'];
            }).toList();
          }(),
          columnWidths: {
            0: pw.FlexColumnWidth(2),
            1: pw.FlexColumnWidth(1),
            2: pw.FlexColumnWidth(1),
          },
        ),
        pw.SizedBox(height: 20),
        PdfSectionFooterText(
          footerTitle: 'Remarks: ',
          footerSubTitle: GlobalReportRemarksBuilder.topViolationTypeRemark(
            fleetSummary: fleetSummary,
            fallback:
                'Violation type distribution is not available for the selected period.',
          ),
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
          rows:
              logsData.map((d) {
                if (d.date != null) {
                  final dt = d.date!;
                  final month = dt.month.toString().padLeft(2, '0');
                  final day = dt.day.toString().padLeft(2, '0');
                  return ['${dt.year}-$month-$day', d.value.toStringAsFixed(0)];
                }
                return [d.category, d.value.toStringAsFixed(0)];
              }).toList(),
          columnWidths: {0: pw.FlexColumnWidth(2), 1: pw.FlexColumnWidth(1)},
        ),
        pw.SizedBox(height: 10),
        PdfSectionFooterText(
          footerTitle: 'Remarks: ',
          footerSubTitle: GlobalReportRemarksBuilder.busiestDayRemark(
            data: logsData,
            fallback:
                'Vehicle log trend data is not available for the selected period.',
          ),
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
          rows: rowsWithPercent(studentWithMostViolations),
          columnWidths: {
            0: pw.FlexColumnWidth(2),
            1: pw.FlexColumnWidth(1),
            2: pw.FlexColumnWidth(1),
          },
        ),
        PdfSectionFooterText(
          footerTitle: 'Remarks: ',
          footerSubTitle: GlobalReportRemarksBuilder.topCategoryRemark(
            data: studentWithMostViolations,
            fallback:
                'Student violation ranking is not available for the selected period.',
          ),
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
