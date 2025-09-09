import 'package:cvms_desktop/core/theme/app_icon_sizes.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomAddDialog extends StatelessWidget {
  final String title;
  const CustomAddDialog({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      btnTxt: 'Save',
      onSubmit: () {},
      title: title,
      height: 480,
      icon: PhosphorIconsBold.warning,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: CustomTextField(labelText: 'Owner')),
                Spacing.horizontal(size: AppIconSizes.medium),
                Expanded(child: CustomTextField(labelText: 'Plate')),
              ],
            ),
            Spacing.vertical(size: AppIconSizes.medium),
            CustomTextField(labelText: 'Status'),

            ///todo dropdown for pending and resol
            Spacing.vertical(size: AppIconSizes.medium),
            CustomTextField(
              labelText: 'Violation',
            ), //todo dropdown for predefind items: improper parking, no mvp stickers
            Spacing.vertical(size: AppIconSizes.medium),
            CustomTextField(labelText: 'Others', height: 100, maxLines: 5),
          ],
        ),
      ),
    );
  }
}
