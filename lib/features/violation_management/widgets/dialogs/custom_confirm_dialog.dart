import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_enums.dart';
import 'package:flutter/material.dart';

class CustomConfirmDialog extends StatefulWidget {
  final ViolationStatus currentStatus;
  final void Function() onConfirm;

  const CustomConfirmDialog({
    super.key,
    required this.currentStatus,
    required this.onConfirm,
  });

  @override
  State<CustomConfirmDialog> createState() => _CustomConfirmDialogState();
}

class _CustomConfirmDialogState extends State<CustomConfirmDialog> {
  bool _isSubmitting = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Confirm Violation',
      btnTxt: _isSubmitting ? 'Confirming...' : 'Confirm',
      onSubmit:
          _isSubmitting
              ? null
              : () {
                setState(() {
                  _isSubmitting = true;
                });

                try {
                  widget.onConfirm();
                } catch (e) {
                  // Reset submitting state on error
                  if (mounted) {
                    setState(() {
                      _isSubmitting = false;
                    });
                  }
                }
              },
      width: 400,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Are you sure you want to confirm this violation?',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Text(
            'This will change the violation status from "${widget.currentStatus.label}" to "Confirmed".',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
