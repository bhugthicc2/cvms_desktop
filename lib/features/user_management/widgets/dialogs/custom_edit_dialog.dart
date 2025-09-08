import 'package:cvms_desktop/core/theme/app_icon_sizes.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomEditDialog extends StatelessWidget {
  final String title;
  const CustomEditDialog({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      btnTxt: 'Save',
      onSubmit: () {},
      title: title,
      height: 360,
      icon: PhosphorIconsBold.user,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            CustomTextField(labelText: 'Name', height: 55),
            Spacing.vertical(size: AppIconSizes.medium),
            CustomTextField(labelText: 'Email'),
            Spacing.vertical(size: AppIconSizes.medium),
            CustomTextField(labelText: 'Role'), //todo dropdown
          ],
        ),
      ),
    );
  }
}
