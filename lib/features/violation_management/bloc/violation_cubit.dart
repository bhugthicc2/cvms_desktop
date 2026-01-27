// VEHICLE ID REFERENCE UPDATE MARKER
import 'dart:async';
import 'package:cvms_desktop/core/widgets/app/custom_snackbar.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_model.dart';
import 'package:cvms_desktop/features/violation_management/data/violation_repository.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_enums.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_tab.dart';
import 'package:cvms_desktop/features/violation_management/widgets/tables/top_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'violation_state.dart';

class ViolationCubit extends Cubit<ViolationState> {
  final ViolationRepository _repository = ViolationRepository();
  StreamSubscription<List<ViolationEntry>>? _violationsSubscription;

  ViolationCubit() : super(ViolationState.initial());

  void listenViolations() {
    emit(state.copyWith(isLoading: true));
    _violationsSubscription?.cancel();

    _violationsSubscription = _repository.watchViolations().listen(
      (violations) {
        if (isClosed) return;

        // Check if data actually changed to prevent unnecessary rebuilds
        final currentData = state.allEntries;
        bool dataChanged = false;

        if (currentData.length != violations.length) {
          dataChanged = true;
        } else {
          for (int i = 0; i < violations.length; i++) {
            if (i >= currentData.length ||
                currentData[i].id != violations[i].id ||
                currentData[i].status != violations[i].status) {
              dataChanged = true;
              break;
            }
          }
        }

        if (!dataChanged) {
          return;
        }

        // Only apply filters if we have violations, otherwise use all violations
        final filtered =
            violations.isNotEmpty ? _applyFilters(violations) : violations;

        emit(
          state.copyWith(
            allEntries: violations,
            filteredEntries: filtered,
            isLoading: false,
          ),
        );
      },
      onError: (error) {
        emit(state.copyWith(isLoading: false));
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

  void filterEntries(String query) {
    emit(state.copyWith(searchQuery: query, isLoading: false));
    final filtered = _applyFilters();
    emit(state.copyWith(filteredEntries: filtered));
  }

  void filterByDate(String type) {
    emit(state.copyWith(dateFilter: type));
    final filtered = _applyFilters();
    emit(state.copyWith(filteredEntries: filtered));
  }

  List<ViolationEntry> _applyFilters([List<ViolationEntry>? entries]) {
    var filtered = List<ViolationEntry>.from(entries ?? state.allEntries);

    // TAB FILTER
    switch (state.activeTab) {
      case ViolationTab.pending:
        filtered = filtered.where((v) => v.isPending).toList();
        break;

      case ViolationTab.confirmed:
        filtered = filtered.where((v) => v.isConfirmed).toList();
        break;

      case ViolationTab.dismissed:
        filtered = filtered.where((v) => v.isDismissed).toList();
        break;

      case ViolationTab.sanctioned:
        filtered = filtered.where((v) => v.isSanctioned).toList();
        break;

      case ViolationTab.all:
        break;
    }

    // SEARCH FILTER
    if (state.searchQuery.isNotEmpty) {
      final q = state.searchQuery.toLowerCase();
      filtered =
          filtered.where((e) {
            return e.violationType.toLowerCase().contains(q) ||
                e.ownerName.toLowerCase().contains(q) ||
                e.plateNumber.toLowerCase().contains(q) ||
                e.fullname.toLowerCase().contains(q);
          }).toList();
    }

    return filtered;
  }

  Future<void> updateViolationStatus({
    required String violationId,
    required ViolationStatus status,
    required String confirmedByUserId,
  }) async {
    try {
      emit(state.copyWith(isLoading: true));

      await _repository.updateViolationStatus(
        violationIds: [violationId],
        status: status,
        confirmedByUserId: confirmedByUserId,
      );

      if (!isClosed) {
        emit(
          state.copyWith(
            message: 'Violation status updated successfully',
            messageType: SnackBarType.success,
            isLoading: false,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            message: 'Failed to update violation status: ${e.toString()}',
            messageType: SnackBarType.error,
            isLoading: false,
          ),
        );
      }
    }
  }

  Future<void> updateSelectedStatus({
    required ViolationStatus status,
    required String confirmedByUserId,
  }) async {
    if (state.selectedEntries.isEmpty) return;

    try {
      emit(state.copyWith(isLoading: true));

      final ids = state.selectedEntries.map((e) => e.id).toList();

      await _repository.updateViolationStatus(
        violationIds: ids,
        status: status,
        confirmedByUserId: confirmedByUserId,
      );

      if (!isClosed) {
        emit(
          state.copyWith(
            message: 'Violation status updated successfully',
            messageType: SnackBarType.success,
            selectedEntries: [],
            isBulkModeEnabled: false,
            isLoading: false,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            message: 'Failed to update violation status',
            messageType: SnackBarType.error,
            isLoading: false,
          ),
        );
      }
    }
  }

  TopBarMetrics getMetrics() {
    final all = state.allEntries;

    return TopBarMetrics(
      pendingViolations: all.where((v) => v.isPending).length,
      confirmedViolations: all.where((v) => v.isConfirmed).length,
      dismissedViolations: all.where((v) => v.isDismissed).length,
      sanctionedVehicles: all.where((v) => v.isSanctioned).length,
    );
  }

  void changeTab(ViolationTab tab) {
    emit(
      state.copyWith(
        activeTab: tab,
        selectedEntries: [],
        isBulkModeEnabled: false,
      ),
    );

    emit(state.copyWith(filteredEntries: _applyFilters()));
  }

  @override
  Future<void> close() {
    _violationsSubscription?.cancel();

    return super.close();
  }
}
