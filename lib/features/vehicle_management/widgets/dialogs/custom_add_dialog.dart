import 'package:cvms_desktop/features/vehicle_management/widgets/forms/custom_form_dialog.dart';
import 'package:flutter/material.dart';

class CustomAddDialog extends VehicleFormDialog {
  const CustomAddDialog({
    super.key,
    required super.title,
    required super.onSave,
  });

  @override
  State<CustomAddDialog> createState() =>
      VehicleFormDialogState<CustomAddDialog>();
}
