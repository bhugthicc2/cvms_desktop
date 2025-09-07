import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'violation_state.dart';

class ViolationCubit extends Cubit<ViolationState> {
  ViolationCubit() : super(ViolationState.initial());

  void loadEntries(List<ViolationEntry> entries) {
    emit(state.copyWith(allEntries: entries));
    _applyFilters(); // ensure filteredEntries is set
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

    // If all are selected, deselect all; otherwise select all
    final allSelected = allFiltered.every(
      (entry) => currentSelected.contains(entry),
    );

    if (allSelected) {
      // Remove all filtered entries from selection
      currentSelected.removeWhere((entry) => allFiltered.contains(entry));
    } else {
      // Add all filtered entries to selection
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

  void toggleViolationStatus(ViolationEntry entry, BuildContext context) {
    final updatedEntries =
        state.allEntries.map((e) {
          if (e == entry) {
            // Create a new ViolationEntry with toggled status
            return ViolationEntry(
              dateTime: e.dateTime,
              reportedBy: e.reportedBy,
              plateNumber: e.plateNumber,
              owner: e.owner,
              violation: e.violation,
              status:
                  e.status.toLowerCase() == 'resolved' ? 'pending' : 'resolved',
            );
          }
          return e;
        }).toList();

    emit(state.copyWith(allEntries: updatedEntries));
    _applyFilters(); // Reapply filters to update filteredEntries

    // Show success snackbar
    final newStatus =
        entry.status.toLowerCase() == 'resolved' ? 'pending' : 'resolved';
    CustomSnackBar.show(
      context: context,
      message: 'Violation status changed to ${newStatus.toUpperCase()}',
      type: SnackBarType.success,
    );
  }

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

    // Apply search filter
    if (state.searchQuery.isNotEmpty) {
      final q = state.searchQuery.toLowerCase();
      filtered =
          filtered.where((e) {
            return e.dateTime.toLowerCase().contains(q) ||
                e.reportedBy.toLowerCase().contains(q) ||
                e.plateNumber.toLowerCase().contains(q) ||
                e.owner.toLowerCase().contains(q) ||
                e.violation.toLowerCase().contains(q) ||
                e.status.toLowerCase().contains(q);
          }).toList();
    }

    // Apply date dropdown filter
    if (state.dateFilter != 'All') {
      filtered =
          filtered
              .where((e) => e.dateTime == state.dateFilter.toLowerCase())
              .toList();
    }

    emit(state.copyWith(filteredEntries: filtered));
  }
}
