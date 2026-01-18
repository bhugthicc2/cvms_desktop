import 'package:cvms_desktop/features/dashboard/data/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/models/fleet_summary.dart';

class GlobalReportRemarksBuilder {
  static ChartDataModel? _maxByValue(List<ChartDataModel>? data) {
    if (data == null || data.isEmpty) return null;
    ChartDataModel? best;
    for (final d in data) {
      if (best == null || d.value > best.value) best = d;
    }
    return best;
  }

  static String topCategoryRemark({
    required List<ChartDataModel>? data,
    required String fallback,
  }) {
    final top = _maxByValue(data);
    if (top == null) return fallback;
    return '${top.category} has the highest count with ${top.value.toStringAsFixed(0)}.';
  }

  static String busiestDayRemark({
    required List<ChartDataModel> data,
    required String fallback,
  }) {
    final top = _maxByValue(data);
    if (top == null) return fallback;
    if (top.date != null) {
      final dt = top.date!;
      final month = dt.month.toString().padLeft(2, '0');
      final day = dt.day.toString().padLeft(2, '0');
      return 'Vehicle activity peaked on ${dt.year}-$month-$day with ${top.value.toStringAsFixed(0)} logs.';
    }
    return 'Vehicle activity peaked on ${top.category} with ${top.value.toStringAsFixed(0)} logs.';
  }

  static String topViolationTypeRemark({
    required FleetSummary? fleetSummary,
    required String fallback,
  }) {
    final types = fleetSummary?.topViolationTypes;
    if (types == null || types.isEmpty) return fallback;
    final top = types.reduce((a, b) => a.count >= b.count ? a : b);
    return '${top.type} is the most common violation type with ${top.count} occurrences.';
  }
}
