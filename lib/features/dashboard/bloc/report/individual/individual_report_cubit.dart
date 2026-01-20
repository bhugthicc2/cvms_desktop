import 'package:cvms_desktop/features/dashboard/bloc/report/individual/individual_report_state.dart';
import 'package:cvms_desktop/features/dashboard/models/report/date_range.dart';
import 'package:cvms_desktop/features/dashboard/use_cases/pdf/pdf_export_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/features/dashboard/assemblers/report/individual_report_assembler.dart';
import 'package:cvms_desktop/features/dashboard/models/report/individual_report_query.dart';
import 'package:cvms_desktop/features/dashboard/models/report/individual_report_options.dart';
import 'package:cvms_desktop/features/dashboard/utils/pdf/pdf_branding.dart';

class IndividualReportCubit extends Cubit<IndividualReportState> {
  final IndividualReportAssembler assembler;
  final PdfExportUseCase pdfExportUseCase;

  IndividualReportCubit(this.assembler, this.pdfExportUseCase)
    : super(const IndividualReportState.initial());

  Future<void> load({
    required String vehicleId,
    required DateRange range,
  }) async {
    emit(state.copyWith(loading: true));

    try {
      final report = await assembler.assemble(
        IndividualReportQuery(
          vehicleId: vehicleId,
          range: range, // Pass the entire DateRange object
          options: const IndividualReportOptions(
            branding: PdfBranding(
              title: 'Vehicle Report',
              department: 'Campus Security',
            ),
          ),
        ),
      );

      emit(state.copyWith(loading: false, report: report));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void updateRange(DateRange range) {
    final current = state.report;
    if (current == null) return;

    load(
      vehicleId: current.vehicle.vehicleId, // or vehicleId if stored
      range: range,
    );
  }

  Future<void> previewPdf(IndividualReportQuery query) async {
    try {
      emit(state.copyWith(loading: true));

      // 1. Assemble report data
      final report = await assembler.assemble(query);

      // 2. Generate PDF
      final pdfBytes = await pdfExportUseCase.export();

      // 3. Emit result
      emit(state.copyWith(loading: false, report: report, pdfBytes: pdfBytes));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
