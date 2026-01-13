import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/bloc/dashboard_state.dart';
import 'package:equatable/equatable.dart';
import '../../models/fleet_summary.dart';

class ReportsState extends Equatable {
  final bool showPdfPreview;
  final bool loading;
  final String? error;
  final FleetSummary? fleetSummary;
  final bool isGlobalMode;
  final List<ChartDataModel> logsData;
  final TimeRange selectedTimeRange;
  const ReportsState({
    this.showPdfPreview = false,
    this.loading = false,
    this.error,
    this.fleetSummary,
    this.isGlobalMode = true,
    this.logsData = const [],
    this.selectedTimeRange = TimeRange.days7,
  });

  ReportsState copyWith({
    bool? showPdfPreview,
    bool? loading,
    String? error,
    FleetSummary? fleetSummary,
    bool? isGlobalMode,
    List<ChartDataModel>? logsData,
    TimeRange? selectedTimeRange,
  }) {
    return ReportsState(
      showPdfPreview: showPdfPreview ?? this.showPdfPreview,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      fleetSummary: fleetSummary ?? this.fleetSummary,
      isGlobalMode: isGlobalMode ?? this.isGlobalMode,
      logsData: logsData ?? this.logsData,
      selectedTimeRange: selectedTimeRange ?? this.selectedTimeRange,
    );
  }

  @override
  List<Object?> get props => [
    showPdfPreview,
    loading,
    error,
    fleetSummary,
    isGlobalMode,
    logsData,
    selectedTimeRange,
  ];
}
