import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown_field.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_cubit.dart';
import 'package:cvms_desktop/features/vehicle_management/models/vehicle_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomReportDialog extends StatefulWidget {
  final String title;
  final VehicleEntry vehicleEntry;

  const CustomReportDialog({
    super.key,
    required this.title,
    required this.vehicleEntry,
  });

  @override
  State<CustomReportDialog> createState() => _CustomReportDialogState();
}

class _CustomReportDialogState extends State<CustomReportDialog> {
  final TextEditingController _reasonController = TextEditingController();
  String? _selectedViolation;
  bool _isSubmitting = false;
  bool _canSubmit = false;

  final List<String> _violationTypes = [
    'Parking Violation',
    'Speed Violation',
    'No Valid Registration',
    'No Valid License',
    'Reckless Driving',
    'Unauthorized Entry',
    'Improper Parking',
    'Vehicle Modification',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _reasonController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _reasonController.removeListener(_validateForm);
    _reasonController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final canSubmit =
        _selectedViolation != null &&
        _selectedViolation!.isNotEmpty &&
        (_selectedViolation != 'Other' ||
            _reasonController.text.trim().isNotEmpty);

    if (canSubmit != _canSubmit) {
      setState(() => _canSubmit = canSubmit);
    }
  }

  Future<void> _submitReport() async {
    if (!_canSubmit) return;

    setState(() => _isSubmitting = true);

    try {
      final violationType =
          _selectedViolation == 'Other'
              ? _reasonController.text.trim()
              : _selectedViolation!;

      await context.read<VehicleCubit>().reportViolation(
        vehicle: widget.vehicleEntry,
        violationType: violationType,
        reason:
            _selectedViolation == 'Other'
                ? _reasonController.text.trim()
                : null,
      );

      if (mounted) {
        CustomSnackBar.show(
          context: context,
          message:
              'Violation report submitted for ${widget.vehicleEntry.plateNumber}',
          type: SnackBarType.success,
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.show(
          context: context,
          message: 'Error submitting report: ${e.toString()}',
          type: SnackBarType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      headerColor: AppColors.error,
      icon: PhosphorIconsRegular.warning,
      width: 500,
      btnTxt: _isSubmitting ? 'Submitting...' : 'Submit Report',
      onSubmit: (_canSubmit && !_isSubmitting) ? _submitReport : null,
      title: widget.title,
      height: 260,
      isExpanded: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Do you want to report ${widget.vehicleEntry.plateNumber}?',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Spacing.vertical(),
          CustomDropdownField(
            labelText: 'Violation*',
            hintText: 'Select violation type',
            items:
                _violationTypes
                    .map((e) => DropdownItem(label: e, value: e))
                    .toList(),
            onChanged: (value) {
              setState(() {
                _selectedViolation = value;
                if (value != 'Other') {
                  _reasonController.clear();
                }
              });
              _validateForm();
            },
          ),
          Spacing.vertical(),
          if (_selectedViolation == 'Other')
            CustomTextField(
              labelText: 'Others (Please specify)*',
              controller: _reasonController,
              maxLines: 3,
              hintText: 'Please specify the violation type...',
            ),
        ],
      ),
    );
  }
}
