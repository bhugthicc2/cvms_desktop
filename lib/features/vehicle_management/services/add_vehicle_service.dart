import 'package:flutter/material.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_form_cubit.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_cubit.dart';

/// Service layer that handles external operations for adding vehicles
/// Separated from UI and controller for better testability and single responsibility
class AddVehicleService {
  final VehicleFormCubit formCubit;
  final VehicleCubit vehicleCubit;

  AddVehicleService({required this.formCubit, required this.vehicleCubit});

  /// Saves the vehicle form data to Firestore
  /// Handles success/error feedback and navigation
  Future<VehicleSaveResult> saveVehicle(BuildContext context) async {
    try {
      // Convert form data to vehicle entry
      final formData = formCubit.formData;
      final vehicleEntry = formData.toVehicleEntry();

      // Save to Firestore
      await vehicleCubit.addVehicle(vehicleEntry);

      // Show success feedback
      if (context.mounted) {
        CustomSnackBar.show(
          context: context,
          message: 'Vehicle added successfully!',
          type: SnackBarType.success,
        );
      }

      // Schedule navigation back to list view
      await Future.delayed(const Duration(milliseconds: 1500));
      if (context.mounted) {
        vehicleCubit.backToList();
      }

      return VehicleSaveResult.success();
    } catch (e) {
      // Show error feedback
      if (context.mounted) {
        CustomSnackBar.show(
          context: context,
          message: 'Failed to add vehicle: ${e.toString()}',
          type: SnackBarType.error,
        );
      }

      return VehicleSaveResult.failure(e.toString());
    }
  }

  /// Validates that the form is ready for submission
  bool isFormReadyForSubmission() {
    final formData = formCubit.formData;
    return _isFormDataValid(formData);
  }

  /// Internal validation method for VehicleFormData
  bool _isFormDataValid(dynamic formData) {
    // Check required fields for each step
    if (formData.ownerName?.isEmpty ?? true) return false;
    if (formData.plateNumber?.isEmpty ?? true) return false;
    if (formData.vehicleModel?.isEmpty ?? true) return false;
    if (formData.licenseNumber?.isEmpty ?? true) return false;
    if (formData.region?.isEmpty ?? true) return false;
    if (formData.province?.isEmpty ?? true) return false;
    if (formData.municipality?.isEmpty ?? true) return false;
    if (formData.barangay?.isEmpty ?? true) return false;

    return true;
  }
}

/// Result type for vehicle save operations
class VehicleSaveResult {
  final bool success;
  final String? errorMessage;

  VehicleSaveResult._({required this.success, this.errorMessage});

  factory VehicleSaveResult.success() => VehicleSaveResult._(success: true);
  factory VehicleSaveResult.failure(String errorMessage) =>
      VehicleSaveResult._(success: false, errorMessage: errorMessage);
}
