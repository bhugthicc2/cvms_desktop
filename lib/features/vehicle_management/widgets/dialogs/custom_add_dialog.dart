import 'package:cvms_desktop/core/theme/app_icon_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/date_time_formatter.dart';
import 'package:cvms_desktop/core/utils/form_validator.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/models/vehicle_entry.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomAddDialog extends StatefulWidget {
  final String title;
  final Function(VehicleEntry) onSave;
  const CustomAddDialog({super.key, required this.title, required this.onSave});

  @override
  State<CustomAddDialog> createState() => _CustomFormDialogState();
}

class _CustomFormDialogState extends State<CustomAddDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  final Map<String, TextEditingController> _controllers = {
    "Owner Name": TextEditingController(),
    "School ID": TextEditingController(),
    "Department": TextEditingController(),
    "Plate Number": TextEditingController(),
    "Vehicle Type": TextEditingController(),
    "Vehicle Model": TextEditingController(),
    "Vehicle Color": TextEditingController(),
    "License Number": TextEditingController(),
    "OR Number": TextEditingController(),
    "CR Number": TextEditingController(),
    "Status": TextEditingController(),
  };

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (_isFormValid != isValid) {
      setState(() => _isFormValid = isValid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final fieldPairs = [
      ["Owner Name", "School ID"],
      ["Department"],
      ["Plate Number", "Vehicle Type"],
      ["Vehicle Model", "Vehicle Color"],
      ["License Number", "OR Number"],
      ["CR Number", "Status"],
    ];

    return CustomDialog(
      icon: PhosphorIconsBold.motorcycle,
      btnTxt: 'Save',
      onSubmit: _isFormValid ? () => _handleSave(context) : null,
      title: widget.title,
      height: screenHeight * 0.7,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          onChanged: _validateForm,
          child: Column(
            children: [
              Spacing.vertical(size: AppSpacing.small),
              for (var pair in fieldPairs) ...[
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        labelText: pair[0],
                        controller: _controllers[pair[0]]!,
                        validator:
                            (val) =>
                                FormValidator.validateRequired(val, pair[0]),
                      ),
                    ),
                    if (pair.length > 1 && pair[1].isNotEmpty) ...[
                      Spacing.horizontal(size: AppIconSizes.medium),
                      Expanded(
                        child: CustomTextField(
                          labelText: pair[1],
                          controller: _controllers[pair[1]]!,
                          validator:
                              (val) =>
                                  FormValidator.validateRequired(val, pair[1]),
                        ),
                      ),
                    ],
                  ],
                ),
                Spacing.vertical(size: AppIconSizes.medium),
              ],

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      labelText: 'Created At',
                      controller: TextEditingController(
                        text: DateTimeFormatter.formatFull(DateTime.now()),
                      ),
                      enabled: false,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSave(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final entry = VehicleEntry(
      vehicleID: '',
      ownerName: _controllers["Owner Name"]!.text,
      schoolID: _controllers["School ID"]!.text,
      department: _controllers["Department"]!.text,
      plateNumber: _controllers["Plate Number"]!.text,
      vehicleType: _controllers["Vehicle Type"]!.text,
      vehicleModel: _controllers["Vehicle Model"]!.text,
      vehicleColor: _controllers["Vehicle Color"]!.text,
      licenseNumber: _controllers["License Number"]!.text,
      orNumber: _controllers["OR Number"]!.text,
      crNumber: _controllers["CR Number"]!.text,
      status:
          _controllers["Status"]!.text.isNotEmpty
              ? _controllers["Status"]!.text
              : "outside",

      createdAt: Timestamp.now(),
    );

    widget.onSave(entry);
    Navigator.of(context).pop();
  }
}
