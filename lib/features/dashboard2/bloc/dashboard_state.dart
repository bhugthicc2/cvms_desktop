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

  const DashboardState({
    this.viewMode = DashboardViewMode.global,
    this.loading = false,
    this.error,
    this.selectedVehicle,
    this.previousViewMode,
  });

  DashboardState copyWith({
    DashboardViewMode? viewMode,
    bool? loading,
    String? error,
    IndividualVehicleReport? selectedVehicle,
    DashboardViewMode? previousViewMode,
  }) {
    return DashboardState(
      viewMode: viewMode ?? this.viewMode,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      previousViewMode: previousViewMode ?? this.previousViewMode,
    );
  }

  @override
  List<Object?> get props => [
    viewMode,
    loading,
    error,
    selectedVehicle,
    previousViewMode,
  ];
}
