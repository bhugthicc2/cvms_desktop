//ACTIVITY LOG 16

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../activity_logs/bloc/activity_logs_cubit.dart';
import '../../activity_logs/data/activity_log_repository.dart';
import '../../activity_logs/pages/activity_logs_page.dart';
import 'package:cvms_desktop/features/dashboard/pages/core/dashboard_page.dart';
import 'package:cvms_desktop/features/reports/pages/reports_page.dart';
import 'package:cvms_desktop/features/settings/pages/setttings_page.dart';
import 'package:cvms_desktop/features/user_management/bloc/user_cubit.dart';
import 'package:cvms_desktop/features/user_management/bloc/user_management_bloc.dart';
import 'package:cvms_desktop/features/user_management/data/user_repository.dart'
    as user_mgmt;
import 'package:cvms_desktop/features/vehicle_logs_management/data/vehicle_logs_repository.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_cubit.dart';
import 'package:cvms_desktop/features/auth/data/auth_repository.dart';
import 'package:cvms_desktop/features/auth/data/user_repository.dart';
import 'package:cvms_desktop/features/vehicle_management/data/vehicle_repository.dart';
import 'package:cvms_desktop/features/vehicle_management/data/vehicle_violation_repository.dart';
import 'package:cvms_desktop/features/vehicle_management/pages/core/vehicle_management_page.dart';
import 'package:cvms_desktop/features/violation_management/bloc/violation_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/pages/vehicle_monitoring_page.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/bloc/vehicle_monitoring_cubit.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/pages/vehicle_logs_page.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/bloc/vehicle_logs_cubit.dart';
import 'package:cvms_desktop/features/user_management/pages/user_management_page.dart';
import 'package:cvms_desktop/features/violation_management/pages/violation_management_page.dart';
import 'package:cvms_desktop/features/profile/pages/profile_page.dart';
import '../../vehicle_monitoring/data/vehicle_monitoring_repository.dart'
    as vehicle_repo;

class ShellNavigationConfig {
  static Widget getPage(int index, BuildContext context) {
    switch (index) {
      case 0:
        return const DashboardPage();

      case 1:
        return BlocProvider(
          create:
              (_) => VehicleMonitoringCubit(vehicle_repo.DashboardRepository()),
          child: const VehicleMonitoringPage(),
        );

      case 2:
        return BlocProvider(
          create: (_) => VehicleLogsCubit(VehicleLogsRepository()),
          child: const VehicleLogsPage(),
        );

      case 3:
        return BlocProvider(
          create:
              (_) => VehicleCubit(
                VehicleRepository(),
                AuthRepository(),
                UserRepository(),
                VehicleViolationRepository(),
                VehicleLogsRepository(),
              ),
          child: const VehicleManagementPage(),
        );

      case 4:
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => UserCubit(repository: user_mgmt.UserRepository()),
            ),
            BlocProvider(
              create:
                  (_) => UserManagementBloc(
                    authRepository: AuthRepository(),
                    userRepository: UserRepository(),
                  ),
            ),
          ],
          child: const UserManagementPage(),
        );

      case 5:
        return BlocProvider(
          create: (_) => ViolationCubit(),
          child: ViolationManagementPage(),
        );

      case 6:
        return ReportsPage();

      case 7:
        return BlocProvider(
          create:
              (_) => ActivityLogsCubit(
                ActivityLogRepository(FirebaseFirestore.instance),
              ),
          child: ActivityLogsPage(),
        );

      case 8:
        return const ProfilePage();

      case 9:
        return const SettingsPage();

      default:
        return const DashboardPage();
    }
  }

  static Widget getProviderPage(int index, BuildContext context) {
    return getPage(index, context);
  }

  static final titles = <String>[
    "Dashboard",
    "Vehicle Monitoring",
    "Vehicle Logs Management",
    "Vehicle Management",
    "User Management",
    "Violation Management",
    "Reports",
    "Activity Logs",
    "Profile",
    "Settings",
  ];
}
