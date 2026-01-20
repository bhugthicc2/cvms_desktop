import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/dashboard2/use_cases/pdf/global_pdf_export_usecase.dart';
import 'package:cvms_desktop/features/dashboard2/use_cases/pdf/individual_pdf_export_usecase.dart';

import '../repositories/report/global_report_repository.dart';
import '../repositories/report/individual_report_repository.dart';
import '../assemblers/report/global_report_assembler.dart';
import '../assemblers/report/individual_report_assembler.dart';
import '../services/pdf/pdf_generation_service.dart';

class DashboardDependencies {
  // Firebase
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Repositories
  static final globalReportRepository = GlobalReportRepository(firestore);

  static final individualReportRepository = IndividualReportRepository(
    firestore,
  );

  // Assemblers
  static final globalReportAssembler = GlobalReportAssembler(
    globalReportRepository,
  );

  static final individualReportAssembler = IndividualReportAssembler(
    individualReportRepository,
  );

  // Services
  static final pdfGenerationService = PdfGenerationService();

  // UseCases
  static final globalPdfExportUseCase = GlobalPdfExportUseCase(
    assembler: globalReportAssembler,
    pdfService: pdfGenerationService,
  );

  static final individualPdfExportUseCase = IndividualPdfExportUseCase(
    assembler: individualReportAssembler,
    pdfService: pdfGenerationService,
  );
}
