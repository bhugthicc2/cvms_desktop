import 'package:cvms_desktop/features/dashboard/models/chart_data_model.dart';
import 'package:cvms_desktop/features/dashboard2/models/dashboard/recent_log_entry.dart';
import 'package:cvms_desktop/features/dashboard2/models/dashboard/time_grouping.dart';
import 'package:cvms_desktop/features/dashboard2/models/dashboard/violation_history_entry.dart';
import 'package:equatable/equatable.dart';

class IndividualDashboardState extends Equatable {
  final int totalViolations;
  final int totalPendingViolations;
  final int totalVehicleLogs;
  final List<ChartDataModel> violationDistribution;
  final List<ChartDataModel> vehicleLogsTrend;

  // DATE FILTER STATE
  final DateTime startDate;
  final DateTime endDate;
  final TimeGrouping grouping;

  //VIOLATION HISTORY
  final List<ViolationHistoryEntry> violationHistory;

  //RECENT LOGS
  final List<RecentLogEntry> recentLogs;

  const IndividualDashboardState({
    this.totalViolations = 0,
    this.totalPendingViolations = 0,
    this.totalVehicleLogs = 0,
    this.violationDistribution = const [],

    this.vehicleLogsTrend = const [],
    required this.startDate,
    required this.endDate,
    this.grouping = TimeGrouping.day,
    //VIOLATION HISTORY
    this.violationHistory = const [],
    //RECENT LOGS
    this.recentLogs = const [],
  });

  IndividualDashboardState copyWith({
    int? totalViolations,
    int? totalPendingViolations,
    int? totalVehicleLogs,
    List<ChartDataModel>? violationDistribution,
    List<ChartDataModel>? vehicleLogsTrend,
    DateTime? startDate,
    DateTime? endDate,
    TimeGrouping? grouping,
    //VIOLATION HISTORY
    List<ViolationHistoryEntry>? violationHistory,
    //RECENT LOGS
    List<RecentLogEntry>? recentLogs,
  }) {
    return IndividualDashboardState(
      totalViolations: totalViolations ?? this.totalViolations,
      totalPendingViolations:
          totalPendingViolations ?? this.totalPendingViolations,
      totalVehicleLogs: totalVehicleLogs ?? this.totalVehicleLogs,
      violationDistribution:
          violationDistribution ?? this.violationDistribution,
      vehicleLogsTrend: vehicleLogsTrend ?? this.vehicleLogsTrend,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      grouping: grouping ?? this.grouping,
      //VIOLATION HISTORY
      violationHistory: violationHistory ?? this.violationHistory,
      //RECENT LOGS
      recentLogs: recentLogs ?? this.recentLogs,
    );
  }

  @override
  List<Object?> get props => [
    totalViolations,
    totalPendingViolations,
    totalVehicleLogs,
    violationDistribution,
    vehicleLogsTrend,
    startDate,
    endDate,
    grouping,
    //VIOLATION HISTORY
    violationHistory,
    //RECENT LOGS
    recentLogs,
  ];
}
