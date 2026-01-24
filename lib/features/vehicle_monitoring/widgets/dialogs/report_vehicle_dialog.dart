import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown_field.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ReportVehicleDialog extends StatefulWidget {
  final String title;
  final String vehicleId;
  final ValueChanged<String> onSubmit; // callback sends selected violation

  const ReportVehicleDialog({
    super.key,
    required this.title,
    required this.vehicleId,
    required this.onSubmit,
  });

  @override
  State<ReportVehicleDialog> createState() => _ReportVehicleDialogState();
}

class _ReportVehicleDialogState extends State<ReportVehicleDialog> {
  String? _selectedViolationType;
  final TextEditingController _otherCtrl = TextEditingController();

  @override
  void dispose() {
    _otherCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      headerColor: AppColors.error,
      icon: PhosphorIconsRegular.warning,
      width: 500,
      btnTxt: 'Report',
      onSubmit: () {
        if (_selectedViolationType == null || _selectedViolationType!.isEmpty) {
          return;
        }

        final violationType =
            _selectedViolationType == 'Other'
                ? _otherCtrl.text.trim().isEmpty
                    ? 'Other'
                    : _otherCtrl.text.trim()
                : _selectedViolationType!;

        widget.onSubmit(violationType); //  only send the selected type
        Navigator.pop(context);
      },
      title: widget.title,
      height: 280,
      isExpanded: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomDropdownField<String>(
            labelText: "Violation Type",
            hintText: "Select violation",
            value: _selectedViolationType,
            onChanged: (val) => setState(() => _selectedViolationType = val),
            items: const [
              DropdownItem(
                value: 'Parking Violation',
                label: 'Parking Violation',
              ),
              DropdownItem(value: 'Speed Violation', label: 'Speed Violation'),
              DropdownItem(
                value: 'No Valid Registration',
                label: 'No Valid Registration',
              ),
              DropdownItem(
                value: 'No Valid License',
                label: 'No Valid License',
              ),
              DropdownItem(
                value: 'Reckless Driving',
                label: 'Reckless Driving',
              ),
              DropdownItem(
                value: 'Unauthorized Entry',
                label: 'Unauthorized Entry',
              ),
              DropdownItem(
                value: 'Improper Parking',
                label: 'Improper Parking',
              ),
              DropdownItem(
                value: 'Vehicle Modification',
                label: 'Vehicle Modification',
              ),
              DropdownItem(value: 'Other', label: 'Other'),
            ],
          ),
          Spacing.vertical(size: AppSpacing.medium),
          if (_selectedViolationType == 'Other')
            CustomTextField(
              labelText: 'Others (please specify...)',
              controller: _otherCtrl,
            ),
        ],
      ),
    );
  }
}
