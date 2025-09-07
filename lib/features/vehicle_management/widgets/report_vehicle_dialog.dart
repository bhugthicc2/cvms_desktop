import 'package:cvms_desktop/core/theme/app_colors.dart';

import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown_field.dart';
import 'package:cvms_desktop/core/widgets/app/custom_text_field.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ReportVehicleDialog extends StatelessWidget {
  final String title;
  const ReportVehicleDialog({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      headerColor: AppColors.error,
      icon: PhosphorIconsRegular.qrCode,
      width: 500,

      btnTxt: 'Report',
      onSave: () {},
      title: title,
      height: 280,
      isExpanded: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomDropdownField(
            labelText: 'Violation',
            hintText: 'Select violation',
            items: [],
          ),
          Spacing.vertical(),
          CustomTextField(labelText: 'Report Reason'),
        ],
      ),
    );
  }
}
