part of 'dashboard_cubit.dart';

enum DashboardViewMode {
  global, // Root dashboard
  individual, // Individual vehicle report
  pdfPreview, // PDF preview view
}

class DashboardState extends Equatable {
  final DashboardViewMode viewMode;
  final bool loading;
  final String? error;
  final IndividualVehicleReport? selectedVehicle;
  final DashboardViewMode? previousViewMode;

  final int totalEntriesExits; //realtime implementation step 2
  final int totalVehicles;
  final int totalViolations;
  final int
  totalPendingViolations; //realtime data retrieval based on collection field step 2
  final List<ChartDataModel>
  vehicleDistribution; //real time grouped aggregation impl step 2

  const DashboardState({
    this.viewMode = DashboardViewMode.global,
    this.loading = false,
    this.error,
    this.selectedVehicle,
    this.previousViewMode,
    this.totalEntriesExits = 0, //realtime implementation step 3
    this.totalVehicles = 0,
    this.totalViolations = 0,
    this.totalPendingViolations =
        0, //realtime data retrieval based on collection field step 3
    this.vehicleDistribution =
        const [], //real time grouped aggregation impl step 3
  });

  DashboardState copyWith({
    DashboardViewMode? viewMode,
    bool? loading,
    String? error,
    IndividualVehicleReport? selectedVehicle,
    DashboardViewMode? previousViewMode,
    int? totalEntriesExits, //realtime implementation step 4
    int? totalVehicles,
    int? totalViolations,
    int?
    totalPendingViolations, //realtime data retrieval based on collection field step 5
    List<ChartDataModel>?
    vehicleDistribution, //real time grouped aggregation impl step 4
  }) {
    return DashboardState(
      viewMode: viewMode ?? this.viewMode,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      previousViewMode: previousViewMode ?? this.previousViewMode,
      totalEntriesExits:
          totalEntriesExits ??
          this.totalEntriesExits, //realtime implementation step 5
      totalVehicles: totalVehicles ?? this.totalVehicles,
      totalViolations: totalViolations ?? this.totalViolations,
      totalPendingViolations:
          totalPendingViolations ??
          this.totalPendingViolations, //realtime data retrieval based on collection field step 6
      vehicleDistribution:
          vehicleDistribution ??
          this.vehicleDistribution, //real time grouped aggregation impl step 5
    );
  }

  @override
  List<Object?> get props => [
    viewMode,
    loading,
    error,
    selectedVehicle,
    previousViewMode,
    totalEntriesExits, // realtime implementation step 5:
    totalVehicles,
    totalViolations,
    totalPendingViolations, //realtime data retrieval based on collection field step 7
    vehicleDistribution, //real time grouped aggregation impl step 6
  ];
}
