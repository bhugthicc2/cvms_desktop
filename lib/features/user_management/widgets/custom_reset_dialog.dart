import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomResetDialog extends StatelessWidget {
  final String email;
  final String title;
  const CustomResetDialog({
    super.key,
    required this.title,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      isAlert: true,
      headerColor: AppColors.error,
      btnTxt: 'Reset',
      onSave: () {},
      title: title,
      height: 200,
      width: 500,
      icon: PhosphorIconsFill.key,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
          'Are you sure you want to reset the password for $email? A password reset link will be sent to this user’s email after clicking the Reset button.',
          style: TextStyle(fontFamily: 'Sora'),
        ),
      ),
    );
  }
}
