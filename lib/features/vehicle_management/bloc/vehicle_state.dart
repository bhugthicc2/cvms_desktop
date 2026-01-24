part of 'vehicle_cubit.dart';

class VehicleState {
  final List<VehicleEntry> allEntries;
  final List<VehicleEntry> filteredEntries;
  final List<VehicleEntry> selectedEntries;

  final String statusFilter;
  final String typeFilter;
  final String collegeFilter;
  final String yearLevelFilter;
  final String searchQuery;
  final bool isBulkModeEnabled;
  final String? error;
  final VehicleViewMode viewMode; //view mode
  final int addVehicleStep;

  //Export status
  final bool isExporting;
  final String? exportedFilePath;

  // Track which vehicles have logs (transactions)
  final Set<String> vehiclesWithLogs;
  final bool isLoading;

  VehicleState({
    required this.allEntries,
    required this.filteredEntries,
    required this.selectedEntries,
    required this.statusFilter,
    required this.typeFilter,
    required this.collegeFilter,
    required this.yearLevelFilter,
    required this.searchQuery,
    required this.isBulkModeEnabled,
    this.error,
    this.isExporting = false,
    this.exportedFilePath,
    this.vehiclesWithLogs = const {},
    this.isLoading = false,
    this.viewMode = VehicleViewMode.list, //default view mode
    this.addVehicleStep = 0,
  });

  factory VehicleState.initial() => VehicleState(
    allEntries: [],
    filteredEntries: [],
    selectedEntries: [],
    statusFilter: 'All',
    typeFilter: 'All',
    collegeFilter: 'All',
    yearLevelFilter: 'All',
    searchQuery: '',
    isBulkModeEnabled: false,
    error: null,
    isExporting: false,
    exportedFilePath: null,
    vehiclesWithLogs: {},
    isLoading: true,
    viewMode: VehicleViewMode.list, //default view mode
    addVehicleStep: 0,
  );

  VehicleState copyWith({
    List<VehicleEntry>? allEntries,
    List<VehicleEntry>? filteredEntries,
    List<VehicleEntry>? selectedEntries,
    String? statusFilter,
    String? typeFilter,
    String? collegeFilter,
    String? yearLevelFilter,
    String? searchQuery,
    bool? isBulkModeEnabled,
    String? error,
    bool? isExporting,
    String? exportedFilePath,
    Set<String>? vehiclesWithLogs,
    bool? isLoading,
    VehicleViewMode? viewMode, //view mode
    int? addVehicleStep,
  }) {
    return VehicleState(
      allEntries: allEntries ?? this.allEntries,
      filteredEntries: filteredEntries ?? this.filteredEntries,
      selectedEntries: selectedEntries ?? this.selectedEntries,
      statusFilter: statusFilter ?? this.statusFilter,
      typeFilter: typeFilter ?? this.typeFilter,
      collegeFilter: collegeFilter ?? this.collegeFilter,
      yearLevelFilter: yearLevelFilter ?? this.yearLevelFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      isBulkModeEnabled: isBulkModeEnabled ?? this.isBulkModeEnabled,
      error: error,
      isExporting: isExporting ?? this.isExporting,
      exportedFilePath: exportedFilePath,
      vehiclesWithLogs: vehiclesWithLogs ?? this.vehiclesWithLogs,
      isLoading: isLoading ?? this.isLoading,
      viewMode: viewMode ?? this.viewMode, //view mode
      addVehicleStep: addVehicleStep ?? this.addVehicleStep,
    );
  }
}
