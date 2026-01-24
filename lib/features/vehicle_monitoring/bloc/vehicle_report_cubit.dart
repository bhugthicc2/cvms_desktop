import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/violation_model.dart';
import '../data/vehicle_monitoring_repository.dart';
import '../../../core/widgets/app/custom_snackbar.dart';

part 'vehicle_report_state.dart';

class VehicleReportCubit extends Cubit<VehicleReportState> {
  final DashboardRepository _repository = DashboardRepository();

  VehicleReportCubit() : super(VehicleReportState.initial());

  Future<String> reportViolation(ViolationModel violation) async {
    return _repository.reportViolation(violation);
  }

  void clearMessage() {
    emit(state.copyWith(message: null, messageType: null));
  }

  void reset() {
    emit(VehicleReportState.initial());
  }
}
