import 'package:cvms_desktop/core/theme/app_icon_sizes.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';

class CustomFormDialog extends StatelessWidget {
  final String title;
  const CustomFormDialog({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return CustomDialog(
      btnTxt: 'Save',
      onSave: () {},
      title: title,
      height: screenHeight * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextField(labelText: 'Fullname', height: 55),
                ),
                Spacing.horizontal(size: AppIconSizes.medium),
                Expanded(child: CustomTextField(labelText: 'School ID')),
              ],
            ),
            Spacing.vertical(size: AppIconSizes.medium),
            Row(
              children: [
                Expanded(child: CustomTextField(labelText: 'Gender')),
                Spacing.horizontal(size: AppIconSizes.medium),
                Expanded(child: CustomTextField(labelText: 'Contact Number')),
              ],
            ),
            Spacing.vertical(size: AppIconSizes.medium),
            Row(
              children: [
                Expanded(child: CustomTextField(labelText: 'Purok')),
                Spacing.horizontal(size: AppIconSizes.medium),
                Expanded(child: CustomTextField(labelText: 'Barangay')),
              ],
            ),
            Spacing.vertical(size: AppIconSizes.medium),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(labelText: 'City/Municipality'),
                ),
                Spacing.horizontal(size: AppIconSizes.medium),
                Expanded(child: CustomTextField(labelText: 'Province')),
              ],
            ),
            Spacing.vertical(size: AppIconSizes.medium),
            Row(
              children: [
                Expanded(child: CustomTextField(labelText: 'Parent/Guardian')),
                Spacing.horizontal(size: AppIconSizes.medium),
                Expanded(child: CustomTextField(labelText: 'Bithdate')),
              ],
            ),
            Spacing.vertical(size: AppIconSizes.medium),
            Row(
              children: [
                Expanded(child: CustomTextField(labelText: 'Course')),
                Spacing.horizontal(size: AppIconSizes.medium),
                Expanded(child: CustomTextField(labelText: 'Year Level')),
              ],
            ),
            Spacing.vertical(size: AppIconSizes.medium),

            Row(
              children: [
                Expanded(child: CustomTextField(labelText: 'Block')),
                Spacing.horizontal(size: AppIconSizes.medium),
                Expanded(
                  child: CustomTextField(
                    labelText: 'Enrollment Year & Semester',
                  ),
                ),
              ],
            ),
            Spacing.vertical(size: AppIconSizes.medium),

            Row(
              children: [
                Expanded(child: CustomTextField(labelText: 'License Number')),
                Spacing.horizontal(size: AppIconSizes.medium),
                Expanded(
                  child: CustomTextField(
                    labelText: 'issuing date & Expiry date',
                  ),
                ),
              ],
            ),
            Spacing.vertical(size: AppIconSizes.medium),
            Row(
              children: [
                Expanded(child: CustomTextField(labelText: 'Plate Number')),
                Spacing.horizontal(size: AppIconSizes.medium),
                Expanded(child: CustomTextField(labelText: 'Vehicle Model')),
              ],
            ),
            Spacing.vertical(size: AppIconSizes.medium),
          ],
        ),
      ),
    );
  }
}
