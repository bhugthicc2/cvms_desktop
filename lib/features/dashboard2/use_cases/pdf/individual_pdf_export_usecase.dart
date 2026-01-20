import 'dart:typed_data';

import 'package:cvms_desktop/features/dashboard2/models/report/individual_report_options.dart';
import 'package:cvms_desktop/features/dashboard2/pdf/core/pdf_branding_config.dart';
import 'package:cvms_desktop/features/dashboard2/services/pdf/pdf_generation_service.dart';
import 'package:pdf/pdf.dart';

import '../../assemblers/report/individual_report_assembler.dart';
import '../../models/report/date_range.dart';
import '../../models/report/individual_report_query.dart';
import '../../utils/pdf/pdf_branding.dart';

class IndividualPdfExportUseCase {
  final IndividualReportAssembler assembler;
  final PdfGenerationService pdfService;
  final IndividualReportOptions? options;
  final PdfBrandingConfig brandingConfig;

  IndividualPdfExportUseCase({
    required this.assembler,
    required this.pdfService,
    this.options,
    required this.brandingConfig,
  });

  Future<Uint8List> export({
    required String vehicleId,
    required DateRange range,
    PdfPageFormat pageFormat = PdfPageFormat.legal,
  }) async {
    final report = await assembler.assemble(
      IndividualReportQuery(
        vehicleId: vehicleId,
        range: range, // Pass the entire DateRange object
        options:
            options ??
            const IndividualReportOptions(
              includeViolationSummary: true,
              includeRecentLogs: true,
              includeCharts: false,
              branding: PdfBranding(
                title: 'Individual Vehicle Report',
                department: 'CVMS',
              ),
            ),
      ),
    );

    return pdfService.generateIndividualReport(
      report: report,
      branding: brandingConfig,
      pageFormat: pageFormat,
    );
  }
}
