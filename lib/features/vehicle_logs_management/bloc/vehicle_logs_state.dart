import '../models/vehicle_log_model.dart';

class VehicleLogsState {
  final List<VehicleLogModel> allLogs;
  final List<VehicleLogModel> filteredEntries; // Search results
  final List<VehicleLogModel> selectedEntries; // Selected for bulk operations
  final String searchQuery;
  final String statusFilter;
  final String typeFilter;
  final bool isLoading;
  final String? successMessage;

  final String? error;

  final bool isBulkModeEnabled;

  const VehicleLogsState({
    this.allLogs = const [],
    required this.filteredEntries,
    required this.selectedEntries,
    this.isLoading = false,
    required this.searchQuery,
    required this.statusFilter,
    required this.typeFilter,
    this.error,
    this.successMessage,
    required this.isBulkModeEnabled,
  });

  factory VehicleLogsState.initial() => VehicleLogsState(
    allLogs: [],
    isBulkModeEnabled: false,
    error: null,
    filteredEntries: [],
    selectedEntries: [],
    searchQuery: '',
    statusFilter: 'All',
    typeFilter: 'All',
  );

  VehicleLogsState copyWith({
    List<VehicleLogModel>? allLogs,
    List<VehicleLogModel>? filteredEntries,
    List<VehicleLogModel>? selectedEntries,
    List<VehicleLogModel>? enteredLogs,
    List<VehicleLogModel>? exitedLogs,
    String? searchQuery,
    String? statusFilter,
    String? typeFilter,
    bool? isLoading,
    String? error,
    String? successMessage,
    bool? isBulkModeEnabled,
  }) {
    return VehicleLogsState(
      filteredEntries: filteredEntries ?? this.filteredEntries,
      allLogs: allLogs ?? this.allLogs,
      selectedEntries: selectedEntries ?? this.selectedEntries,
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
