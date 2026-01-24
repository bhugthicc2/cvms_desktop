import 'package:cvms_desktop/core/theme/app_icon_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/date_time_formatter.dart';
import 'package:cvms_desktop/core/utils/form_validator.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/models/vehicle_log_model.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomAddDialog extends StatefulWidget {
  final String title;
  final Function(VehicleLogModel) onSave;

  const CustomAddDialog({super.key, required this.title, required this.onSave});

  @override
  State<CustomAddDialog> createState() => _CustomFormDialogState();
}

class _CustomFormDialogState extends State<CustomAddDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  final Map<String, TextEditingController> _controllers = {
    "Vehicle ID": TextEditingController(),
    "Owner Name": TextEditingController(),
    "Vehicle Model": TextEditingController(),
    "Plate Number": TextEditingController(),
    "Status": TextEditingController(),
  };

  late final TextEditingController _createdAtController;

  @override
  void initState() {
    super.initState();
    _createdAtController = TextEditingController(
      text: DateTimeFormatter.formatFull(DateTime.now()),
    );
  }

  @override
  void dispose() {
    _createdAtController.dispose();
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
      ["Vehicle ID", "Vehicle Model"],
      ["Plate Number", ""],
    ];

    return CustomDialog(
      icon: PhosphorIconsBold.motorcycle,
      btnTxt: 'Save',
      onSubmit: _isFormValid ? () => _handleSave(context) : null,
      title: widget.title,
      height: screenHeight * 0.6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          onChanged: _validateForm,
          child: Column(
            children: [
              /// VEHICLE ID AUTOSUGGEST FIELD
              Spacing.vertical(size: AppSpacing.medium),

              /// OTHER FIELDS
              for (var pair in fieldPairs) ...[
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        labelText: pair[0],
                        controller:
                            _controllers[pair[0]] ?? TextEditingController(),
                        validator:
                            (val) =>
                                FormValidator.validateRequired(val, pair[0]),
                      ),
                    ),
                    if (pair[1].isNotEmpty) ...[
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
                      labelText: 'Status',
                      controller:
                          _controllers['Status'] ?? TextEditingController(),
                      validator:
                          (val) =>
                              FormValidator.validateRequired(val, 'Status'),
                    ),
                  ),
                  Spacing.horizontal(size: AppIconSizes.medium),
                  Expanded(
                    child: CustomTextField(
                      labelText: 'Created At',
                      controller: _createdAtController,
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

  void _handleSave(BuildContext context) async {}
}

// TODO: CustomAddDialog is disabled due to vehicle_logs refactor
// This dialog must be redesigned to return vehicleId + action,
// not construct VehicleLogModel directly.
