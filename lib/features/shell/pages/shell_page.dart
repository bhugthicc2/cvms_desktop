import 'package:cvms_desktop/core/routes/app_routes.dart';
import 'package:cvms_desktop/core/widgets/custom_snackbar.dart';
import 'package:cvms_desktop/features/auth/bloc/auth_bloc.dart';
import 'package:cvms_desktop/features/auth/bloc/auth_event.dart';
import 'package:cvms_desktop/features/auth/bloc/auth_state.dart';
import 'package:cvms_desktop/features/auth/widgets/custom_alert_dialog.dart';
import 'package:cvms_desktop/features/dashboard/pages/dashboard_page.dart';
import 'package:cvms_desktop/features/profile/pages/profile_page.dart';
import 'package:cvms_desktop/features/report_and_analytics/pages/report_and_analytics_page.dart';
import 'package:cvms_desktop/features/settings/pages/settings_page.dart';
import 'package:cvms_desktop/features/shell/bloc/shell_cubit.dart';
import 'package:cvms_desktop/features/shell/widgets/custom_header.dart';
import 'package:cvms_desktop/features/shell/widgets/custom_sidebar.dart';
import 'package:cvms_desktop/features/user_management/pages/user_management_page.dart';
import 'package:cvms_desktop/features/vehicle_management/pages/vehicle_management_page.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/pages/vehicle_monitoring_page.dart';
import 'package:cvms_desktop/features/violation_management/pages/violation_management_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  final List<Widget> _pages = [
    DashboardPage(),
    VehicleMonitoringPage(),
    VehicleManagementPage(),
    UserManagementPage(),
    ViolationManagementPage(),
    ReportAndAnalyticsPage(),
    SettingsPage(),
    ProfilePage(),
  ];

  bool _isNavigating = false;

  @override
  void dispose() {
    super.dispose();
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Confirm Logout',
          message: 'Are you sure you want to logout?',
          btnTxt: 'Yes',
          onCancel: () => Navigator.of(context).pop(),
          onSubmit: () {
            Navigator.of(context).pop();
            context.read<AuthBloc>().add(SignOutEvent());
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShellCubit(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is SignOutSuccess && !_isNavigating) {
            _isNavigating = true;
            ScaffoldMessenger.of(context).clearSnackBars();
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                Navigator.of(
                  // ignore: use_build_context_synchronously
                  context,
                ).pushNamedAndRemoveUntil(AppRoutes.signIn, (route) => false);
                CustomSnackBar.show(
                  // ignore: use_build_context_synchronously
                  context: context,
                  message: "Signed out successfully!",
                  type: SnackBarType.success,
                );
              }
            });
          }
        },
        child: BlocBuilder<ShellCubit, ShellState>(
          builder: (context, state) {
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
                        CustomHeader(
                          title: "Dashboard",
                          onMenuPressed:
                              () => context.read<ShellCubit>().toggleSidebar(),
                        ),
                        Expanded(child: _pages[state.selectedIndex]),
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
