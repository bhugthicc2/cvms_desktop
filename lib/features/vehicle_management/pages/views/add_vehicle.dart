import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/card_decor.dart';
import 'package:cvms_desktop/core/widgets/app/custom_button.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';

class AddVehicleView extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onCancel;
  const AddVehicleView({
    super.key,
    required this.onNext,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: Container(
        decoration: cardDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Text('Step 1')),
            Spacing.vertical(size: AppFontSizes.medium),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(text: 'Back', onPressed: onCancel),
                  ),
                  Spacing.horizontal(size: AppFontSizes.medium),
                  Expanded(
                    child: CustomButton(text: 'Next', onPressed: onNext),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
