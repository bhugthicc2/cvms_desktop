import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomUpdateStatusDialog extends StatelessWidget {
  final String title;
  final String currentStatus;
  final String newStatus;
  final VoidCallback onUpdate;
  const CustomUpdateStatusDialog({
    super.key,
    required this.title,
    required this.currentStatus,
    required this.newStatus,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      onSave: onUpdate,
      isAlert: true,
      headerColor: AppColors.primary,
      icon: PhosphorIconsRegular.qrCode,
      width: 500,
      btnTxt: 'Yes',

      title: title,
      height: 200,
      isExpanded: true,
      child: Center(
        child: Text(
          'Are you sure you want to update this $currentStatus into $newStatus?',
        ),
      ),
    );
  }
}
