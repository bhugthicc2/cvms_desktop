import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_dropdown.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/user_management/bloc/user_cubit.dart';
import 'package:cvms_desktop/features/user_management/bloc/user_management_bloc.dart';
import 'package:cvms_desktop/features/user_management/widgets/dialogs/custom_add_dialog.dart';
import 'package:cvms_desktop/features/user_management/widgets/buttons/custom_user_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app/search_field.dart';

class TableHeader extends StatelessWidget {
  final TextEditingController? searchController;

  const TableHeader({super.key, this.searchController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (searchController != null)
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: SearchField(controller: searchController!),
                ),
              ),
            Spacing.horizontal(size: AppSpacing.medium),
            Expanded(
              child: SizedBox(
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomDropdown(
                        items: ['All', 'CDRRMSU Admin', 'Security Personnel'],
                        initialValue: 'All',
                        onChanged: (value) {
                          context.read<UserCubit>().filterByRole(value);
                        },
                      ),
                    ),
                    Spacing.horizontal(size: AppSpacing.medium),
                    Expanded(
                      child: CustomUserButton(
                        label:
                            state.isBulkModeEnabled
                                ? "Exit Bulk Mode"
                                : "Bulk Mode",
                        backgroundColor:
                            state.isBulkModeEnabled
                                ? AppColors.warning
                                : AppColors.primary,
                        onPressed: () {
                          context.read<UserCubit>().toggleBulkMode();
                        },
                      ),
                    ),
                    Spacing.horizontal(size: AppSpacing.medium),
                    Expanded(
                      child: CustomUserButton(
                        label: "Add User",
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) => BlocProvider.value(
                              value: context.read<UserManagementBloc>(),
                              child: const CustomAddDialog(
                                title: "Add New User",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
