import 'dart:typed_data';

import 'package:cvms_desktop/features/dashboard2/models/report/global_vehicle_report_model.dart';
import 'package:cvms_desktop/features/dashboard2/models/report/individual_vehicle_report_model.dart';
import 'package:cvms_desktop/features/dashboard2/builders/pdf/individual_report_builder.dart';
import 'package:cvms_desktop/features/dashboard2/builders/pdf/global_report_builder.dart';

class PdfGenerationService {
  Future<Uint8List> generateGlobalReport(
    GlobalVehicleReportModel report,
  ) async {
    return GlobalReportBuilder.build(report);
  }

  Future<Uint8List> generateIndividualReport(
    IndividualVehicleReportModel report,
  ) async {
    return IndividualReportBuilder.build(report);
  }
}
