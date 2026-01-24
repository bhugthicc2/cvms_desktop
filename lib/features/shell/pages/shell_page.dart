import 'package:cvms_desktop/core/bloc/sidebar_theme_cubit.dart';
import 'package:cvms_desktop/core/services/connectivity/connectivity_service.dart';
import 'package:cvms_desktop/core/theme/sidebar_theme.dart';
import 'package:cvms_desktop/features/auth/bloc/current_user_cubit.dart';
import 'package:cvms_desktop/features/auth/data/auth_repository.dart';
import 'package:cvms_desktop/features/auth/data/user_repository.dart';
import 'package:cvms_desktop/features/shell/bloc/connectivity_cubit.dart';
import 'package:cvms_desktop/features/shell/config/sidebar_active_style.dart';
import 'package:cvms_desktop/features/shell/scope/breadcrumb_scope.dart';
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
import 'package:cvms_desktop/features/profile/bloc/profile_cubit.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  final BreadcrumbController _breadcrumbController = BreadcrumbController();

  void _handleLogout(BuildContext context) async {
    final confirmed = await LogoutDialog.show(context);
    if (confirmed) {
      if (context.mounted) {
        context.read<AuthBloc>().add(SignOutEvent());
      }
    }
  }

  @override
  void dispose() {
    _breadcrumbController.dispose();
    super.dispose();
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
        BlocProvider(create: (_) => SidebarThemeCubit()),
        BlocProvider(create: (_) => ShellCubit()),
        BlocProvider(create: (_) => ConnectivityCubit(ConnectivityService())),
        BlocProvider(
          create:
              (_) => CurrentUserCubit(
                authRepository: AuthRepository(),
                userRepository: UserRepository(),
              ),
        ),
        BlocProvider(
          create:
              (_) => ProfileCubit(
                userRepository: UserRepository(),
                authRepository: AuthRepository(),
              ),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: _handleAuthState,
        child: BlocListener<ShellCubit, ShellState>(
          listenWhen: (previous, current) {
            return previous.selectedIndex != current.selectedIndex;
          },
          listener: (context, state) {
            _breadcrumbController.setBreadcrumbs(const []);
          },
          child: BlocBuilder<ShellCubit, ShellState>(
            builder: (context, state) {
              final titles = ShellNavigationConfig.titles;

              return BreadcrumbScope(
                controller: _breadcrumbController,
                child: Scaffold(
                  body: Row(
                    children: [
                      CustomSidebar(
                        isStencil: true,
                        isExpanded: state.isExpanded,
                        selectedIndex: state.selectedIndex,
                        onItemSelected:
                            (index) =>
                                context.read<ShellCubit>().selectPage(index),
                        onToggle:
                            () => context.read<ShellCubit>().toggleSidebar(),
                        onLogout: () => _handleLogout(context),
                        activeStyle: SidebarActiveStyle.sideBorder,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            BlocBuilder<CurrentUserCubit, CurrentUserState>(
                              builder: (context, userState) {
                                final breadcrumbs = BreadcrumbScope.of(context);

                                return CustomHeader(
                                  profileImage: userState.profileImage ?? '',
                                  currentUser: userState.fullname ?? "Guest",
                                  title: titles[state.selectedIndex],

                                  onMenuPressed:
                                      () =>
                                          context
                                              .read<ShellCubit>()
                                              .toggleSidebar(),
                                  breadcrumbs: breadcrumbs,
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
