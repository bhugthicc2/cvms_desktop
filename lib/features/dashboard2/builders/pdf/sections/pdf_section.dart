import 'package:pdf/widgets.dart' as pw;
import '../../../models/report/individual_vehicle_report_model.dart';

abstract class PdfSection {
  pw.Widget build(IndividualVehicleReportModel report);
}
