import 'dart:typed_data';
import 'package:cvms_desktop/features/dashboard2/pdf/builders/global_report_builder.dart';
import 'package:cvms_desktop/features/dashboard2/pdf/builders/individual_report_builder.dart';
import 'package:pdf/pdf.dart';

import '../../models/report/global_vehicle_report_model.dart';
import '../../models/report/individual_vehicle_report_model.dart';
import '../../pdf/core/pdf_branding_config.dart';

class PdfGenerationService {
  Future<Uint8List> generateGlobalReport({
    required GlobalVehicleReportModel report,
    required PdfBrandingConfig branding,
    required PdfPageFormat pageFormat,
  }) async {
    return GlobalReportBuilder.build(
      report: report,
      branding: branding,
      pageFormat: pageFormat,
    );
  }

  Future<Uint8List> generateIndividualReport({
    required IndividualVehicleReportModel report,
    required PdfBrandingConfig branding,
    required PdfPageFormat pageFormat,
  }) async {
    return IndividualReportBuilder.build(
      report: report,
      branding: branding,
      pageFormat: pageFormat,
    );
  }
}
