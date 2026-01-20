import 'package:cvms_desktop/features/dashboard2/pdf/components/texts/pdf_report_title.dart';
import 'package:cvms_desktop/features/dashboard2/pdf/components/texts/pdf_subtitle_text.dart';
import 'package:cvms_desktop/features/dashboard2/pdf/sections/pdf_report_section.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../models/report/individual_vehicle_report_model.dart';

class IndividualReportTitleSection
    implements PdfReportSection<IndividualVehicleReportModel> {
  @override
  List<pw.Widget> build(IndividualVehicleReportModel data) {
    return [
      pw.Align(
        alignment: pw.Alignment.center,
        child: PdfReportTitle(
          titleTxt: "${data.vehicle.ownerName}'s Vehicle Monitoring Report",
        ),
      ),

      pw.Align(
        alignment: pw.Alignment.center,
        child: PdfSubtitleText(
          label: 'Period: ',
          value: data.period.toString(),
        ),
      ),
      pw.SizedBox(height: 20),
    ];
  }
}
