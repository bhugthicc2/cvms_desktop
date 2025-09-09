import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/app/custom_icon_button.dart';
import 'package:cvms_desktop/features/violation_management/bloc/violation_cubit.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_model.dart';
import 'package:cvms_desktop/features/violation_management/widgets/dialogs/custom_delete_dialog.dart';
import 'package:cvms_desktop/features/violation_management/widgets/dialogs/custom_edit_dialog.dart';
import 'package:cvms_desktop/features/violation_management/widgets/dialogs/custom_status_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ViolationActions extends StatelessWidget {
  final int rowIndex;
  final BuildContext context;
  final String plateNumber;
  final bool isResolved;
  final ViolationEntry violationEntry;

  const ViolationActions({
    super.key,
    required this.rowIndex,
    required this.context,
    required this.plateNumber,
    required this.isResolved,
    required this.violationEntry,
  });

  void _showStatusUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => CustomUpdateStatusDialog(
            currentStatus: violationEntry.status,
            newStatus: isResolved ? 'pending' : 'resolved',
            title: "Confirm update status",
            onUpdate: () {
              Navigator.of(dialogContext).pop();

              context.read<ViolationCubit>().toggleViolationStatus(
                violationEntry,
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomIconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder:
                  (_) => const CustomEditDialog(
                    title: "Edit Violation Information ",
                  ),
            );
          },
          icon: PhosphorIconsRegular.notePencil,
          iconColor: AppColors.primary,
        ),

        CustomIconButton(
          onPressed: () {
            _showStatusUpdateDialog(context);
          },
          iconSize: 17,
          icon: PhosphorIconsFill.checkCircle,
          iconColor: isResolved ? AppColors.success : AppColors.grey,
        ),
        CustomIconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder:
                  (_) => CustomDeleteDialog(
                    title: "Confirm Delete",
                    plateNumber: plateNumber,
                  ),
            );
          },
          icon: PhosphorIconsRegular.trash,
          iconColor: AppColors.error,
        ),
      ],
    );
  }
}
