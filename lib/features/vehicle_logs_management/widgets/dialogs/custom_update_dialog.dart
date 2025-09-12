import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';

class CustomUpdateDialog extends StatefulWidget {
  final Function(String status) onUpdate;

  const CustomUpdateDialog({super.key, required this.onUpdate});

  @override
  State<CustomUpdateDialog> createState() => _CustomUpdateDialogState();
}

class _CustomUpdateDialogState extends State<CustomUpdateDialog> {
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      mainContentPadding: 0,
      height: 250,
      width: 600,
      title: "Update Vehicle Log's Status",
      onSubmit:
          _selectedStatus == null
              ? null
              : () {
                widget.onUpdate(_selectedStatus!);
                Navigator.of(context).pop();
              },
      btnTxt: 'Update',
      child: Padding(
        padding: const EdgeInsets.all(20.0),
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
            Spacing.vertical(),
            CustomDropdownField(
              hintText: 'Select Status',
              labelText: 'Entry Status',
              items: const [
                DropdownItem(value: 'inside', label: 'Inside'),
                DropdownItem(value: 'outside', label: 'Outside'),
              ],
              onChanged: (value) {
                setState(() => _selectedStatus = value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
