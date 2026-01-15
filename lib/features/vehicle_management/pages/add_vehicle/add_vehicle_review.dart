import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/app/custom_button.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';

class AddVehicleReview extends StatelessWidget {
  final VoidCallback onSubmit;
  final VoidCallback onBack;
  const AddVehicleReview({
    super.key,
    required this.onSubmit,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Review'),
        Spacing.vertical(size: AppFontSizes.medium),
        CustomButton(text: 'Submit', onPressed: onSubmit),
        Spacing.vertical(size: AppFontSizes.medium),
        CustomButton(text: 'Back', onPressed: onBack),
      ],
    ); //todo
  }
}
