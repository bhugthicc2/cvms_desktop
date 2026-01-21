import 'package:cvms_desktop/features/dashboard/pdf/components/sections/pdf_insight_box.dart';
import 'package:cvms_desktop/features/dashboard/pdf/core/pdf_insight.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../models/report/individual_vehicle_report_model.dart';
import '../../core/pdf_section.dart';
import '../../components/sections/pdf_section_title.dart';
import '../../components/tables/pdf_table.dart';
import '../../../../../core/utils/date_time_formatter.dart';

class MVPStatusSection implements PdfSection<IndividualVehicleReportModel> {
  @override
  List<pw.Widget> build(IndividualVehicleReportModel report) {
    final v = report.vehicle;

    return [
      PdfSectionTitle(
        title: '2. MVP Status',
        subTitle: 'MVP status and validity details',
      ),

      pw.SizedBox(height: 10),

      PdfTable(
        headers: const ['Field', 'Value'],
        rows: [
          [
            'Days until MVP Expiration',
            "${report.vehicle.daysUntilExpiration.toString()} Days",
          ],
          ['MVP Status', v.mvpStatusText],
          [
            'Registration Date',
            v.createdAt != null
                ? DateTimeFormatter.formatAbbreviated(v.createdAt!)
                : '—',
          ],
          [
            'Expiry Date',
            v.expiryDate != null
                ? DateTimeFormatter.formatAbbreviated(v.expiryDate!)
                : '—',
          ],
        ],
        columnWidths: const {
          0: pw.FlexColumnWidth(1),
          1: pw.FlexColumnWidth(1),
        },
      ),

      pw.SizedBox(height: 12),

      PdfInsightBox(_generateMvpInsight(report)),

      pw.SizedBox(height: 24),
    ];
  }

  PdfInsight _generateMvpInsight(IndividualVehicleReportModel report) {
    final v = report.vehicle;
    final daysLeft = report.vehicle.daysUntilExpiration;
    final expiry = v.expiryDate;

    if (expiry == null) {
      return PdfInsight(
        title: 'Missing MVP Record',
        description:
            'No Motor Vehicle Pass (MVP) expiry information is available for this vehicle. '
            'This may indicate that an MVP has not been issued or the record is incomplete. '
            'Verification with the issuing office is recommended.',
      );
    }

    if (daysLeft < 0) {
      return PdfInsight(
        title: 'Expired MVP',
        description:
            'The Motor Vehicle Pass for this vehicle expired '
            '${daysLeft.abs()} day(s) ago. '
            'The vehicle is no longer authorized for regular access and should '
            'not be operated until the MVP is renewed.',
      );
    }

    if (daysLeft <= 30) {
      return PdfInsight(
        title: 'MVP Expiring Soon',
        description:
            'The Motor Vehicle Pass for this vehicle will expire in '
            '$daysLeft day(s). '
            'It is recommended to initiate renewal procedures to avoid '
            'interruption of vehicle access.',
      );
    }

    return PdfInsight(
      title: 'Valid MVP',
      description:
          'This vehicle has a valid Motor Vehicle Pass with '
          '$daysLeft day(s) remaining before expiration. '
          'No immediate action is required at this time.',
    );
  }
}
