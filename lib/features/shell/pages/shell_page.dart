import 'package:cvms_desktop/core/theme/app_colors.dart';
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
import 'package:cvms_desktop/features/report_and_analytics/pages/report_and_analytics_page.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage>
    with SingleTickerProviderStateMixin {
  late TabController? _reportTabController;

  @override
  void initState() {
    super.initState();
    _reportTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _reportTabController?.dispose();
    super.dispose();
  }

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
            final pages = ShellNavigationConfig.pages;
            final titles = ShellNavigationConfig.titles;
            final reportIndex = 5; // Index for Reports and Analytics

            Widget? subNavigation;
            if (state.selectedIndex == reportIndex) {
              subNavigation = TabBar(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                tabAlignment: TabAlignment.center,
                controller: _reportTabController,
                dividerHeight: 0,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.black,
                indicatorColor: AppColors.primary,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Poppins',
                ),
                isScrollable: true,
                tabs: [Tab(text: 'Overview'), Tab(text: 'Vehicle Report')],
              );
            }

            Widget body;
            if (state.selectedIndex == reportIndex) {
              body = ReportAndAnalyticsPage(
                tabController: _reportTabController,
              );
            } else {
              body = pages[state.selectedIndex];
            }

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
                              subNavigation: subNavigation,
                              onMenuPressed:
                                  () =>
                                      context
                                          .read<ShellCubit>()
                                          .toggleSidebar(),
                            );
                          },
                        ),
                        Expanded(child: body),
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
