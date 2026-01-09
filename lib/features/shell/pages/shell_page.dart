import 'package:cvms_desktop/features/auth/bloc/current_user_cubit.dart';
import 'package:cvms_desktop/features/auth/data/auth_repository.dart';
import 'package:cvms_desktop/features/auth/data/user_repository.dart';
import 'package:cvms_desktop/features/shell/widgets/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/core/routes/app_routes.dart';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/features/auth/bloc/auth_bloc.dart';
import 'package:cvms_desktop/features/auth/bloc/auth_event.dart';
import 'package:cvms_desktop/features/auth/bloc/auth_state.dart';
import 'package:cvms_desktop/features/shell/bloc/shell_cubit.dart';
import 'package:cvms_desktop/features/shell/config/shell_navigation_config.dart';
import 'package:cvms_desktop/features/shell/widgets/custom_header.dart';
import 'package:cvms_desktop/features/shell/widgets/custom_sidebar.dart';

class ShellPage extends StatelessWidget {
  const ShellPage({super.key});

  void _handleLogout(BuildContext context) async {
    final confirmed = await LogoutDialog.show(context);
    if (confirmed) {
      // ignore: use_build_context_synchronously
      context.read<AuthBloc>().add(SignOutEvent());
    }
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    if (state is SignOutSuccess) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.signIn, (_) => false);
      CustomSnackBar.show(
        context: context,
        message: "Signed out successfully!",
        type: SnackBarType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ShellCubit()),
        BlocProvider(
          create:
              (_) => CurrentUserCubit(
                authRepository: AuthRepository(),
                userRepository: UserRepository(),
              ),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: _handleAuthState,
        child: BlocBuilder<ShellCubit, ShellState>(
          builder: (context, state) {
            final titles = ShellNavigationConfig.titles;

            return Scaffold(
              body: Row(
                children: [
                  CustomSidebar(
                    isExpanded: state.isExpanded,
                    selectedIndex: state.selectedIndex,
                    onItemSelected:
                        (index) => context.read<ShellCubit>().selectPage(index),
                    onToggle: () => context.read<ShellCubit>().toggleSidebar(),
                    onLogout: () => _handleLogout(context),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        BlocBuilder<CurrentUserCubit, CurrentUserState>(
                          builder: (context, userState) {
                            return CustomHeader(
                              currentUser: userState.fullname ?? "Guest",
                              title: titles[state.selectedIndex],
                              onMenuPressed:
                                  () =>
                                      context
                                          .read<ShellCubit>()
                                          .toggleSidebar(),
                            );
                          },
                        ),
                        //body
                        Expanded(
                          child: ShellNavigationConfig.getPage(
                            state.selectedIndex,
                            context,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
