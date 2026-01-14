import 'dart:typed_data';

import 'package:cvms_desktop/features/reports/controllers/global_chart_report_builder.dart';
import 'package:cvms_desktop/features/reports/controllers/global_report_builder.dart';
import 'package:cvms_desktop/features/reports/controllers/individual_report_builder.dart';

class PdfReportBuilder {
  static Future<Uint8List> buildVehicleReport({
    bool isGlobal = true,
    bool isChart = true,
    Map<String, dynamic>? globalData,
    Map<String, dynamic>? individualData,
  }) async {
    if (isGlobal && !isChart) {
      return await GlobalReportBuilder.build(globalData);
    }
    if (isGlobal && isChart) {
      return await GlobalChartReportBuilder.build(globalData);
    } else {
      return await IndividualReportBuilder.build(individualData);
    }
  }
}
