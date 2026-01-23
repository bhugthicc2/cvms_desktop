import 'package:cvms_desktop/features/dashboard/models/dashboard/chart_data_model.dart';

class ChartDataSorter {
  static List<ChartDataModel> sortByValueDescending(List<ChartDataModel> data) {
    return List<ChartDataModel>.from(data)
      ..sort((a, b) => b.value.compareTo(a.value));
  }
}
