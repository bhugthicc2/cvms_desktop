import 'package:cvms_desktop/features/dashboard/pdf/components/sections/pdf_insight_box.dart';
import 'package:cvms_desktop/features/dashboard/pdf/core/pdf_insight.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../models/report/individual_vehicle_report_model.dart';
import '../../core/pdf_section.dart';
import '../../components/sections/pdf_section_title.dart';
import '../../components/tables/pdf_table.dart';

class VehicleInfoSection implements PdfSection<IndividualVehicleReportModel> {
  @override
  List<pw.Widget> build(IndividualVehicleReportModel report) {
    final v = report.vehicle;

    return [
      PdfSectionTitle(
        title: '1. Vehicle Information',
        subTitle: 'Registered vehicle profile and validity details',
      ),

      pw.SizedBox(height: 10),

      PdfTable(
        headers: const ['Field', 'Value'],
        rows: [
          ['Plate Number', v.plateNumber],
          ['Owner Name', v.ownerName],
          ['Vehicle Type', v.vehicleType],
          ['Department', v.department],
          ['Vehicle Model', v.vehicleModel],
          ['Vehicle Status', v.status],
        ],
        columnWidths: const {
          0: pw.FlexColumnWidth(1),
          1: pw.FlexColumnWidth(1),
        },
      ),
      pw.SizedBox(height: 10),
      PdfInsightBox(_generateInsight(report)),
      pw.SizedBox(height: 24),
    ];
  }

  PdfInsight _generateInsight(IndividualVehicleReportModel report) {
    final v = report.vehicle;

    final missingFields = <String>[];

    if (v.ownerName.trim().isEmpty) missingFields.add('Owner Name');
    if (v.department.trim().isEmpty) missingFields.add('Department');
    if (v.vehicleModel.trim().isEmpty) missingFields.add('Vehicle Model');
    if (v.vehicleType.trim().isEmpty) missingFields.add('Vehicle Type');

    if (v.status.toLowerCase() != 'active') {
      return PdfInsight(
        title: 'Registration Status Alert',
        description:
            'This vehicle is currently marked as "${v.status}". '
            'Administrative review may be required to verify its eligibility '
            'for regular operation within the system.',
      );
    }

    if (missingFields.isNotEmpty) {
      return PdfInsight(
        title: 'Incomplete Vehicle Profile',
        description:
            'Some registration details are missing or incomplete, including: '
            '${missingFields.join(', ')}. '
            'Updating these fields will help ensure accurate reporting and compliance.',
      );
    }

    return PdfInsight(
      title: 'Valid Vehicle Registration',
      description:
          'This vehicle is properly registered with complete profile details '
          'and is currently marked as active. No immediate administrative issues '
          'were identified in the vehicle information record.',
    );
  }
}
