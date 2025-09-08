import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ChangePasswordDialog extends StatelessWidget {
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onSave;

  const ChangePasswordDialog({
    super.key,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'Change Password',
      icon: PhosphorIconsRegular.lock,
      width: 500,
      height: 600,
      btnTxt: 'Update Password',
      onSave: onSave,
      child: Column(
        children: [
          CustomTextField(
            controller: currentPasswordController,
            labelText: 'Current Password',
            obscureText: true,
            enableVisibilityToggle: true,
            prefixIcon: PhosphorIconsRegular.lock,
          ),
          Spacing.vertical(size: AppSpacing.medium),
          CustomTextField(
            controller: newPasswordController,
            labelText: 'New Password',
            obscureText: true,
            enableVisibilityToggle: true,
            prefixIcon: PhosphorIconsRegular.lock,
          ),
          Spacing.vertical(size: AppSpacing.medium),
          CustomTextField(
            controller: confirmPasswordController,
            labelText: 'Confirm New Password',
            obscureText: true,
            enableVisibilityToggle: true,
            prefixIcon: PhosphorIconsRegular.lock,
          ),
        ],
      ),
    );
  }
}
