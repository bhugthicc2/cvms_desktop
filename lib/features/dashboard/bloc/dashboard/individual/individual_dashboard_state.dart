import 'package:cvms_desktop/features/dashboard/models/dashboard/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/recent_log_entry.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/time_grouping.dart';
import 'package:cvms_desktop/features/dashboard/models/dashboard/violation_history_entry.dart';
import 'package:equatable/equatable.dart';

class IndividualDashboardState extends Equatable {
  final bool loading;
  final int totalViolations;
  final int totalPendingViolations;
  final int totalVehicleLogs;
  final List<ChartDataModel> violationDistribution;
  final List<ChartDataModel> vehicleLogsTrend;
  final List<ChartDataModel> violationTrend;

  // VEHICLE LOGS DATE FILTER STATE
  final DateTime vehicleLogstartDate;
  final DateTime vehicleLogsEndDate;

  // VIOLATION DATE FILTER STATE
  final DateTime violationTrendStartDate;
  final DateTime violationTrendEndDate;

  final TimeGrouping grouping;
  final String vehicleLogsCurrentTimeRange;
  final String violationTrendCurrentTimeRange;

  //VIOLATION HISTORY
  final List<ViolationHistoryEntry> violationHistory;

  //RECENT LOGS
  final List<RecentLogEntry> recentLogs;

  const IndividualDashboardState({
    this.loading = false,
    this.totalViolations = 0,
    this.totalPendingViolations = 0,
    this.totalVehicleLogs = 0,
    this.violationDistribution = const [],

    this.vehicleLogsTrend = const [],
    required this.vehicleLogstartDate,
    required this.vehicleLogsEndDate,

    required this.violationTrendStartDate,
    required this.violationTrendEndDate,
    this.grouping = TimeGrouping.day,
    this.vehicleLogsCurrentTimeRange = '7 days',
    this.violationTrendCurrentTimeRange = '7 days',
    //VIOLATION HISTORY
    this.violationHistory = const [],
    //RECENT LOGS
    this.recentLogs = const [],
    this.violationTrend = const [],
  });

  IndividualDashboardState copyWith({
    bool? loading,
    int? totalViolations,
    int? totalPendingViolations,
    int? totalVehicleLogs,
    List<ChartDataModel>? violationDistribution,
    List<ChartDataModel>? vehicleLogsTrend,
    List<ChartDataModel>? violationTrend,
    DateTime? vehicleLogstartDate,
    DateTime? vehicleLogsEndDate,
    DateTime? violationTrendStartDate,
    DateTime? violationTrendEndDate,
    TimeGrouping? grouping,
    String? vehicleLogsCurrentTimeRange,
    String? violationTrendCurrentTimeRange,
    //VIOLATION HISTORY
    List<ViolationHistoryEntry>? violationHistory,
    //RECENT LOGS
    List<RecentLogEntry>? recentLogs,
  }) {
    return IndividualDashboardState(
      loading: loading ?? this.loading,
      totalViolations: totalViolations ?? this.totalViolations,
      totalPendingViolations:
          totalPendingViolations ?? this.totalPendingViolations,
      totalVehicleLogs: totalVehicleLogs ?? this.totalVehicleLogs,
      violationDistribution:
          violationDistribution ?? this.violationDistribution,
      vehicleLogsTrend: vehicleLogsTrend ?? this.vehicleLogsTrend,
      violationTrend: violationTrend ?? this.violationTrend,

      vehicleLogstartDate: vehicleLogstartDate ?? this.vehicleLogstartDate,
      vehicleLogsEndDate: vehicleLogsEndDate ?? this.vehicleLogsEndDate,

      violationTrendStartDate:
          violationTrendStartDate ?? this.violationTrendStartDate,
      violationTrendEndDate:
          violationTrendEndDate ?? this.violationTrendEndDate,

      grouping: grouping ?? this.grouping,
      vehicleLogsCurrentTimeRange:
          vehicleLogsCurrentTimeRange ?? this.vehicleLogsCurrentTimeRange,
      violationTrendCurrentTimeRange:
          violationTrendCurrentTimeRange ?? this.violationTrendCurrentTimeRange,
      //VIOLATION HISTORY
      violationHistory: violationHistory ?? this.violationHistory,
      //RECENT LOGS
      recentLogs: recentLogs ?? this.recentLogs,
    );
  }

  @override
  List<Object?> get props => [
    loading,
    totalViolations,
    totalPendingViolations,
    totalVehicleLogs,
    violationDistribution,
    vehicleLogsTrend,
    violationTrend,
    vehicleLogstartDate,
    vehicleLogsEndDate,
    violationTrendStartDate,
    violationTrendEndDate,
    grouping,
    vehicleLogsCurrentTimeRange,
    violationTrendCurrentTimeRange,
    //VIOLATION HISTORY
    violationHistory,
    //RECENT LOGS
    recentLogs,
  ];
}
