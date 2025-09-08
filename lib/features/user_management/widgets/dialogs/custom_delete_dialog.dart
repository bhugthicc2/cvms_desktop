import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomDeleteDialog extends StatelessWidget {
  final String title;
  final String email;
  const CustomDeleteDialog({
    super.key,
    required this.title,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      isAlert: true,
      headerColor: AppColors.error,
      icon: PhosphorIconsRegular.qrCode,
      width: 500,
      btnTxt: 'Yes',
      onSubmit: () {},
      title: title,
      height: 200,
      isExpanded: true,
      child: Center(
        child: Text('Are you sure you want to delete this $email?'),
      ),
    );
  }
}
