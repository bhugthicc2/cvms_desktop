//ACTIVITY LOG 16
import 'package:cvms_desktop/features/sanction_management/bloc/sanction_cubit.dart';
import 'package:cvms_desktop/features/sanction_management/pages/sanction_management_page.dart';
import 'package:cvms_desktop/features/sanction_management/repository/firestore_sanction_repository.dart';
import 'package:cvms_desktop/features/settings/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../activity_logs/bloc/activity_logs_cubit.dart';
import '../../activity_logs/data/activity_log_repository.dart';
import '../../activity_logs/pages/activity_logs_page.dart';
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
import 'package:cvms_desktop/features/profile/bloc/profile_cubit.dart';
import '../../vehicle_monitoring/data/vehicle_monitoring_repository.dart'
    as vehicle_repo;

//new dashboard

import 'package:cvms_desktop/features/dashboard/pages/core/dasboard_page.dart'
    as new_dashboard;

class ShellNavigationConfig {
  static Widget getPage(int index, BuildContext context) {
    switch (index) {
      case 0:
        return const new_dashboard.DashboardPage();

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
        return BlocProvider(
          create: (context) => SanctionCubit(FirestoreSanctionRepository()),
          child: SanctionManagementPage(),
        );

      case 7:
        return BlocProvider(
          create:
              (_) => ActivityLogsCubit(
                ActivityLogRepository(FirebaseFirestore.instance),
              ),
          child: ActivityLogsPage(),
        );

      case 8:
        return BlocProvider(
          create:
              (_) => ProfileCubit(
                userRepository: UserRepository(),
                authRepository: AuthRepository(),
              ),
          child: const ProfilePage(),
        );

      case 9:
        return const SettingsPage();

      default:
        return const new_dashboard.DashboardPage();
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
    "Sanction Management",
    "Activity Logs",
    "Profile",
    "Settings",
  ];
}
