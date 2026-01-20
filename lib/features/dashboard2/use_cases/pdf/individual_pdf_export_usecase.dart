import 'dart:typed_data';

import 'package:cvms_desktop/features/dashboard2/models/report/individual_report_options.dart';
import 'package:cvms_desktop/features/dashboard2/services/pdf/pdf_generation_service.dart';

import '../../assemblers/report/individual_report_assembler.dart';
import '../../models/report/date_range.dart';
import '../../models/report/individual_report_query.dart';

class IndividualPdfExportUseCase {
  final IndividualReportAssembler assembler;
  final PdfGenerationService pdfService;
  final IndividualReportOptions? options;

  IndividualPdfExportUseCase({
    required this.assembler,
    required this.pdfService,
    this.options,
  });

  Future<Uint8List> export({
    required String vehicleId,
    required DateRange range,
  }) async {
    final report = await assembler.assemble(
      IndividualReportQuery(
        vehicleId: vehicleId,
        start: range.start,
        end: range.end,
        options: options!,
      ),
    );

    return pdfService.generateIndividualReport(report);
  }
}
