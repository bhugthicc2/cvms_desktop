// VEHICLE ID REFERENCE UPDATE MARKER
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

  Future<void> loadEntries(List<ViolationEntry> entries) async {
    final enriched = await _repository.enrichViolationsWithRelatedInfo(entries);
    if (!isClosed) {
      emit(state.copyWith(allEntries: enriched));
      _applyFilters();
    }
  }

  void listenViolations() {
    emit(state.copyWith(isLoading: true));
    _violationsSubscription?.cancel();
    _violationsSubscription = _repository.watchViolations().listen(
      (violations) {
        if (!isClosed) {
          emit(state.copyWith(allEntries: violations, isLoading: false));
          _applyFilters();
        }
      },
      onError: (error) {
        if (!isClosed) {
          debugPrint('Error in violations stream: $error');
          emit(state.copyWith(isLoading: false));
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

  // todo: The freezing issue may be related to rapid state emissions or unoptimized filtering. Consider debouncing filters if needed.
  Future<void> toggleViolationStatus(ViolationEntry entry) async {
    try {
      final newStatus =
          entry.status.toLowerCase() == 'resolved' ? 'pending' : 'resolved';
      await _repository.updateViolationStatus(entry.id, newStatus);
      final updatedEntries =
          state.allEntries.map((e) {
            if (e == entry) {
              return e.copyWith(status: newStatus);
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

  // todo: The freezing issue may be related to rapid state emissions or unoptimized filtering. Consider debouncing filters if needed.
  void filterEntries(String query) {
    emit(state.copyWith(searchQuery: query, isLoading: false));
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
            return e.reportedByUserId.toLowerCase().contains(q) ||
                e.violationType.toLowerCase().contains(q) ||
                e.status.toLowerCase().contains(q) ||
                e.ownerName.toLowerCase().contains(q) ||
                e.plateNumber.toLowerCase().contains(q) ||
                e.fullname.toLowerCase().contains(q);
          }).toList();
    }
    if (state.dateFilter != 'All') {
      // todo: Implement proper date filtering (e.g., compare dates parsed to 'Today', 'Yesterday', etc.)
      // Current implementation is placeholder and may not work as expected
      filtered =
          filtered
              .where(
                (e) =>
                    e.reportedAt.toDate().toString().toLowerCase() ==
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
