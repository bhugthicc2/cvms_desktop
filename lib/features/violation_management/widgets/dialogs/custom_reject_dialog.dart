import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_enums.dart';
import 'package:flutter/material.dart';

class CustomRejectDialog extends StatefulWidget {
  final ViolationStatus currentStatus;
  final void Function() onReject;

  const CustomRejectDialog({
    super.key,
    required this.currentStatus,
    required this.onReject,
  });

  @override
  State<CustomRejectDialog> createState() => _CustomRejectDialogState();
}

class _CustomRejectDialogState extends State<CustomRejectDialog> {
  bool _isSubmitting = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Reject Violation',
      btnTxt: _isSubmitting ? 'Rejecting...' : 'Reject',
      onSubmit:
          _isSubmitting
              ? null
              : () {
                setState(() {
                  _isSubmitting = true;
                });

                try {
                  widget.onReject();
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
            'Are you sure you want to reject this violation?',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Text(
            'This will change the violation status from "${widget.currentStatus.label}" to "Dismissed".',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_outlined,
                  color: Colors.red.shade700,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Rejected violations will be marked as invalid and no sanctions will be applied.',
                    style: TextStyle(fontSize: 12, color: Colors.red.shade700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
