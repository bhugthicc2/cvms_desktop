import 'dart:typed_data';

import 'package:cvms_desktop/features/dashboard/bloc/reports/reports_cubit.dart';
import 'package:cvms_desktop/features/dashboard/controllers/global_chart_report_builder.dart';
import 'package:cvms_desktop/features/dashboard/controllers/global_report_builder.dart';
import 'package:cvms_desktop/features/dashboard/controllers/individual_report_builder.dart';

class PdfReportBuilder {
  static Future<Uint8List> buildVehicleReport({
    ReportsCubit? reportsCubit,
    bool isChart = true, //todo make this dynamic
    Map<String, dynamic>? globalData,
    Map<String, dynamic>? individualData,
  }) async {
    final isGlobal = globalData != null && individualData == null;

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
