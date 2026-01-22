import 'package:intl/intl.dart';

class PdfFileNameBuilder {
  static String globalReport(DateTime date) {
    final formatted = DateFormat('MMM_yyyy').format(date);
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());

    return 'Global_Report_${formatted}_$timestamp.pdf';
  }

  static String individualVehicleReport({required String plateNumber}) {
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    return 'Vehicle_${plateNumber}_Report_$timestamp.pdf';
  }
}
