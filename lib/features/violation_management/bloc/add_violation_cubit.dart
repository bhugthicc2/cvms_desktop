import 'dart:async';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/features/violation_management/data/violation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_violation_state.dart';

class AddViolationCubit extends Cubit<AddViolationState> {
  final ViolationRepository _repository = ViolationRepository();

  AddViolationCubit() : super(AddViolationState.initial());

  void resetForm() {
    emit(AddViolationState.initial());
  }

  void updateVehicleId(String vehicleId) {
    emit(state.copyWith(vehicleId: vehicleId));
  }

  void updateViolationType(String violationType) {
    emit(state.copyWith(violationType: violationType));
  }

  void updateReportedByUserId(String reportedByUserId) {
    emit(state.copyWith(reportedByUserId: reportedByUserId));
  }

  void updateStatus(String status) {
    emit(state.copyWith(status: status));
  }

  void clearMessage() {
    emit(state.copyWith(message: null, messageType: null));
  }

  Future<void> submitViolationReport() async {
    if (!state.isFormValid) {
      emit(
        state.copyWith(
          message: 'Please fill in all required fields',
          messageType: SnackBarType.error,
        ),
      );
      return;
    }

    emit(state.copyWith(isSubmitting: true));

    try {
      await _repository.createViolationReport(
        vehicleId: state.vehicleId!,
        reportedByUserId: state.reportedByUserId!,
        violationType: state.violationType!,
        status: state.status,
      );

      emit(
        state.copyWith(
          isSubmitting: false,
          message: 'Violation report submitted successfully',
          messageType: SnackBarType.success,
        ),
      );

      // Reset form after successful submission
      Future.delayed(const Duration(seconds: 2), () {
        if (!isClosed) {
          resetForm();
        }
      });
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          message: 'Failed to submit violation report: ${e.toString()}',
          messageType: SnackBarType.error,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
