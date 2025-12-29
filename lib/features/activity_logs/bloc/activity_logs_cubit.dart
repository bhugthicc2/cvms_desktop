import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cvms_desktop/features/activity_logs/data/activity_logs_repository.dart';
import 'package:cvms_desktop/features/activity_logs/models/activity_entry.dart';

part 'activity_logs_state.dart';

class ActivityLogsCubit extends Cubit<ActivityLogsState> {
  final ActivityLogsRepository repository;
  StreamSubscription<List<ActivityLog>>? _logsSubscription;

  ActivityLogsCubit(this.repository) : super(ActivityLogsState.initial()) {
    init();
  }

  void init() {
    _subscribeToActivityLogs();
  }

  void _subscribeToActivityLogs() {
    _logsSubscription?.cancel();
    _logsSubscription = repository.getActivityLogsStream().listen(
      (logs) {
        if (isClosed) return;
        emit(
          state.copyWith(
            allLogs: logs,
            filteredLogs: _applyFilters(logs, state.searchQuery, state.statusFilter, state.typeFilter),
            error: null,
          ),
        );
      },
      onError: (error) {
        if (isClosed) return;
        emit(state.copyWith(error: error.toString()));
      },
    );
  }

  void selectLog(ActivityLog log) {
    final isSelected = state.selectedLogs.contains(log);
    final newSelectedLogs = List<ActivityLog>.from(state.selectedLogs);

    if (isSelected) {
      newSelectedLogs.remove(log);
    } else {
      newSelectedLogs.add(log);
    }

    emit(
      state.copyWith(
        selectedLogs: newSelectedLogs,
        isBulkModeEnabled: newSelectedLogs.isNotEmpty,
      ),
    );
  }

  void selectAllLogs(bool? selected) {
    if (selected == true) {
      emit(
        state.copyWith(
          selectedLogs: List<ActivityLog>.from(state.filteredLogs),
          isBulkModeEnabled: true,
        ),
      );
    } else {
      emit(state.copyWith(selectedLogs: [], isBulkModeEnabled: false));
    }
  }

  void setSearchQuery(String query) {
    if (state.searchQuery == query) return;
    emit(
      state.copyWith(
        searchQuery: query,
        filteredLogs: _applyFilters(state.allLogs, query, state.statusFilter, state.typeFilter),
      ),
    );
  }

  void setStatusFilter(String status) {
    if (state.statusFilter == status) return;
    emit(
      state.copyWith(
        statusFilter: status,
        filteredLogs: _applyFilters(state.allLogs, state.searchQuery, status, state.typeFilter),
      ),
    );
  }

  void setTypeFilter(String type) {
    if (state.typeFilter == type) return;
    emit(
      state.copyWith(
        typeFilter: type,
        filteredLogs: _applyFilters(state.allLogs, state.searchQuery, state.statusFilter, type),
      ),
    );
  }

  List<ActivityLog> _applyFilters(
    List<ActivityLog> logs,
    String searchQuery,
    String statusFilter,
    String typeFilter,
  ) {
    List<ActivityLog> filtered = List.from(logs);

    // Apply search query filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((log) {
        return log.description.toLowerCase().contains(query) ||
            (log.userEmail?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Apply status filter
    if (statusFilter != 'All') {
      filtered = filtered.where((log) {
        return log.type.toString().split('.').last == statusFilter;
      }).toList();
    }

    // Apply type filter
    if (typeFilter != 'All') {
      filtered = filtered.where((log) => log.targetType == typeFilter).toList();
    }

    return filtered;
  }

  Future<void> deleteSelectedLogs() async {
    if (state.selectedLogs.isEmpty) return;

    try {
      final ids = state.selectedLogs.map((log) => log.id).toList();
      await repository.bulkDeleteActivityLogs(ids);

      // Clear selection - no need to reload as the stream will update automatically
      emit(state.copyWith(selectedLogs: [], isBulkModeEnabled: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _logsSubscription?.cancel();
    return super.close();
  }
}
