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
            _applyFilters();
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
      emit(
        state.copyWith(
          isBulkModeEnabled: newBulkMode,
          selectedEntries:
              newBulkMode
                  ? []
                  : state.selectedEntries, // Clear selections when enabling
        ),
      );
    }
  }

  void selectEntry(VehicleLogModel entry) {
    if (!state.isBulkModeEnabled) return; // Only work in bulk mode

    final currentSelected = List<VehicleLogModel>.from(state.selectedEntries);
    if (currentSelected.contains(entry)) {
      currentSelected.remove(entry); // Deselect if already selected
    } else {
      currentSelected.add(entry); // Select if not selected
    }

    emit(state.copyWith(selectedEntries: currentSelected));
  }

  void selectAllEntries() {
    if (!state.isBulkModeEnabled) return;

    final allFiltered = state.filteredEntries;
    final currentSelected = List<VehicleLogModel>.from(state.selectedEntries);

    final allSelected = allFiltered.every(
      (entry) => currentSelected.contains(entry),
    );

    if (allSelected) {
      // Deselect all if all are selected
      currentSelected.removeWhere((entry) => allFiltered.contains(entry));
    } else {
      // Select all if not all are selected
      for (final entry in allFiltered) {
        if (!currentSelected.contains(entry)) {
          currentSelected.add(entry);
        }
      }
    }

    emit(state.copyWith(selectedEntries: currentSelected));
  }

  void clearSelection() {
    if (!isClosed) {
      emit(state.copyWith(selectedEntries: []));
    }
  }

  // Bulk Operations
  Future<void> bulkExportLogs() async {
    if (state.selectedEntries.isEmpty) return;

    try {
      setLoading(true);
      // TODO: Implement bulk export functionality
      // For now, just show success message
      emit(
        state.copyWith(
          successMessage:
              'Exported ${state.selectedEntries.length} vehicle logs successfully!',
          selectedEntries: [],
        ),
      );
    } catch (e) {
      setError('Failed to export logs: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  Future<void> bulkDeleteLogs() async {
    if (state.selectedEntries.isEmpty) return;

    try {
      setLoading(true);
      // final logIds = state.selectedEntries.map((log) => log.logID).toList();

      // TODO: Implement bulk delete in repository
      // await repository.bulkDeleteLogs(logIds);

      emit(
        state.copyWith(
          successMessage:
              'Deleted ${state.selectedEntries.length} vehicle logs successfully!',
          selectedEntries: [],
        ),
      );

      // Reload logs to reflect changes
      await loadVehicleLogs();
    } catch (e) {
      setError('Failed to delete logs: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  Future<void> bulkReportViolations({
    required String violationType,
    String? reason,
  }) async {
    if (state.selectedEntries.isEmpty) return;

    try {
      setLoading(true);

      // TODO: Implement bulk violation reporting
      // For now, just show success message
      emit(
        state.copyWith(
          successMessage:
              'Reported ${state.selectedEntries.length} vehicles for violation: $violationType',
          selectedEntries: [],
        ),
      );
    } catch (e) {
      setError('Failed to report violations: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  Future<void> bulkUpdateStatus(String status) async {
    if (state.selectedEntries.isEmpty) return;

    try {
      setLoading(true);
      // final logIds = state.selectedEntries.map((log) => log.logID).toList();

      // TODO: Implement bulk status update in repository
      // await repository.bulkUpdateLogStatus(logIds, status);

      emit(
        state.copyWith(
          successMessage:
              'Updated status of ${state.selectedEntries.length} vehicle logs to $status',
          selectedEntries: [],
        ),
      );

      // Reload logs to reflect changes
      await loadVehicleLogs();
    } catch (e) {
      setError('Failed to update status: ${e.toString()}');
    } finally {
      setLoading(false);
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

  void filterEntries(String query) {
    if (!isClosed) {
      emit(state.copyWith(searchQuery: query));
      _applyFilters();
    }
  }

  void filterByStatus(String status) {
    if (!isClosed) {
      emit(state.copyWith(statusFilter: status));
      _applyFilters();
    }
  }

  void filterByType(String type) {
    if (!isClosed) {
      emit(state.copyWith(typeFilter: type));
      _applyFilters();
    }
  }

  void _applyFilters() {
    var filtered = state.allLogs;

    if (state.searchQuery.isNotEmpty) {
      final q = state.searchQuery.toLowerCase();
      filtered =
          filtered.where((e) {
            return e.ownerName.toLowerCase().contains(q) ||
                e.plateNumber.toLowerCase().contains(q) ||
                e.vehicleModel.toLowerCase().contains(q) ||
                e.updatedBy.toLowerCase().contains(q) ||
                e.status.toLowerCase().contains(q);
          }).toList();
    }

    if (state.statusFilter != 'All') {
      filtered =
          filtered
              .where(
                (e) =>
                    e.status.toLowerCase() == state.statusFilter.toLowerCase(),
              )
              .toList();
    }

    if (state.typeFilter != 'All') {
      //todo
      // For now, we'll filter by vehicle model since vehicle type is not available in logs
      // This could be enhanced later to fetch vehicle type from vehicle data
      filtered =
          filtered
              .where(
                (e) => e.vehicleModel.toLowerCase().contains(
                  state.typeFilter.toLowerCase(),
                ),
              )
              .toList();
    }

    emit(state.copyWith(filteredEntries: filtered));
  }

  @override
  Future<void> close() {
    _logsSubscription?.cancel();
    return super.close();
  }
}
