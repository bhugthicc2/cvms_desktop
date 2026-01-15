import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/app/custom_button.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';

class AddVehicleStep2 extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const AddVehicleStep2({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Step 2'),
        Spacing.vertical(size: AppFontSizes.medium),
        CustomButton(text: 'Next', onPressed: onNext),
        Spacing.vertical(size: AppFontSizes.medium),
        CustomButton(text: 'Back', onPressed: onBack),
      ],
    ); //todo
  }
}
