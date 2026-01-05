import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvms_desktop/core/services/cyrpto_service.dart';
import 'package:cvms_desktop/features/auth/data/auth_repository.dart';
import 'package:cvms_desktop/features/auth/data/user_repository.dart';
import 'package:cvms_desktop/features/vehicle_management/data/vehicle_violation_repository.dart';
import 'package:cvms_desktop/features/vehicle_management/models/vehicle_entry.dart';
import 'package:cvms_desktop/features/vehicle_management/utils/vehicle_card_renderer.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_model.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/data/vehicle_logs_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/vehicle_repository.dart';
import 'package:file_selector/file_selector.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:path/path.dart' as path;
part 'vehicle_state.dart';

class VehicleCubit extends Cubit<VehicleState> {
  final VehicleRepository repository;
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final VehicleViolationRepository violationRepository;
  final VehicleLogsRepository logsRepository;
  StreamSubscription<List<VehicleEntry>>? _vehiclesSubscription;

  VehicleCubit(
    this.repository,
    this.authRepository,
    this.userRepository,
    this.violationRepository,
    this.logsRepository,
  ) : super(VehicleState.initial());

  void loadEntries(List<VehicleEntry> entries) {
    emit(state.copyWith(allEntries: entries));
    _applyFilters();
  }

  Future<void> loadVehicles() async {
    try {
      final entries = await repository.fetchVehicles();
      final vehiclesWithLogs = await logsRepository.getVehiclesWithLogs();
      emit(
        state.copyWith(allEntries: entries, vehiclesWithLogs: vehiclesWithLogs),
      );
      _applyFilters();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> addVehicle(VehicleEntry entry) async {
    try {
      await repository.addVehicle(entry);
      await loadVehicles();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> importVehicles(List<VehicleEntry> entries) async {
    try {
      await repository.addVehicles(entries);
      await loadVehicles();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> updateVehicle(String id, Map<String, dynamic> updates) async {
    try {
      await repository.updateVehicle(id, updates);
      await loadVehicles();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> deleteVehicle(String id) async {
    try {
      await repository.deleteVehicle(id);
      await loadVehicles();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void listenVehicles() {
    emit(state.copyWith(isLoading: true));
    _vehiclesSubscription?.cancel();
    _vehiclesSubscription = repository.watchVehicles().listen(
      (entries) async {
        if (!isClosed) {
          try {
            final vehiclesWithLogs = await logsRepository.getVehiclesWithLogs();
            emit(
              state.copyWith(
                allEntries: entries,
                vehiclesWithLogs: vehiclesWithLogs,
                isLoading: false,
              ),
            );
            _applyFilters();
          } catch (e) {
            // If fetching logs fails, still update vehicles but keep existing logs set
            emit(state.copyWith(allEntries: entries, isLoading: false));
            _applyFilters();
          }
        }
      },
      onError: (error) {
        if (!isClosed) {
          //todo add exception handling to handle internet outage
          emit(state.copyWith(error: error.toString(), isLoading: false));
        }
      },
    );
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
    emit(state.copyWith(searchQuery: query, isLoading: false));
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
                e.status.toLowerCase().contains(qLower);
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

  Future<void> exportCardAsImage(GlobalKey repaintKey, String ownerName) async {
    try {
      emit(
        state.copyWith(isExporting: true, exportedFilePath: null, error: null),
      );

      // 1. Find render boundary
      RenderRepaintBoundary boundary =
          repaintKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;

      // 2. Convert to image
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      // 3. Convert to byte data
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // 4. Ask user for save location
      final FileSaveLocation? saveLocation = await getSaveLocation(
        acceptedTypeGroups: [
          XTypeGroup(label: 'png', extensions: ['png']),
        ],
        suggestedName: 'vehicle_pass_$ownerName.png',
      );

      if (saveLocation == null) {
        emit(state.copyWith(isExporting: false));
        return;
      }

      final file = File(saveLocation.path);
      await file.writeAsBytes(pngBytes);

      emit(
        state.copyWith(isExporting: false, exportedFilePath: saveLocation.path),
      );
    } catch (e) {
      emit(state.copyWith(isExporting: false, error: e.toString()));
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

  //bulk export motor vehicle pass card

  Future<void> bulkExportAsPng() async {
    if (state.selectedEntries.isEmpty) {
      emit(state.copyWith(error: 'No vehicles selected for export'));
      return;
    }

    try {
      emit(state.copyWith(isExporting: true, error: null));
      final String? directoryPath = await getDirectoryPath(
        confirmButtonText: 'Select Folder',
      );

      if (directoryPath == null) {
        emit(
          state.copyWith(
            isExporting: false,
            error: 'No directory selected. Please choose a valid folder.',
          ),
        );
        return;
      }

      final directory = Directory(directoryPath);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      for (final entry in state.selectedEntries) {
        final rawVehicleId = entry.vehicleID;

        final qrData = CryptoService.withDefaultKey().encryptVehicleId(
          rawVehicleId,
        );

        final Uint8List pngBytes = await VehicleCardRenderer.renderCardToPng(
          plateNumber: entry.plateNumber,
          qrData: qrData,
        );

        if (pngBytes.isEmpty) {
          emit(
            state.copyWith(
              isExporting: false,
              error: 'Failed to render PNG for ${entry.plateNumber}',
            ),
          );
          return;
        }
        //save filename as owner name
        final sanitizedOwnerName = entry.ownerName.replaceAll(
          RegExp(r'[<>:"/\\|?*]'),
          '_',
        );
        final filePath = path.join(
          directoryPath,
          'vehicle_pass_$sanitizedOwnerName.png',
        );

        final file = File(filePath);

        try {
          await file.parent.create(recursive: true);
          await file.writeAsBytes(pngBytes);
        } catch (e) {
          emit(
            state.copyWith(
              isExporting: false,
              error: 'Failed to save file for ${entry.plateNumber}: $e',
            ),
          );
          return;
        }
      }

      emit(state.copyWith(isExporting: false, exportedFilePath: directoryPath));
    } catch (e) {
      emit(state.copyWith(isExporting: false, error: 'Export failed: $e'));
    }
  }

  @override
  Future<void> close() {
    _vehiclesSubscription?.cancel();
    return super.close();
  }
}
