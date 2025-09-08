import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomDeleteDialog extends StatelessWidget {
  final Function() onDelete;
  final String title;

  const CustomDeleteDialog({
    super.key,
    required this.title,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      headerColor: AppColors.error,
      icon: PhosphorIconsRegular.qrCode,
      width: 500,
      btnTxt: 'Yes',
      onSubmit: () => _handleDelete(context),
      title: title,
      height: 200,
      isExpanded: true,
      child: Center(
        child: Text('Are you sure you want to delete this vehicle?'),
      ),
    );
  }

  void _handleDelete(BuildContext context) {
    onDelete();
    Navigator.of(context).pop();
  }
}
