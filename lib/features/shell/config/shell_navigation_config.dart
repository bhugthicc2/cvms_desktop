import 'package:cvms_desktop/features/report_and_analytics/pages/report_and_analytics_page.dart';
import 'package:cvms_desktop/features/settings/pages/settings_page.dart';
import 'package:cvms_desktop/features/vehicle_management/pages/vehicle_management_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/features/dashboard/pages/dashboard_page.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard_cubit.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/pages/vehicle_monitoring_page.dart';
import 'package:cvms_desktop/features/user_management/pages/user_management_page.dart';
import 'package:cvms_desktop/features/violation_management/pages/violation_management_page.dart';
import 'package:cvms_desktop/features/profile/pages/profile_page.dart';

class ShellNavigationConfig {
  static final pages = <Widget>[
    BlocProvider(
      create: (context) => DashboardCubit(),
      child: const DashboardPage(),
    ),
    VehicleMonitoringPage(),
    VehicleManagementPage(),
    UserManagementPage(),
    ViolationManagementPage(),
    ReportAndAnalyticsPage(),
    SettingsPage(),
    ProfilePage(),
  ];

  static final titles = <String>[
    "Dashboard",
    "Vehicle Monitoring",
    "Vehicle Management",
    "User Management",
    "Violation Management",
    "Reports and Analytics",
    "Settings",
    "Profile",
  ];
}
