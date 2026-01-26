//ACTIVITY LOG 3

import 'dart:async';

import 'package:cvms_desktop/features/activity_logs/widgets/tables/top_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/activity_log.dart';
import '../../../core/models/activity_type.dart';
import '../data/activity_log_repository.dart';
import 'activity_logs_state.dart';

class ActivityLogsCubit extends Cubit<ActivityLogsState> {
  final ActivityLogRepository _repository;
  StreamSubscription<List<ActivityLog>>? _subscription;

  ActivityLogsCubit(this._repository) : super(ActivityLogsState.initial());

  // Loading Logs
  Future<void> loadLogs({
    DateTime? startDate,
    DateTime? endDate,
    String? userId,
    ActivityType? type,
    int limit = 100,
  }) async {
    try {
      if (isClosed) return;
      emit(state.copyWith(isLoading: true));
      await _subscription?.cancel();

      _subscription = _repository
          .getActivityLogsStream(
            startDate: startDate,
            endDate: endDate,
            userId: userId,
            type: type,
            limit: limit,
          )
          .listen(
            (logs) async {
              if (isClosed) return;

              // Fetch user fullnames for the logs
              final userFullnames = await _repository.fetchUserFullnames(logs);
              final userRoles = await _repository.fetchUserRoles(logs);

              if (isClosed) return;
              emit(
                state.copyWith(
                  allLogs: logs,
                  filteredEntries: logs,
                  userFullnames: userFullnames,
                  userRoles: userRoles,
                  isLoading: false,
                ),
              );
              _applyFilters();
            },
            onError: (error) {
              if (isClosed) return;
              emit(state.copyWith(error: error.toString(), isLoading: false));
            },
          );
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  // Filtering
  void filterEntries(String query) {
    if (isClosed) return;
    emit(state.copyWith(searchQuery: query));
    _applyFilters();
  }

  void filterByStatus(String status) {
    if (isClosed) return;
    emit(state.copyWith(statusFilter: status));
    _applyFilters();
  }

  void filterByType(String type) {
    if (isClosed) return;
    emit(state.copyWith(typeFilter: type));
    _applyFilters();
  }

  void _applyFilters() {
    if (isClosed) return;

    var filtered = state.allLogs;

    // Apply search query filter
    if (state.searchQuery.isNotEmpty) {
      final q = state.searchQuery.toLowerCase();
      filtered =
          filtered.where((log) {
            return log.description.toLowerCase().contains(q) ||
                log.type.name.toLowerCase().contains(q) ||
                (log.userId?.toLowerCase().contains(q) ?? false);
          }).toList();
    }

    // Apply status filter (based on activity type)
    if (state.statusFilter != 'All') {
      filtered =
          filtered.where((log) {
            switch (state.statusFilter) {
              case 'User Actions':
                return log.type == ActivityType.userLogin ||
                    log.type == ActivityType.userLogout ||
                    log.type == ActivityType.userCreated ||
                    log.type == ActivityType.userUpdated ||
                    log.type == ActivityType.userDeleted;
              case 'Vehicle Actions':
                return log.type == ActivityType.vehicleCreated ||
                    log.type == ActivityType.vehicleUpdated ||
                    log.type == ActivityType.vehicleDeleted;
              case 'Violation Actions':
                return log.type == ActivityType.violationReported ||
                    log.type == ActivityType.violationUpdated ||
                    log.type == ActivityType.violationDeleted;
              case 'System':
                return log.type == ActivityType.systemError ||
                    log.type == ActivityType.systemNavigation;
              default:
                return true;
            }
          }).toList();
    }

    // Apply type filter
    if (state.typeFilter != 'All') {
      filtered =
          filtered.where((log) => log.type.name == state.typeFilter).toList();
    }

    if (isClosed) return;
    emit(state.copyWith(filteredEntries: filtered));
  }

  TopBarMetrics getMetrics() {
    final all = state.allLogs;

    // Total activities count
    final totalActivities = all.length;

    // Today's activity (activities that occurred today)
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todaysActivity =
        all.where((activity) => activity.timestamp.isAfter(todayStart)).length;

    // Active users today (unique users who performed activities today)
    final activeUsersToday =
        all
            .where(
              (activity) =>
                  activity.timestamp.isAfter(todayStart) &&
                  activity.userId != null,
            )
            .map((activity) => activity.userId!)
            .toSet()
            .length;

    // Login events today (userLogin and userLogout activities today)
    final loginsToday =
        all
            .where(
              (activity) =>
                  activity.timestamp.isAfter(todayStart) &&
                  (activity.type == ActivityType.userLogin ||
                      activity.type == ActivityType.userLogout),
            )
            .length;

    return TopBarMetrics(
      totalActivities: totalActivities,
      todaysActivity: todaysActivity,
      activeUsersToday: activeUsersToday,
      loginsToday: loginsToday,
    );
  }

  // Selection Management
  void selectEntry(ActivityLog entry) {
    if (isClosed || !state.isBulkModeEnabled) return;

    final selected = List<ActivityLog>.from(state.selectedEntries);

    if (selected.contains(entry)) {
      selected.remove(entry);
    } else {
      selected.add(entry);
    }

    if (isClosed) return;
    emit(state.copyWith(selectedEntries: selected));
  }

  void selectAllEntries() {
    if (isClosed || !state.isBulkModeEnabled) return;

    final filtered = state.filteredEntries;
    final selected = List<ActivityLog>.from(state.selectedEntries);

    final allSelected =
        filtered.isNotEmpty && filtered.every((e) => selected.contains(e));

    if (allSelected) {
      selected.removeWhere((e) => filtered.contains(e));
    } else {
      for (final e in filtered) {
        if (!selected.contains(e)) {
          selected.add(e);
        }
      }
    }

    if (isClosed) return;
    emit(state.copyWith(selectedEntries: selected));
  }

  void clearSelection() {
    if (isClosed) return;
    emit(state.copyWith(selectedEntries: <ActivityLog>[]));
  }

  // -----------------------------
  // UI helpers
  // -----------------------------
  void toggleBulkMode() {
    if (isClosed) return;

    emit(
      state.copyWith(
        isBulkModeEnabled: !state.isBulkModeEnabled,
        selectedEntries: <ActivityLog>[],
      ),
    );
  }

  void refreshLogs() {
    loadLogs();
  }

  void clearError() {
    if (isClosed) return;
    emit(state.copyWith(error: null));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
