import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/dashboard/pdf/core/pdf_branding_config.dart';
import 'package:cvms_desktop/features/dashboard/services/pdf/pdf_print_service.dart';
import 'package:cvms_desktop/features/dashboard/services/pdf/pdf_save_service.dart';
import 'package:cvms_desktop/features/dashboard/use_cases/pdf/global_pdf_export_usecase.dart';
import 'package:cvms_desktop/features/dashboard/use_cases/pdf/individual_pdf_export_usecase.dart';
import 'package:pdf/widgets.dart' as pw;
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

  //Branding
  static PdfBrandingConfig pdfBrandingConfig = PdfBrandingConfig(
    department: 'CDRRMS Unit',
    republicText: 'REPUBLIC OF THE PHILIPPINES',
    universityText: 'JOSE RIZAL MEMORIAL STATE UNIVERSITY',
    taglineText: 'The Premier University in Zamboanga del Norte',
    campusText: 'Katipunan Campus, Zamboanga del Norte',
    registrationText: 'Registration No. 621082',
    institutionLogo: pw.MemoryImage(
      File('assets/images/jrmsu-logo.png').readAsBytesSync(),
    ),
    isoLogo: pw.MemoryImage(File('assets/images/iso.jpg').readAsBytesSync()),
    isoCertifiedLogo: pw.MemoryImage(
      File('assets/images/iso_certified_logo.png').readAsBytesSync(),
    ),
    aacupLogo: pw.MemoryImage(
      File('assets/images/aaccup_logo.png').readAsBytesSync(),
    ),
    homeText: 'Barangay Dos, Katipunan, ZDN',
    email: 'cdrrsmukatipunan@jrmsu.edu.ph',
    phone: '(062) 333-2222',
    homeIcon: pw.MemoryImage(
      File('assets/images/home_icon.png').readAsBytesSync(),
    ),
    mailIcon: pw.MemoryImage(
      File('assets/images/mail_icon.png').readAsBytesSync(),
    ),
    phoneIcon: pw.MemoryImage(
      File('assets/images/call_icon.png').readAsBytesSync(),
    ),
  );

  // UseCases
  static final globalPdfExportUseCase = GlobalPdfExportUseCase(
    assembler: globalReportAssembler,
    pdfService: pdfGenerationService,
    brandingConfig: pdfBrandingConfig,
  );

  static final individualPdfExportUseCase = IndividualPdfExportUseCase(
    assembler: individualReportAssembler,
    pdfService: pdfGenerationService,
    brandingConfig: pdfBrandingConfig,
  );

  final _saveService = PdfSaveService();
  final _printService = PdfPrintService();
}
