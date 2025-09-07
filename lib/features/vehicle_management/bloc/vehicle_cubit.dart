import 'package:cvms_desktop/features/vehicle_management/models/vehicle_entry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'vehicle_state.dart';

class VehicleCubit extends Cubit<VehicleState> {
  VehicleCubit() : super(VehicleState.initial());

  void loadEntries(List<VehicleEntry> entries) {
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

    // Apply search filter
    if (state.searchQuery.isNotEmpty) {
      final q = state.searchQuery.toLowerCase();
      filtered =
          filtered.where((e) {
            return e.name.toLowerCase().contains(q) ||
                e.vehicle.toLowerCase().contains(q) ||
                e.schoolID.toLowerCase().contains(q) ||
                e.plateNumber.toLowerCase().contains(q) ||
                e.vehicleModel.toLowerCase().contains(q) ||
                e.vehicleType.toLowerCase().contains(q) ||
                e.status.toLowerCase().contains(q) ||
                e.vehicleColor.toLowerCase().contains(q) ||
                e.violationStatus.toLowerCase().contains(q);
          }).toList();
    }

    // Apply status dropdown filter
    if (state.statusFilter != 'All') {
      filtered =
          filtered
              .where((e) => e.status == state.statusFilter.toLowerCase())
              .toList();
    }

    // Apply type dropdown filter
    if (state.typeFilter != 'All') {
      filtered =
          filtered.where((e) => e.vehicleType == state.typeFilter).toList();
    }

    emit(state.copyWith(filteredEntries: filtered));
  }
}
