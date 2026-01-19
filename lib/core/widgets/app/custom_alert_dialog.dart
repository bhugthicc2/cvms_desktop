import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final Widget child;
  final String title;
  const CustomAlertDialog({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shadowColor: AppColors.donutBlue.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      title: Text(title),
      content: SizedBox(height: 480, width: 530, child: child),
    );
  }
}
