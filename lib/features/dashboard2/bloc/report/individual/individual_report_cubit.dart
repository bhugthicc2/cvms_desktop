import 'package:cvms_desktop/features/dashboard2/bloc/report/individual/individual_report_state.dart';
import 'package:cvms_desktop/features/dashboard2/use_cases/pdf/pdf_export_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/features/dashboard2/assemblers/report/individual_report_assembler.dart';
import 'package:cvms_desktop/features/dashboard2/models/report/individual_report_query.dart';
import 'package:cvms_desktop/features/dashboard2/models/report/individual_report_options.dart';
import 'package:cvms_desktop/features/dashboard2/models/report/date_range_filter.dart';
import 'package:cvms_desktop/features/dashboard2/utils/pdf/pdf_branding.dart';

class IndividualReportCubit extends Cubit<IndividualReportState> {
  final IndividualReportAssembler assembler;
  final PdfExportUseCase pdfExportUseCase;

  IndividualReportCubit(this.assembler, this.pdfExportUseCase)
    : super(const IndividualReportState.initial());

  Future<void> load({
    required String vehicleId,
    required DateRangeFilter range,
  }) async {
    emit(state.copyWith(loading: true));

    try {
      final report = await assembler.assemble(
        IndividualReportQuery(
          vehicleId: vehicleId,
          start: range.start,
          end: range.end,
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

  void updateRange(DateRangeFilter range) {
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
