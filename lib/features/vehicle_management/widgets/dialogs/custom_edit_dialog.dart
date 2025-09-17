import 'package:cvms_desktop/features/vehicle_management/widgets/forms/custom_form_dialog.dart';
import 'package:cvms_desktop/features/vehicle_management/models/vehicle_entry.dart';
import 'package:flutter/material.dart';

class CustomEditDialog extends VehicleFormDialog {
  final VehicleEntry vehicle;

  const CustomEditDialog({
    super.key,
    required super.title,
    required this.vehicle,
    required super.onSave,
  }) : super(initialEntry: vehicle);

  @override
  State<CustomEditDialog> createState() =>
      VehicleFormDialogState<CustomEditDialog>();
}
