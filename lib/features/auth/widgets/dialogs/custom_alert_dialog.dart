import 'package:flutter/material.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';

class CustomAlertDialog extends StatefulWidget {
  final VoidCallback onCancel;
  final Future<void> Function() onSubmit;
  final String title;
  final String message;
  final String btnTxt;

  const CustomAlertDialog({
    super.key,
    required this.onCancel,
    required this.onSubmit,
    required this.title,
    required this.message,
    required this.btnTxt,
  });

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  bool _isLoading = false;

  Future<void> _handleSubmit() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      await widget.onSubmit();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Operation failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      backgroundColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      titlePadding: EdgeInsets.zero,
      actionsPadding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
          color: AppColors.error,
        ),
        child: Text(
          widget.title,
          style: const TextStyle(
            fontSize: AppFontSizes.xxLarge,

            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
      content: Text(
        widget.message,
        style: const TextStyle(
          fontSize: AppFontSizes.medium,
          color: AppColors.grey,
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : widget.onCancel,
          style: TextButton.styleFrom(
            backgroundColor: AppColors.grey.withValues(alpha: 0.2),
            foregroundColor: AppColors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: const Text('Cancel'),
        ),

        ElevatedButton(
          onPressed: _isLoading ? null : _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child:
              _isLoading
                  ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.btnTxt,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                  : Text(
                    widget.btnTxt,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
        ),
      ],
    );
  }
}
