import 'package:pdf/widgets.dart' as pw;

import '../../core/pdf_section.dart';
import '../../components/sections/doc_signatory.dart';
import '../../../models/report/individual_vehicle_report_model.dart';

class IndividualSignatorySection
    implements PdfSection<IndividualVehicleReportModel> {
  final String preparer;
  final String preparerDesignation;
  final String approver;
  final String approverDesignation;

  const IndividualSignatorySection({
    required this.preparer,
    required this.preparerDesignation,
    required this.approver,
    required this.approverDesignation,
  });

  @override
  List<pw.Widget> build(IndividualVehicleReportModel report) {
    return [
      pw.SizedBox(height: 10),

      DocSignatory(
        preparer: preparer,
        preparerDesignation: preparerDesignation,
        approver: approver,
        approverDesignation: approverDesignation,
      ),

      pw.Spacer(),
    ];
  }
}
