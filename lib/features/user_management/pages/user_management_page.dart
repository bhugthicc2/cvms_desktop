import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/features/user_management/bloc/user_cubit.dart';
import 'package:cvms_desktop/features/user_management/bloc/user_management_bloc.dart';
import 'package:cvms_desktop/features/user_management/models/user_model.dart';
import 'package:cvms_desktop/features/user_management/widgets/tables/user_table.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<UserCubit>().listenUsers();

    searchController.addListener(() {
      context.read<UserCubit>().filterEntries(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greySurface,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: MultiBlocListener(
          listeners: [
            BlocListener<UserCubit, UserState>(
              listener: (context, state) {
                if (state.errorMessage != null) {
                  CustomSnackBar.show(
                    context: context,
                    message: state.errorMessage!,
                    type: SnackBarType.error,
                  );
                  context.read<UserCubit>().clearError();
                }
              },
            ),
            BlocListener<UserManagementBloc, UserManagementState>(
              listener: (context, state) {
                if (state is UserManagementSuccess) {
                  CustomSnackBar.show(
                    context: context,
                    message: state.message,
                    type: SnackBarType.success,
                  );
                  context.read<UserCubit>().loadUsers();
                } else if (state is UserManagementError) {
                  CustomSnackBar.show(
                    context: context,
                    message: state.message,
                    type: SnackBarType.error,
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              if (state.isLoading && state.allEntries.isEmpty) {
                return Skeletonizer(
                  enabled: state.isLoading,
                  child: UserTable(
                    title: "User Management",
                    entries: List.generate(5, (index) => UserEntry.sample()),
                    searchController: searchController,
                  ),
                );
              }

              return UserTable(
                title: "User Management",
                entries: state.filteredEntries,
                searchController: searchController,
              );
            },
          ),
        ),
      ),
    );
  }
}
