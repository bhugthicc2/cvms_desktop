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

  const DashboardState({
    this.viewMode = DashboardViewMode.global,
    this.loading = false,
    this.error,
  });

  DashboardState copyWith({
    DashboardViewMode? viewMode,
    bool? loading,
    String? error,
  }) {
    return DashboardState(
      viewMode: viewMode ?? this.viewMode,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [viewMode, loading, error];
}
