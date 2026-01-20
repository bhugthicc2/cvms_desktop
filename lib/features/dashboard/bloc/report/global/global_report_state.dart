part of 'global_report_cubit.dart';

class GlobalReportState {
  final bool loading;
  final GlobalVehicleReportModel? report;
  final String? error;

  const GlobalReportState({required this.loading, this.report, this.error});

  const GlobalReportState.initial()
    : loading = false,
      report = null,
      error = null;

  GlobalReportState copyWith({
    bool? loading,
    GlobalVehicleReportModel? report,
    String? error,
  }) {
    return GlobalReportState(
      loading: loading ?? this.loading,
      report: report ?? this.report,
      error: error,
    );
  }
}
