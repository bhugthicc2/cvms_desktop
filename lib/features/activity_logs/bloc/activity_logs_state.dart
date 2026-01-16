//ACTIVITY LOG 15

import 'package:cvms_desktop/core/models/activity_log.dart';

class ActivityLogsState {
  final List<ActivityLog> allLogs;
  final List<ActivityLog> filteredEntries; // Search results
  final List<ActivityLog> selectedEntries; // Selected for bulk operations
  final Map<String, String> userFullnames; // User ID to Fullname mapping
  final String searchQuery;
  final String statusFilter;
  final String typeFilter;
  final bool isLoading;
  final String? successMessage;

  final String? error;

  final bool isBulkModeEnabled;

  const ActivityLogsState({
    this.allLogs = const [],
    required this.filteredEntries,
    required this.selectedEntries,
    this.userFullnames = const {},
    this.isLoading = false,
    required this.searchQuery,
    required this.statusFilter,
    required this.typeFilter,
    this.error,
    this.successMessage,
    required this.isBulkModeEnabled,
  });

  factory ActivityLogsState.initial() => ActivityLogsState(
    allLogs: [],
    isBulkModeEnabled: false,
    error: null,
    filteredEntries: [],
    selectedEntries: [],
    userFullnames: {},
    searchQuery: '',
    statusFilter: 'All',
    typeFilter: 'All',
  );

  ActivityLogsState copyWith({
    List<ActivityLog>? allLogs,
    List<ActivityLog>? filteredEntries,
    List<ActivityLog>? selectedEntries,
    List<ActivityLog>? enteredLogs,
    List<ActivityLog>? exitedLogs,
    Map<String, String>? userFullnames,
    String? searchQuery,
    String? statusFilter,
    String? typeFilter,
    bool? isLoading,
    String? error,
    String? successMessage,
    bool? isBulkModeEnabled,
  }) {
    return ActivityLogsState(
      filteredEntries: filteredEntries ?? this.filteredEntries,
      allLogs: allLogs ?? this.allLogs,
      selectedEntries: selectedEntries ?? this.selectedEntries,
      userFullnames: userFullnames ?? this.userFullnames,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      typeFilter: typeFilter ?? this.typeFilter,
      isBulkModeEnabled: isBulkModeEnabled ?? this.isBulkModeEnabled,
    );
  }
}
