import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/features/auth/data/auth_repository.dart';
import 'package:cvms_desktop/features/auth/data/user_repository.dart';
import 'package:cvms_desktop/features/vehicle_management/data/vehicle_violation_repository.dart';
import 'package:cvms_desktop/features/vehicle_management/models/vehicle_entry.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/vehicle_repository.dart';
part 'vehicle_state.dart';

class VehicleCubit extends Cubit<VehicleState> {
  final VehicleRepository repository;
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final VehicleViolationRepository violationRepository;

  VehicleCubit(
    this.repository,
    this.authRepository,
    this.userRepository,
    this.violationRepository,
  ) : super(VehicleState.initial());

  void loadEntries(List<VehicleEntry> entries) {
    emit(state.copyWith(allEntries: entries));
    _applyFilters();
  }

  Future<void> loadVehicles() async {
    final entries = await repository.fetchVehicles();
    emit(state.copyWith(allEntries: entries));
    _applyFilters();
  }

  Future<void> addVehicle(VehicleEntry entry) async {
    await repository.addVehicle(entry);
    await loadVehicles();
  }

  Future<void> updateVehicle(String id, Map<String, dynamic> updates) async {
    await repository.updateVehicle(id, updates);
    await loadVehicles();
  }

  Future<void> deleteVehicle(String id) async {
    await repository.deleteVehicle(id);
    await loadVehicles();
  }

  void listenVehicles() {
    repository.watchVehicles().listen((entries) {
      emit(state.copyWith(allEntries: entries));
      _applyFilters();
    });
  }

  void toggleBulkMode() {
    final newBulkMode = !state.isBulkModeEnabled;
    emit(
      state.copyWith(
        isBulkModeEnabled: newBulkMode,
        selectedEntries: newBulkMode ? [] : state.selectedEntries,
      ),
    );
  }

  void selectEntry(VehicleEntry entry) {
    if (!state.isBulkModeEnabled) return;

    final currentSelected = List<VehicleEntry>.from(state.selectedEntries);
    if (currentSelected.contains(entry)) {
      currentSelected.remove(entry);
    } else {
      currentSelected.add(entry);
    }

    emit(state.copyWith(selectedEntries: currentSelected));
  }

  void selectAllEntries() {
    if (!state.isBulkModeEnabled) return;

    final allFiltered = state.filteredEntries;
    final currentSelected = List<VehicleEntry>.from(state.selectedEntries);

    final allSelected = allFiltered.every(
      (entry) => currentSelected.contains(entry),
    );

    if (allSelected) {
      currentSelected.removeWhere((entry) => allFiltered.contains(entry));
    } else {
      for (final entry in allFiltered) {
        if (!currentSelected.contains(entry)) {
          currentSelected.add(entry);
        }
      }
    }

    emit(state.copyWith(selectedEntries: currentSelected));
  }

  void clearSelection() {
    emit(state.copyWith(selectedEntries: []));
  }

  void filterEntries(String query) {
    emit(state.copyWith(searchQuery: query));
    _applyFilters();
  }

  void filterByStatus(String status) {
    emit(state.copyWith(statusFilter: status));
    _applyFilters();
  }

  void filterByType(String type) {
    emit(state.copyWith(typeFilter: type));
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = state.allEntries;

    if (state.searchQuery.isNotEmpty) {
      final q = state.searchQuery.toLowerCase();
      filtered =
          filtered.where((e) {
            final qLower = q.toLowerCase();

            return e.ownerName.toLowerCase().contains(qLower) ||
                e.schoolID.toLowerCase().contains(qLower) ||
                e.plateNumber.toLowerCase().contains(qLower) ||
                e.vehicleType.toLowerCase().contains(qLower) ||
                e.vehicleModel.toLowerCase().contains(qLower) ||
                e.vehicleColor.toLowerCase().contains(qLower) ||
                e.licenseNumber.toLowerCase().contains(qLower) ||
                e.orNumber.toLowerCase().contains(qLower) ||
                e.crNumber.toLowerCase().contains(qLower) ||
                e.status.toLowerCase().contains(qLower) ||
                e.qrCodeID.toLowerCase().contains(qLower) ||
                (e.createdAt != null &&
                    e.createdAt!
                        .toDate()
                        .toIso8601String()
                        .toLowerCase()
                        .contains(qLower));
          }).toList();
    }

    if (state.statusFilter != 'All') {
      filtered =
          filtered
              .where((e) => e.status == state.statusFilter.toLowerCase())
              .toList();
    }

    if (state.typeFilter != 'All') {
      filtered =
          filtered.where((e) => e.vehicleType == state.typeFilter).toList();
    }

    emit(state.copyWith(filteredEntries: filtered));
  }

  Future<void> reportViolation({
    required VehicleEntry vehicle,
    required String violationType,
    String? reason,
  }) async {
    try {
      final currentUser = authRepository.currentUser;
      if (currentUser == null) throw Exception("User not authenticated");

      final userProfile = await userRepository.getUserProfile(currentUser.uid);
      final reporterName = userProfile?['fullname'] ?? "Unknown User";

      final violation = ViolationEntry(
        violationID: "", // Firestore generates it
        dateTime: Timestamp.now(),
        reportedBy: reporterName,
        plateNumber: vehicle.plateNumber,
        vehicleID: vehicle.vehicleID,
        owner: vehicle.ownerName,
        violation: violationType,
        status: "pending",
      );

      await violationRepository.reportViolation(violation);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> bulkDeleteVehicles() async {
    if (state.selectedEntries.isEmpty) return;

    try {
      final vehicleIds =
          state.selectedEntries.map((entry) => entry.vehicleID).toList();
      await repository.bulkDeleteVehicles(vehicleIds);

      emit(state.copyWith(selectedEntries: []));
      await loadVehicles();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> bulkReportViolations({
    required String violationType,
    String? reason,
  }) async {
    if (state.selectedEntries.isEmpty) return;

    try {
      final currentUser = authRepository.currentUser;
      if (currentUser == null) throw Exception("User not authenticated");

      final userProfile = await userRepository.getUserProfile(currentUser.uid);
      final reporterName = userProfile?['fullname'] ?? "Unknown User";

      final violations =
          state.selectedEntries.map((vehicle) {
            return ViolationEntry(
              violationID: "",
              dateTime: Timestamp.now(),
              reportedBy: reporterName,
              plateNumber: vehicle.plateNumber,
              vehicleID: vehicle.vehicleID,
              owner: vehicle.ownerName,
              violation: violationType,
              status: "pending",
            );
          }).toList();

      await violationRepository.bulkReportViolations(violations);

      emit(state.copyWith(selectedEntries: []));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> bulkUpdateStatus(String status) async {
    if (state.selectedEntries.isEmpty) return;

    try {
      final vehicleIds =
          state.selectedEntries.map((entry) => entry.vehicleID).toList();
      await repository.bulkUpdateStatus(vehicleIds, status);

      emit(state.copyWith(selectedEntries: []));
      await loadVehicles();
    } catch (e) {
      rethrow;
    }
  }
}
