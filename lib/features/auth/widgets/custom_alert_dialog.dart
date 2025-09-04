import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';

class CustomAlertDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSubmit;
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
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      backgroundColor: AppColors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      titlePadding: EdgeInsets.zero,
      actionsPadding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      title: Container(
        padding: EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
          color: Colors.red,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: AppFontSizes.xxLarge,
            fontFamily: 'Sora',
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: AppFontSizes.medium,
          color: AppColors.grey,
        ),
      ),

      actions: [
        TextButton(
          onPressed: onCancel,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.grey.withValues(alpha: 0.2),
            foregroundColor: AppColors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: const Text('Cancel'),
        ),

        ElevatedButton(
          onPressed: onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text(
            btnTxt,
            style: TextStyle(fontFamily: 'Sora', fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
