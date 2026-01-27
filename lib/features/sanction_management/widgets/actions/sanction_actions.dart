import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/app/custom_icon_button.dart';
import 'package:cvms_desktop/features/sanction_management/models/saction_model.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SanctionActions extends StatelessWidget {
  final int rowIndex;
  final BuildContext context;
  final Sanction sanctionEntry;
  final VoidCallback? onView;

  final double dx;
  final Color hoverColor;
  final double radii;

  const SanctionActions({
    super.key,
    required this.rowIndex,
    required this.context,
    required this.sanctionEntry,
    this.onView,

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
            onPressed: onView ?? () {},
            icon: PhosphorIconsRegular.eye,
            iconColor: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
