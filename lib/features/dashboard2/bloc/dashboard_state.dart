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

  const DashboardState({
    this.viewMode = DashboardViewMode.global,
    this.loading = false,
    this.error,
    this.selectedVehicle,
    this.previousViewMode,
    this.totalEntriesExits = 0, //realtime implementation step 3
  });

  DashboardState copyWith({
    DashboardViewMode? viewMode,
    bool? loading,
    String? error,
    IndividualVehicleReport? selectedVehicle,
    DashboardViewMode? previousViewMode,
    int? totalEntriesExits, //realtime implementation step 4
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
  ];
}
