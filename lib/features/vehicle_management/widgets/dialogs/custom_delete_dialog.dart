import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomDeleteDialog extends StatelessWidget {
  final Function() onDelete;
  final String title;
  final int? selectedCount; // Add optional count for bulk operations

  const CustomDeleteDialog({
    super.key,
    required this.title,
    required this.onDelete,
    this.selectedCount, // Optional parameter for bulk delete
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
      child: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.medium),
        child: Center(
          child: Text(
            selectedCount != null && selectedCount! > 1
                ? 'Are you sure you want to delete $selectedCount selected vehicles?'
                : 'Are you sure you want to delete this vehicle?',
          ),
        ),
      ),
    );
  }

  void _handleDelete(BuildContext context) {
    onDelete();
    Navigator.of(context).pop();
  }
}
