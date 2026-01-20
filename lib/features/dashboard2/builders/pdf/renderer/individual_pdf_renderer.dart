import 'package:cvms_desktop/features/dashboard2/models/report/individual_vehicle_report_model.dart';
import 'package:cvms_desktop/features/dashboard2/builders/pdf/templates/pdf_page_template.dart';
import 'package:pdf/widgets.dart' as pw;
import '../sections/pdf_section.dart';

class IndividualPdfRenderer {
  final PdfPageTemplate template;
  final List<PdfSection> sections;

  IndividualPdfRenderer({required this.template, required this.sections});

  Future<List<int>> render(IndividualVehicleReportModel report) async {
    final pdf = pw.Document();

    pdf.addPage(
      template.build(
        child: pw.Column(
          children: sections.map((s) => s.build(report)).toList(),
        ),
      ),
    );

    return pdf.save();
  }
}
