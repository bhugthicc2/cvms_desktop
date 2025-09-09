import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/features/user_management/widgets/dialogs/custom_delete_dialog.dart';
import 'package:cvms_desktop/features/user_management/widgets/dialogs/custom_edit_dialog.dart';
import 'package:cvms_desktop/core/widgets/app/custom_icon_button.dart';
import 'package:cvms_desktop/features/user_management/widgets/dialogs/custom_reset_dialog.dart';
import 'package:cvms_desktop/features/user_management/bloc/user_management_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class UserActions extends StatelessWidget {
  final int rowIndex;
  final BuildContext context;
  final String email;
  final String uid;
  final String fullname;

  const UserActions({
    super.key,
    required this.rowIndex,
    required this.context,
    required this.email,
    required this.uid,
    required this.fullname,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomIconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder:
                  (_) =>
                      const CustomEditDialog(title: "Edit User Information "),
            );
          },
          icon: PhosphorIconsRegular.notePencil,
          iconColor: AppColors.primary,
        ),

        CustomIconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder:
                  (_) => CustomResetDialog(
                    title: "Confirm Reset Password",
                    email: email,
                  ),
            );
          },
          icon: PhosphorIconsFill.key,
          iconColor: AppColors.yellow,
        ),

        CustomIconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => BlocProvider.value(
                value: context.read<UserManagementBloc>(),
                child: CustomDeleteDialog(
                  title: "Confirm Delete", 
                  email: email,
                  uid: uid,
                  fullname: fullname,
                ),
              ),
            );
          },
          icon: PhosphorIconsRegular.trash,
          iconColor: AppColors.error,
        ),
      ],
    );
  }
}
