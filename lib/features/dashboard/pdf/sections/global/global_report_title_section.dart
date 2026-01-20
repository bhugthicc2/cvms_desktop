import 'package:cvms_desktop/core/utils/date_time_formatter.dart';
import 'package:cvms_desktop/features/dashboard/pdf/components/texts/pdf_report_title.dart';
import 'package:cvms_desktop/features/dashboard/pdf/components/texts/pdf_subtitle_text.dart';
import 'package:cvms_desktop/features/dashboard/pdf/core/pdf_section.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../models/report/global_vehicle_report_model.dart';

class GlobalReportTitleSection implements PdfSection<GlobalVehicleReportModel> {
  @override
  List<pw.Widget> build(GlobalVehicleReportModel data) {
    return [
      pw.SizedBox(height: 10),
      pw.Align(
        alignment: pw.Alignment.center,
        child: PdfReportTitle(titleTxt: 'Global Vehicle Monitoring Report'),
      ),
      pw.SizedBox(height: 15),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,

        children: [
          PdfSubtitleText(label: 'Period: ', value: data.period.toString()),

          PdfSubtitleText(
            label: 'Generated on: ',
            value: DateTimeFormatter.formatAbbreviated(DateTime.now()),
          ),
        ],
      ),

      pw.SizedBox(height: 5),
    ];
  }
}
