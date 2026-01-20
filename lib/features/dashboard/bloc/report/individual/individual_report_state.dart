import 'dart:typed_data';

import 'package:cvms_desktop/features/dashboard/models/report/individual_vehicle_report_model.dart';

class IndividualReportState {
  final bool loading;
  final IndividualVehicleReportModel? report;
  final String? error;

  //pdf

  final Uint8List? pdfBytes;

  const IndividualReportState({
    required this.loading,
    this.report,
    this.error,
    this.pdfBytes,
  });

  const IndividualReportState.initial()
    : loading = false,
      report = null,
      error = null,
      pdfBytes = null;

  IndividualReportState copyWith({
    bool? loading,
    IndividualVehicleReportModel? report,
    String? error,
    Uint8List? pdfBytes,
  }) {
    return IndividualReportState(
      loading: loading ?? this.loading,
      report: report ?? this.report,
      error: error,
      pdfBytes: pdfBytes ?? this.pdfBytes,
    );
  }
}
