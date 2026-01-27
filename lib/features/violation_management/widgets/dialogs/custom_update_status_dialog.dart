import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown_field.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_enums.dart';
import 'package:flutter/material.dart';

class CustomUpdateStatusDialog extends StatefulWidget {
  final ViolationStatus currentStatus;
  final void Function(ViolationStatus) onConfirm;

  const CustomUpdateStatusDialog({
    super.key,
    required this.currentStatus,
    required this.onConfirm,
  });

  @override
  State<CustomUpdateStatusDialog> createState() =>
      _CustomUpdateStatusDialogState();
}

class _CustomUpdateStatusDialogState extends State<CustomUpdateStatusDialog> {
  late ViolationStatus _selected;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.currentStatus;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Update Violation Status',
      btnTxt: _isSubmitting ? 'Updating...' : 'Confirm',
      onSubmit:
          _isSubmitting
              ? null
              : () {
                setState(() {
                  _isSubmitting = true;
                });

                try {
                  widget.onConfirm(_selected);
                } catch (e) {
                  // Reset submitting state on error
                  if (mounted) {
                    setState(() {
                      _isSubmitting = false;
                    });
                  }
                }
              },
      width: 500,
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select new status'),
          const SizedBox(height: 12),
          CustomDropdownField<ViolationStatus>(
            value: _selected,
            hintText: 'Select status',
            isExpanded: true,
            enabled: !_isSubmitting,
            items:
                ViolationStatus.values.map((status) {
                  return DropdownItem(value: status, label: status.label);
                }).toList(),
            onChanged:
                _isSubmitting
                    ? null
                    : (v) {
                      if (v != null) {
                        setState(() {
                          _selected = v;
                        });
                      }
                    },
          ),
        ],
      ),
    );
  }
}
