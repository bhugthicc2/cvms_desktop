import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/features/vehicle_monitoring/bloc/vehicle_monitoring_cubit.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/bloc/vehicle_logs_cubit.dart';
import 'package:cvms_desktop/features/vehicle_management/bloc/vehicle_cubit.dart';
import 'package:cvms_desktop/features/user_management/bloc/user_cubit.dart';
import 'package:cvms_desktop/features/violation_management/bloc/violation_cubit.dart';
import '../../vehicle_monitoring/data/vehicle_monitoring_repository.dart'
    as vehicle_repo;
import '../../vehicle_logs_management/data/vehicle_logs_repository.dart';
import '../../vehicle_management/data/vehicle_repository.dart';
import '../../vehicle_management/data/vehicle_violation_repository.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/data/user_repository.dart';
import '../../user_management/data/user_repository.dart' as user_mgmt;

class ShellState {
  final bool isExpanded;
  final int selectedIndex;
  final Map<int, bool> preloadedPages;

  ShellState({
    this.isExpanded = true,
    this.selectedIndex = 0,
    this.preloadedPages = const {},
  });

  ShellState copyWith({
    bool? isExpanded,
    int? selectedIndex,
    Map<int, bool>? preloadedPages,
  }) {
    return ShellState(
      isExpanded: isExpanded ?? this.isExpanded,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      preloadedPages: preloadedPages ?? this.preloadedPages,
    );
  }
}

class ShellCubit extends Cubit<ShellState> {
  // Cache BLoC instances to avoid recreating them
  final Map<int, dynamic> _blocCache = {};

  ShellCubit() : super(ShellState()) {
    // Preload commonly used pages in background
    _preloadCommonPages();
  }

  void toggleSidebar() => emit(state.copyWith(isExpanded: !state.isExpanded));

  void selectPage(int index) {
    // Start preloading adjacent pages for smoother navigation
    _preloadAdjacentPages(index);
    emit(state.copyWith(selectedIndex: index));
  }

  void _preloadCommonPages() {
    // Preload Dashboard (index 0) and Vehicle Monitoring (index 1)
    // These are most commonly accessed
    Future.delayed(const Duration(milliseconds: 500), () {
      _getOrCreateBloc(0); // Dashboard
      _getOrCreateBloc(1); // Vehicle Monitoring
    });
  }

  void _preloadAdjacentPages(int currentIndex) {
    // Preload next and previous pages
    final nextIndex = currentIndex + 1;
    final prevIndex = currentIndex - 1;

    if (nextIndex < 10) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _getOrCreateBloc(nextIndex);
      });
    }

    if (prevIndex >= 0) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _getOrCreateBloc(prevIndex);
      });
    }
  }

  dynamic _getOrCreateBloc(int index) {
    if (_blocCache.containsKey(index)) {
      return _blocCache[index];
    }

    switch (index) {
      case 1: // Vehicle Monitoring
        final cubit = VehicleMonitoringCubit(
          vehicle_repo.DashboardRepository(),
        );
        _blocCache[index] = cubit;
        // Start listening in background
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!cubit.isClosed) cubit.startListening();
        });
        return cubit;

      case 2: // Vehicle Logs
        final cubit = VehicleLogsCubit(VehicleLogsRepository());
        _blocCache[index] = cubit;
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!cubit.isClosed) cubit.loadVehicleLogs();
        });
        return cubit;

      case 3: // Vehicle Management
        final cubit = VehicleCubit(
          VehicleRepository(),
          AuthRepository(),
          UserRepository(),
          VehicleViolationRepository(),
          VehicleLogsRepository(),
        );
        _blocCache[index] = cubit;
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!cubit.isClosed) cubit.listenVehicles();
        });
        return cubit;

      case 4: // User Management
        final userCubit = UserCubit(repository: user_mgmt.UserRepository());
        _blocCache[index] = userCubit;
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!userCubit.isClosed) userCubit.listenUsers();
        });
        return userCubit;

      case 5: // Violation Management
        final cubit = ViolationCubit();
        _blocCache[index] = cubit;
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!cubit.isClosed) cubit.listenViolations();
        });
        return cubit;

      default:
        return null;
    }
  }

  T? getCachedBloc<T>(int index) {
    return _blocCache[index] as T?;
  }

  @override
  Future<void> close() {
    // Close all cached BLoCs
    for (final bloc in _blocCache.values) {
      try {
        if (bloc.hasMethod('close')) {
          bloc.close();
        }
      } catch (e) {
        // Ignore errors during cleanup
      }
    }
    return super.close();
  }
}
