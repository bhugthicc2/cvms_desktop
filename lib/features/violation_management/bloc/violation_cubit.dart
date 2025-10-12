import 'dart:async';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_model.dart';
import 'package:cvms_desktop/features/violation_management/data/violation_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'violation_state.dart';

class ViolationCubit extends Cubit<ViolationState> {
  final ViolationRepository _repository = ViolationRepository();
  StreamSubscription<List<ViolationEntry>>? _violationsSubscription;

  ViolationCubit() : super(ViolationState.initial());

  void loadEntries(List<ViolationEntry> entries) {
    emit(state.copyWith(allEntries: entries));
    _applyFilters();
  }

  Future<void> loadViolations() async {
    try {
      final violations = await _repository.fetchViolations();
      emit(state.copyWith(allEntries: violations));
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading violations: $e');
    }
  }

  void listenViolations() {
    _violationsSubscription?.cancel();
    _violationsSubscription = _repository.watchViolations().listen(
      (violations) {
        if (!isClosed) {
          emit(state.copyWith(allEntries: violations));
          _applyFilters();
        }
      },
      onError: (error) {
        if (!isClosed) {
          debugPrint('Error in violations stream: $error');
        }
      },
    );
  }

  Future<void> addViolationReport({
    required String plateNumber,
    required String owner,
    required String violation,
    required String reportedBy,
    required String vehicleID,
    String? reportReason,
  }) async {
    try {
      await _repository.createViolationReport(
        plateNumber: plateNumber,
        owner: owner,
        violation: violation,
        reportedBy: reportedBy,
        additionalData: {
          'vehicleID': vehicleID,
          if (reportReason != null) 'reportReason': reportReason,
        },
      );
      await loadViolations();
    } catch (e) {
      debugPrint('Error adding violation report: $e');
      rethrow;
    }
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

  void selectEntry(ViolationEntry entry) {
    if (!state.isBulkModeEnabled) return;

    final currentSelected = List<ViolationEntry>.from(state.selectedEntries);
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
    final currentSelected = List<ViolationEntry>.from(state.selectedEntries);

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

  void clearMessage() {
    emit(state.copyWith(message: null, messageType: null));
  }

  //todo fix the problem and freezing issue
  Future<void> toggleViolationStatus(ViolationEntry entry) async {
    try {
      final newStatus =
          entry.status.toLowerCase() == 'resolved' ? 'pending' : 'resolved';

      await _repository.updateViolationStatus(entry.violationID, newStatus);

      final updatedEntries =
          state.allEntries.map((e) {
            if (e == entry) {
              return ViolationEntry(
                violationID: e.violationID,
                dateTime: e.dateTime,
                reportedBy: e.reportedBy,
                plateNumber: e.plateNumber,
                vehicleID: e.vehicleID,
                owner: e.owner,
                violation: e.violation,
                status: newStatus,
              );
            }
            return e;
          }).toList();

      emit(state.copyWith(allEntries: updatedEntries));
      _applyFilters();

      emit(
        state.copyWith(
          allEntries: updatedEntries,
          message: 'Violation status changed to ${newStatus.toUpperCase()}',
          messageType: SnackBarType.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          message: 'Failed to update violation status: ${e.toString()}',
          messageType: SnackBarType.error,
        ),
      );
    }
  }

  //todo fix the problem and freezing issue

  void filterEntries(String query) {
    emit(state.copyWith(searchQuery: query));
    _applyFilters();
  }

  void filterByDate(String type) {
    emit(state.copyWith(dateFilter: type));
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = state.allEntries;

    if (state.searchQuery.isNotEmpty) {
      final q = state.searchQuery.toLowerCase();
      filtered =
          filtered.where((e) {
            return e.dateTime.toDate().toString().toLowerCase().contains(q) ||
                e.reportedBy.toLowerCase().contains(q) ||
                e.plateNumber.toLowerCase().contains(q) ||
                e.owner.toLowerCase().contains(q) ||
                e.violation.toLowerCase().contains(q) ||
                e.status.toLowerCase().contains(q);
          }).toList();
    }

    if (state.dateFilter != 'All') {
      filtered =
          filtered
              .where(
                (e) =>
                    e.dateTime.toDate().toString().toLowerCase() ==
                    state.dateFilter.toLowerCase(),
              )
              .toList();
    }

    emit(state.copyWith(filteredEntries: filtered));
  }

  @override
  Future<void> close() {
    _violationsSubscription?.cancel();
    return super.close();
  }
}
