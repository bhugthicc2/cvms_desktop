import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
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
    return Column(
      children: [
        Text('Step 1'),
        Spacing.vertical(size: AppFontSizes.medium),
        CustomButton(text: 'Next', onPressed: onNext),
        Spacing.vertical(size: AppFontSizes.medium),
        CustomButton(text: 'Back', onPressed: onCancel),
      ],
    ); //todo
  }
}
