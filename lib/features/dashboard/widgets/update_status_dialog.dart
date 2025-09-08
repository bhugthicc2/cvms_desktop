import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';

class UpdateStatusDialog extends StatelessWidget {
  const UpdateStatusDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      mainContentPadding: 0,
      height: 250,
      width: 600,
      title: 'Update Vehicle Status',
      onSubmit: () {},
      btnTxt: 'Update',
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Update selected entries and select a status to update',
              style: TextStyle(
                fontSize: AppFontSizes.large,
                fontWeight: FontWeight.w600,
                color: AppColors.grey,
              ),
            ),
            Spacing.horizontal(),
            CustomDropdownField(
              //todo
              hintText: 'Select Status',
              labelText: 'Entry Status',
              items: [
                DropdownItem(value: 'inside', label: 'Inside'),
                DropdownItem(value: 'outside', label: 'Outside'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
