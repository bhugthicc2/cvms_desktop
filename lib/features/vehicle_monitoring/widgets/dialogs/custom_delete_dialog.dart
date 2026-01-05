import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomDeleteDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;

  const CustomDeleteDialog({
    super.key,
    required this.title,
    required this.onConfirm,
    this.message = 'Are you sure you want to delete this item?',
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      headerColor: AppColors.error,
      icon: PhosphorIconsRegular.trash,
      width: 500,
      btnTxt: 'Yes',
      onSubmit: () {
        Navigator.pop(context);
        onConfirm();
      },
      title: title,
      height: 200,
      isExpanded: true,
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
