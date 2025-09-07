import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_model.dart';
part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserState.initial());

  void loadEntries(List<UserEntry> entries) {
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

  void selectEntry(UserEntry entry) {
    if (!state.isBulkModeEnabled) return;

    final currentSelected = List<UserEntry>.from(state.selectedEntries);
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
    final currentSelected = List<UserEntry>.from(state.selectedEntries);

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

  void filterByRole(String role) {
    emit(state.copyWith(roleFilter: role));
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
                e.email.toLowerCase().contains(q) ||
                e.role.toLowerCase().contains(q) ||
                e.status.toLowerCase().contains(q) ||
                e.lastLogin.toLowerCase().contains(q) ||
                e.password.toLowerCase().contains(q);
          }).toList();
    }

    // Apply role dropdown filter
    if (state.roleFilter != 'All') {
      filtered = filtered.where((e) => e.role == state.roleFilter).toList();
    }

    emit(state.copyWith(filteredEntries: filtered));
  }
}
