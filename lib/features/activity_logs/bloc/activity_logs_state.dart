part of 'activity_logs_cubit.dart';

class ActivityLogsState {
  final List<ActivityLog> allLogs;
  final List<ActivityLog> filteredLogs;
  final List<ActivityLog> selectedLogs;
  final String statusFilter;
  final String typeFilter;
  final String searchQuery;
  final bool isBulkModeEnabled;
  final String? error;
  final bool isExporting;
  final String? exportedFilePath;

  ActivityLogsState({
    required this.allLogs,
    required this.filteredLogs,
    required this.selectedLogs,
    required this.statusFilter,
    required this.typeFilter,
    required this.searchQuery,
    required this.isBulkModeEnabled,
    this.error,
    this.isExporting = false,
    this.exportedFilePath,
  });

  factory ActivityLogsState.initial() => ActivityLogsState(
    allLogs: [],
    filteredLogs: [],
    selectedLogs: [],
    statusFilter: 'All',
    typeFilter: 'All',
    searchQuery: '',
    isBulkModeEnabled: false,
    error: null,
    isExporting: false,
    exportedFilePath: null,
  );

  ActivityLogsState copyWith({
    List<ActivityLog>? allLogs,
    List<ActivityLog>? filteredLogs,
    List<ActivityLog>? selectedLogs,
    String? statusFilter,
    String? typeFilter,
    String? searchQuery,
    bool? isBulkModeEnabled,
    String? error,
    bool? isExporting,
    String? exportedFilePath,
  }) {
    return ActivityLogsState(
      allLogs: allLogs ?? this.allLogs,
      filteredLogs: filteredLogs ?? this.filteredLogs,
      selectedLogs: selectedLogs ?? this.selectedLogs,
      statusFilter: statusFilter ?? this.statusFilter,
      typeFilter: typeFilter ?? this.typeFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      isBulkModeEnabled: isBulkModeEnabled ?? this.isBulkModeEnabled,
      error: error,
      isExporting: isExporting ?? this.isExporting,
      exportedFilePath: exportedFilePath,
    );
  }
}
