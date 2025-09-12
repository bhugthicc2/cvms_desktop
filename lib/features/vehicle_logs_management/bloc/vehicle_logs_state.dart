import '../models/vehicle_log_model.dart';

class VehicleLogsState {
  final List<VehicleLogModel> allLogs;
  final bool isLoading;
  final String? successMessage;

  final String? error;

  final bool isBulkModeEnabled;

  const VehicleLogsState({
    this.allLogs = const [],
    this.isLoading = false,
    this.error,
    this.successMessage,
    required this.isBulkModeEnabled,
  });

  factory VehicleLogsState.initial() =>
      VehicleLogsState(allLogs: [], isBulkModeEnabled: false, error: null);

  VehicleLogsState copyWith({
    List<VehicleLogModel>? allLogs,
    List<VehicleLogModel>? enteredLogs,
    List<VehicleLogModel>? exitedLogs,
    bool? isLoading,
    String? error,
    String? successMessage,
    bool? isBulkModeEnabled,
  }) {
    return VehicleLogsState(
      allLogs: allLogs ?? this.allLogs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
      isBulkModeEnabled: isBulkModeEnabled ?? this.isBulkModeEnabled,
    );
  }
}
