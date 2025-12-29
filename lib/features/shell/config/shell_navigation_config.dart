import 'package:cvms_desktop/features/activity_logs/pages/activity_logs_page.dart';
import 'package:cvms_desktop/features/report_and_analytics/pages/report_and_analytics_page.dart';
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
import 'package:cvms_desktop/features/vehicle_management/pages/vehicle_management_page.dart';
import 'package:cvms_desktop/features/violation_management/bloc/violation_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/features/dashboard/pages/dashboard_page.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard_cubit.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/pages/vehicle_logs_page.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/bloc/vehicle_logs_cubit.dart';
import 'package:cvms_desktop/features/user_management/pages/user_management_page.dart';
import 'package:cvms_desktop/features/violation_management/pages/violation_management_page.dart';
import 'package:cvms_desktop/features/profile/pages/profile_page.dart';
import '../../dashboard/data/dashboard_repository.dart' as vehicle_repo;

class ShellNavigationConfig {
  static final pages = <Widget>[
    BlocProvider(
      create: (context) => DashboardCubit(vehicle_repo.DashboardRepository()),
      child: const DashboardPage(),
    ),

    BlocProvider(
      create: (context) => VehicleLogsCubit(VehicleLogsRepository()),
      child: const VehicleLogsPage(),
    ),
    BlocProvider(
      create:
          (context) => VehicleCubit(
            VehicleRepository(),
            AuthRepository(),
            UserRepository(),
            VehicleViolationRepository(),
            VehicleLogsRepository(),
          ),
      child: const VehicleManagementPage(),
    ),

    MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => UserCubit(repository: user_mgmt.UserRepository()),
        ),
        BlocProvider(
          create:
              (context) => UserManagementBloc(
                authRepository: AuthRepository(),
                userRepository: UserRepository(),
              ),
        ),
      ],
      child: const UserManagementPage(),
    ),
    BlocProvider(
      create: (context) => ViolationCubit(),
      child: ViolationManagementPage(),
    ),
    ReportAndAnalyticsPage(),
    ActivityLogsPage(),
    ProfilePage(),
    SettingsPage(),
  ];

  static final titles = <String>[
    "Dashboard",
    "Vehicle Logs Management",
    "Vehicle Management",
    "User Management",
    "Violation Management",
    "Reports and Analytics",
    "Activity Logs",
    "Profile",
    "Settings",
  ];
}
