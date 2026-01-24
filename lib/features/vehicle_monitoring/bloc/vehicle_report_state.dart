part of 'vehicle_report_cubit.dart';

class VehicleReportState {
  final bool isLoading;
  final String? message;
  final SnackBarType? messageType;
  final String? lastReportedViolationId;
  final List<String> lastReportedViolationIds;

  VehicleReportState({
    required this.isLoading,
    this.message,
    this.messageType,
    this.lastReportedViolationId,
    this.lastReportedViolationIds = const [],
  });

  factory VehicleReportState.initial() => VehicleReportState(isLoading: false);

  VehicleReportState copyWith({
    bool? isLoading,
    String? message,
    SnackBarType? messageType,
    String? lastReportedViolationId,
    List<String>? lastReportedViolationIds,
  }) {
    return VehicleReportState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      messageType: messageType ?? this.messageType,
      lastReportedViolationId:
          lastReportedViolationId ?? this.lastReportedViolationId,
      lastReportedViolationIds:
          lastReportedViolationIds ?? this.lastReportedViolationIds,
    );
  }
}
