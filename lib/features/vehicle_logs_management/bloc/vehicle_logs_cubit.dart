//REFACTORED DB REFERENCE

import 'dart:async';

import 'package:cvms_desktop/features/vehicle_logs_management/data/vehicle_logs_repository.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/models/vehicle_log_model.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/widgets/tables/top_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'vehicle_logs_state.dart';

class VehicleLogsCubit extends Cubit<VehicleLogsState> {
  final VehicleLogsRepository repository;

  StreamSubscription<List<VehicleLogModel>>? _logsSubscription;

  /// Lookups resolved by ID
  final Map<String, Map<String, dynamic>> vehiclesById = {};
  final Map<String, Map<String, dynamic>> usersById = {};

  VehicleLogsCubit(this.repository) : super(VehicleLogsState.initial()) {
    _loadReferenceData();
  }

  // -----------------------------
  // Reference Data Loading
  // -----------------------------
  Future<void> _loadReferenceData() async {
    try {
      // Load all vehicles from repository
      final vehicles = await repository.getAllVehicles();
      vehiclesById.addAll(vehicles);

      // Load all users from repository
      final users = await repository.getAllUsers();
      usersById.addAll(users);
    } catch (e) {
      // Continue without reference data if loading fails
      debugPrint('Error loading reference data: $e');
    }
  }

  // -----------------------------
  // Loading Logs
  // -----------------------------
  Future<void> loadVehicleLogs() async {
    try {
      setLoading(true);
      await _logsSubscription?.cancel();

      _logsSubscription = repository.fetchLogs().listen((logs) {
        if (isClosed) return;

        emit(state.copyWith(allLogs: logs, isLoading: false));
        _applyFilters();
      }, onError: (error) => setError(error.toString()));
    } catch (e) {
      setError(e.toString());
    }
  }

  // -----------------------------
  // Sessions
  // -----------------------------
  Future<void> startSession({
    required String vehicleId,
    required String updatedByUserId,
  }) async {
    try {
      setLoading(true);
      await repository.startSession(
        vehicleId: vehicleId,
        updatedByUserId: updatedByUserId,
      );
      await loadVehicleLogs();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> endSession({
    required String vehicleId,
    required String updatedByUserId,
  }) async {
    try {
      setLoading(true);
      await repository.endSession(
        vehicleId: vehicleId,
        updatedByUserId: updatedByUserId,
      );
      await loadVehicleLogs();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  // -----------------------------
  // Filtering
  // -----------------------------
  void filterEntries(String query) {
    emit(state.copyWith(searchQuery: query));
    _applyFilters();
  }

  void filterByStatus(String status) {
    emit(state.copyWith(statusFilter: status));
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = state.allLogs;

    if (state.searchQuery.isNotEmpty) {
      final q = state.searchQuery.toLowerCase();

      filtered =
          filtered.where((log) {
            final vehicle = vehiclesById[log.vehicleId];
            final user = usersById[log.updatedByUserId];

            return (vehicle?['plateNumber'] ?? '')
                    .toString()
                    .toLowerCase()
                    .contains(q) ||
                (vehicle?['vehicleModel'] ?? '')
                    .toString()
                    .toLowerCase()
                    .contains(q) ||
                (vehicle?['ownerName'] ?? '').toString().toLowerCase().contains(
                  q,
                ) ||
                (user?['fullname'] ?? '').toString().toLowerCase().contains(
                  q,
                ) ||
                log.status.toLowerCase().contains(q);
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

    emit(state.copyWith(filteredEntries: filtered));
  }

  void selectEntry(VehicleLogModel entry) {
    if (!state.isBulkModeEnabled) return;

    final selected = List<VehicleLogModel>.from(state.selectedEntries);

    if (selected.contains(entry)) {
      selected.remove(entry);
    } else {
      selected.add(entry);
    }

    emit(state.copyWith(selectedEntries: selected));
  }

  void selectAllEntries() {
    if (!state.isBulkModeEnabled) return;

    final filtered = state.filteredEntries;
    final selected = List<VehicleLogModel>.from(state.selectedEntries);

    final allSelected =
        filtered.isNotEmpty && filtered.every((e) => selected.contains(e));

    if (allSelected) {
      selected.removeWhere((e) => filtered.contains(e));
    } else {
      for (final e in filtered) {
        if (!selected.contains(e)) {
          selected.add(e);
        }
      }
    }

    emit(state.copyWith(selectedEntries: selected));
  }

  void clearSelection() {
    emit(state.copyWith(selectedEntries: []));
  }

  // -----------------------------
  // UI helpers
  // -----------------------------
  String resolvePlateNumber(VehicleLogModel log) =>
      vehiclesById[log.vehicleId]?['plateNumber'] ?? '—';

  String resolveOwnerName(VehicleLogModel log) =>
      vehiclesById[log.vehicleId]?['ownerName'] ?? '—';

  String resolveUpdatedBy(VehicleLogModel log) =>
      usersById[log.updatedByUserId]?['fullname'] ?? 'System';
  TopBarMetrics getMetrics() {
    final all = state.allLogs;

    // Total logs count
    final totalLogs = all.length;

    // Currently on-site vehicles (logs with status 'checked-in' or 'on-site')
    final currentlyOnSite =
        all
            .where(
              (log) =>
                  log.status.toLowerCase() == 'inside' ||
                  log.status.toLowerCase() == 'onsite',
            )
            .length;

    // Checked-out vehicles (logs with status 'checked-out')
    final checkedOutVehicles =
        all.where((log) => log.status.toLowerCase() == 'offsite').length;

    // Active vehicles (unique vehicles that have recent activity - logs within last 24 hours)
    final now = DateTime.now();
    final twentyFourHoursAgo = now.subtract(const Duration(hours: 24));
    final activeVehicles =
        all
            .where((log) => log.timeIn.toDate().isAfter(twentyFourHoursAgo))
            .map((log) => log.vehicleId)
            .toSet()
            .length;

    return TopBarMetrics(
      totalLogs: totalLogs,
      currentlyOnSite: currentlyOnSite,
      checkedOutVehicles: checkedOutVehicles,
      activeVehicles: activeVehicles,
    );
  }

  // -----------------------------
  // State helpers
  // -----------------------------
  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  void setError(String error) {
    emit(state.copyWith(error: error, isLoading: false));
  }

  void toggleBulkMode() {
    if (isClosed) return;

    emit(
      state.copyWith(
        isBulkModeEnabled: !state.isBulkModeEnabled,
        selectedEntries: [],
      ),
    );
  }

  @override
  Future<void> close() {
    _logsSubscription?.cancel();
    return super.close();
  }
}
