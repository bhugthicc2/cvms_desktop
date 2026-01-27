import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/app/custom_icon_button.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_model.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ViolationActions extends StatelessWidget {
  final int rowIndex;
  final BuildContext context;
  final String plateNumber;
  final bool isConfirmed;
  final bool isDismissed;
  final ViolationEntry violationEntry;
  final VoidCallback onEdit;
  final VoidCallback onConfirm;
  final VoidCallback onReject;
  final VoidCallback onViewMore;
  final double dx;
  final Color hoverColor;
  final double radii;

  const ViolationActions({
    super.key,
    required this.rowIndex,
    required this.context,
    required this.plateNumber,
    required this.isConfirmed,
    required this.isDismissed,
    required this.violationEntry,
    required this.onEdit,
    required this.onConfirm,
    required this.onReject,
    required this.onViewMore,
    this.dx = 0,
    this.hoverColor = AppColors.primary,
    this.radii = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: CustomIconButton(
            dx: dx,
            hoverColor: hoverColor.withValues(alpha: 0.1),
            raddi: radii,
            onPressed: onEdit,
            icon: PhosphorIconsRegular.notePencil,
            iconColor: AppColors.primary,
          ),
        ),

        Expanded(
          child: CustomIconButton(
            dx: dx,
            hoverColor: hoverColor.withValues(alpha: 0.1),
            raddi: radii,
            onPressed: isConfirmed ? () {} : onConfirm,
            iconSize: 17,
            icon: PhosphorIconsFill.checkCircle,
            iconColor: isConfirmed ? AppColors.success : AppColors.grey,
          ),
        ),
        Expanded(
          child: CustomIconButton(
            dx: dx,
            hoverColor: hoverColor.withValues(alpha: 0.1),
            raddi: radii,
            onPressed: isDismissed ? () {} : onReject,
            icon: PhosphorIconsFill.xCircle,
            iconColor:
                isDismissed
                    ? AppColors.grey
                    : AppColors.error.withValues(alpha: 0.5),
          ),
        ),

        Expanded(
          child: CustomIconButton(
            dx: dx,
            hoverColor: hoverColor.withValues(alpha: 0.1),
            raddi: radii,
            onPressed: onViewMore,
            icon: PhosphorIconsBold.dotsThreeVertical,
            iconColor: AppColors.black,
          ),
        ),
      ],
    );
  }
}
