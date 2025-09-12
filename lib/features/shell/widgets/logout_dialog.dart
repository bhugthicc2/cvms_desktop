import 'package:cvms_desktop/features/auth/widgets/dialogs/custom_alert_dialog.dart';
import 'package:flutter/material.dart';

class LogoutDialog {
  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Confirm Logout',
          message: 'Are you sure you want to logout?',
          btnTxt: 'Yes',
          onCancel: () => Navigator.of(context).pop(false),
          onSubmit: () async {
            await Future.delayed(const Duration(seconds: 2));
            if (context.mounted) {
              Navigator.of(context).pop(true);
            }
          },
        );
      },
    );

    return result ?? false;
  }
}
