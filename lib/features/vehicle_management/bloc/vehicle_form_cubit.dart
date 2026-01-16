import 'package:bloc/bloc.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_form_state.dart';
import 'package:cvms_desktop/features/vehicle_management/models/vehicle_form_data.dart';

class VehicleFormCubit extends Cubit<VehicleFormState> {
  VehicleFormCubit() : super(const VehicleFormInitial());

  VehicleFormData get formData => state.formData;

  // Step 1 - Owner Information
  void updateStep1({
    String? ownerName,
    String? gender,
    String? contact,
    String? schoolId,
    String? department,
    String? yearLevel,
    String? block,
  }) {
    final updatedData = formData.copyWith(
      ownerName: ownerName,
      gender: gender,
      contact: contact,
      schoolId: schoolId,
      department: department,
      yearLevel: yearLevel,
      block: block,
    );
    emit(VehicleFormUpdated(formData: updatedData));
  }

  // Step 2 - Vehicle Information
  void updateStep2({
    String? plateNumber,
    String? vehicleModel,
    String? vehicleColor,
    String? vehicleType,
  }) {
    final updatedData = formData.copyWith(
      plateNumber: plateNumber,
      vehicleModel: vehicleModel,
      vehicleColor: vehicleColor,
      vehicleType: vehicleType,
    );
    emit(VehicleFormUpdated(formData: updatedData));
  }

  // Step 3 - Legal Details
  void updateStep3({
    String? licenseNumber,
    String? orNumber,
    String? crNumber,
  }) {
    final updatedData = formData.copyWith(
      licenseNumber: licenseNumber,
      orNumber: orNumber,
      crNumber: crNumber,
    );
    emit(VehicleFormUpdated(formData: updatedData));
  }

  // Step 4 - Address Information
  void updateStep4({
    String? region,
    String? province,
    String? municipality,
    String? barangay,
    String? purokStreet,
  }) {
    final updatedData = formData.copyWith(
      region: region,
      province: province,
      municipality: municipality,
      barangay: barangay,
      purokStreet: purokStreet,
    );
    emit(VehicleFormUpdated(formData: updatedData));
  }

  // Reset form data
  void resetForm() {
    emit(const VehicleFormInitial());
  }
}
