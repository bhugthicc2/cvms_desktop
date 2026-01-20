import 'package:cvms_desktop/features/dashboard2/models/report/global_vehicle_report_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/features/dashboard2/assemblers/report/global_report_assembler.dart';
import '../../../models/report/date_range.dart';

part 'global_report_state.dart';

class GlobalReportCubit extends Cubit<GlobalReportState> {
  final GlobalReportAssembler assembler;

  GlobalReportCubit(this.assembler) : super(const GlobalReportState.initial());

  Future<void> load({required DateRange range}) async {
    emit(state.copyWith(loading: true));

    try {
      final report = await assembler.assemble(
        range: DateRange(range.start, range.end),
      );

      emit(state.copyWith(loading: false, report: report));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void updateRange(DateRange range) {
    load(range: range);
  }
}
