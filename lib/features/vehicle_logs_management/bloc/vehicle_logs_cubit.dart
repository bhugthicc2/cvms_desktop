import 'dart:async';

import 'package:cvms_desktop/features/vehicle_logs_management/data/vehicle_logs_repository.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/models/vehicle_log_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'vehicle_logs_state.dart';

class VehicleLogsCubit extends Cubit<VehicleLogsState> {
  VehicleLogsRepository repository = VehicleLogsRepository();
  StreamSubscription<List<VehicleLogModel>>? _logsSubscription;
  VehicleLogsCubit(this.repository) : super(VehicleLogsState.initial());

  Future<void> addManualLog(VehicleLogModel entry) async {
    try {
      setLoading(true);
      await repository.addManualLog(entry);
      await loadVehicleLogs();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableVehicles(String query) async {
    try {
      return await repository.fetchAvailableVehicles(query);
    } catch (e) {
      setError(e.toString());
      return [];
    }
  }

  //fetch vehicle in real time by using stream subscription
  Future<void> loadVehicleLogs() async {
    try {
      setLoading(true);
      _logsSubscription?.cancel();

      _logsSubscription = repository.fetchLogs().listen(
        (logs) {
          if (!isClosed) {
            emit(state.copyWith(allLogs: logs, isLoading: false));
          }
        },
        onError: (error) {
          setError(error.toString());
        },
      );
    } catch (error) {
      setError(error.toString());
    }
  }

  void setLoading(bool isLoading) {
    if (!isClosed) {
      emit(state.copyWith(isLoading: isLoading));
    }
  }

  void setError(String error) {
    if (!isClosed) {
      emit(state.copyWith(error: error, isLoading: false));
    }
  }

  void clearError() {
    if (!isClosed) {
      emit(state.copyWith(error: null));
    }
  }

  void toggleBulkMode() {
    if (!isClosed) {
      final newBulkMode = !state.isBulkModeEnabled;
      emit(state.copyWith(isBulkModeEnabled: newBulkMode));
    }
  }

  Future<void> startSession(
    String vehicleID,
    String updatedBy,
    Map<String, dynamic> vehicleInfo,
  ) async {
    try {
      setLoading(true);
      await repository.startSession(vehicleID, updatedBy, vehicleInfo);

      // reload logs after starting session
      await loadVehicleLogs();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> endSession(String vehicleID, String updatedBy) async {
    try {
      setLoading(true);
      await repository.endSession(vehicleID, updatedBy);

      // reload logs after ending session
      await loadVehicleLogs();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @override
  Future<void> close() {
    _logsSubscription?.cancel();
    return super.close();
  }
}
