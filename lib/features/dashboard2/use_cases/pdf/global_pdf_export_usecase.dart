import 'dart:typed_data';

import 'package:cvms_desktop/features/dashboard2/assemblers/report/global_report_assembler.dart';
import 'package:cvms_desktop/features/dashboard2/services/pdf/pdf_generation_service.dart';
import 'package:pdf/pdf.dart';

import '../../models/report/date_range.dart';
import '../../pdf/core/pdf_branding_config.dart';

class GlobalPdfExportUseCase {
  final GlobalReportAssembler assembler;
  final PdfGenerationService pdfService;
  final PdfBrandingConfig brandingConfig;

  GlobalPdfExportUseCase({
    required this.assembler,
    required this.pdfService,
    required this.brandingConfig,
  });

  Future<Uint8List> generatePdfReport({
    required DateRange range,
    PdfPageFormat pageFormat = PdfPageFormat.legal,
  }) async {
    final report = await assembler.assemble(range: range);

    return pdfService.generateGlobalReport(
      report: report,
      branding: brandingConfig,
      pageFormat: pageFormat,
    );
  }
}
