import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/core/theme/app_icon_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/date_time_formatter.dart';
import 'package:cvms_desktop/core/utils/form_validator.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/auth/data/auth_repository.dart';
import 'package:cvms_desktop/features/auth/data/user_repository.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/bloc/vehicle_logs_cubit.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/models/vehicle_log_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
              TypeAheadField<Map<String, dynamic>>(
                controller: _controllers["Owner Name"],
                suggestionsCallback: (pattern) async {
                  if (pattern.isEmpty) return [];
                  final cubit = context.read<VehicleLogsCubit>();
                  return await cubit.getAvailableVehicles(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion["ownerName"]),
                    subtitle: Text(
                      "${suggestion["plateNumber"]} - ${suggestion["vehicleModel"]}",
                    ),
                  );
                },
                onSelected: (selected) {
                  _controllers["Vehicle ID"]!.text = selected["docId"];
                  _controllers["Owner Name"]!.text = selected["ownerName"];
                  _controllers["Plate Number"]!.text = selected["plateNumber"];
                  _controllers["Vehicle Model"]!.text =
                      selected["vehicleModel"];
                  _controllers["Status"]!.text = "inside";
                },
                builder: (context, _, focusNode) {
                  return CustomTextField(
                    labelText: "Owner Name",
                    controller: _controllers["Owner Name"],
                    focusNode: focusNode,
                    validator:
                        (val) =>
                            FormValidator.validateRequired(val, "Owner Name"),
                  );
                },
              ),

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

  void _handleSave(BuildContext context) async {
    final authRepo = AuthRepository();
    final userRepo = UserRepository();
    final uid = authRepo.uid;
    final updatedBy =
        uid != null
            ? (await userRepo.getUserFullname(uid)) ?? "Unknown"
            : "Unknown";

    if (!_formKey.currentState!.validate()) return;

    final status = _controllers['Status']?.text.trim() ?? "";
    final now = Timestamp.now();

    Timestamp? timeIn = now;
    Timestamp? timeOut;
    int? durationMinutes;

    if (status.toLowerCase() == "outside") {
      timeOut = now;
      durationMinutes = timeOut.toDate().difference(timeIn.toDate()).inMinutes;
    }

    final entry = VehicleLogModel(
      logID: "",
      vehicleID: _controllers["Vehicle ID"]?.text ?? "",
      ownerName: _controllers["Owner Name"]?.text ?? "",
      plateNumber: _controllers["Plate Number"]?.text ?? "",
      vehicleModel: _controllers["Vehicle Model"]?.text ?? "",
      timeIn: timeIn,
      timeOut: timeOut,
      updatedBy: updatedBy,
      status: status,
      durationMinutes: durationMinutes,
    );

    widget.onSave(entry);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
