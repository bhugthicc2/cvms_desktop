import 'dart:typed_data';
import 'package:cvms_desktop/features/dashboard2/builders/pdf/templates/default_pdf_page_template.dart';
import 'package:cvms_desktop/features/dashboard2/models/report/individual_vehicle_report_model.dart';
import 'package:pdf/widgets.dart' as pw;
import '../pdf/templates/pdf_page_template.dart';

class IndividualReportBuilder {
  static Future<Uint8List> build(IndividualVehicleReportModel data) async {
    final pdf = pw.Document();
    final PdfPageTemplate template = DefaultPdfPageTemplate();

    pdf.addPage(
      template.build(
        child: pw.Text(
          'Individual Vehicle Monitoring Report\n'
          'Period: ${data.period}',
        ),
      ),
    );

    // Later:
    // - charts
    // - tables
    // - summaries

    return Uint8List.fromList(await pdf.save());
  }
}
