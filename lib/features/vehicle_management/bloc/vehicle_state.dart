part of 'vehicle_cubit.dart';

class VehicleState {
  final List<VehicleEntry> allEntries;
  final List<VehicleEntry> filteredEntries;
  final List<VehicleEntry> selectedEntries;

  final String statusFilter;
  final String typeFilter;
  final String searchQuery;
  final bool isBulkModeEnabled;
  final String? error;

  //Export status
  final bool isExporting;
  final String? exportedFilePath;

  VehicleState({
    required this.allEntries,
    required this.filteredEntries,
    required this.selectedEntries,
    required this.statusFilter,
    required this.typeFilter,
    required this.searchQuery,
    required this.isBulkModeEnabled,
    this.error,
    this.isExporting = false,
    this.exportedFilePath,
  });

  factory VehicleState.initial() => VehicleState(
    allEntries: [],
    filteredEntries: [],
    selectedEntries: [],
    statusFilter: 'All',
    typeFilter: 'All',
    searchQuery: '',
    isBulkModeEnabled: false,
    error: null,
    isExporting: false,
    exportedFilePath: null,
  );

  VehicleState copyWith({
    List<VehicleEntry>? allEntries,
    List<VehicleEntry>? filteredEntries,
    List<VehicleEntry>? selectedEntries,
    String? statusFilter,
    String? typeFilter,
    String? searchQuery,
    bool? isBulkModeEnabled,
    String? error,
    bool? isExporting,
    String? exportedFilePath,
  }) {
    return VehicleState(
      allEntries: allEntries ?? this.allEntries,
      filteredEntries: filteredEntries ?? this.filteredEntries,
      selectedEntries: selectedEntries ?? this.selectedEntries,
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
