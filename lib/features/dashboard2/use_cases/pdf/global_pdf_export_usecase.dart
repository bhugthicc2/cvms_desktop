import 'dart:typed_data';

import 'package:cvms_desktop/features/dashboard2/services/pdf/pdf_generation_service.dart';

import '../../assemblers/report/global_report_assembler.dart';
import '../../models/report/date_range.dart';

class GlobalPdfExportUseCase {
  final GlobalReportAssembler assembler;
  final PdfGenerationService pdfService;

  GlobalPdfExportUseCase({required this.assembler, required this.pdfService});

  Future<Uint8List> export({required DateRange range}) async {
    final report = await assembler.assemble(range: range);
    return pdfService.generateGlobalReport(report);
  }
}
