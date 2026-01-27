import 'dart:async';
import 'package:cvms_desktop/features/sanction_management/bloc/sanction_state.dart';
import 'package:cvms_desktop/features/sanction_management/models/saction_model.dart';
import 'package:cvms_desktop/features/sanction_management/models/sanction_tab.dart';
import 'package:cvms_desktop/features/sanction_management/repository/sanction_repository.dart';
import 'package:cvms_desktop/features/sanction_management/widgets/tables/top_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SanctionCubit extends Cubit<SanctionState> {
  final SanctionRepository repository;
  StreamSubscription<List<Sanction>>? _subscription;

  SanctionCubit(this.repository) : super(SanctionState.initial());

  void startListening() {
    emit(state.copyWith(isLoading: true));

    _subscription = repository.watchSanctions().listen(
      (sanctions) {
        emit(state.copyWith(isLoading: false, sanctions: sanctions));
      },
      onError: (_) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Failed to load sanctions',
          ),
        );
      },
    );
  }

  void changeTab(SanctionTab tab) {
    emit(
      state.copyWith(
        activeTab: tab,
        selectedEntries: [],
        isBulkModeEnabled: false,
      ),
    );

    emit(state.copyWith(filteredEntries: _applyFilters()));
  }

  TopBarMetrics getMetrics() {
    //todo
    final all = state.allEntries;

    return TopBarMetrics(
      //todo
      activeSanctions: 0,
      activeSuspensions: 0,
      revokedMVPS: 0,
      expiringSoon: 0,
    );
  }

  void updateSearch(String query) {
    emit(state.copyWith(searchQuery: query));
    emit(state.copyWith(filteredEntries: _applyFilters()));
  }

  void selectEntry(Sanction entry) {
    final currentSelected = List<Sanction>.from(state.selectedEntries);
    if (currentSelected.contains(entry)) {
      currentSelected.remove(entry);
    } else {
      currentSelected.add(entry);
    }
    emit(state.copyWith(selectedEntries: currentSelected));
  }

  void selectAllEntries() {
    final allFiltered = state.filteredEntries;
    final allSelected =
        allFiltered.isNotEmpty &&
        allFiltered.every((entry) => state.selectedEntries.contains(entry));

    if (allSelected) {
      emit(state.copyWith(selectedEntries: []));
    } else {
      emit(state.copyWith(selectedEntries: List<Sanction>.from(allFiltered)));
    }
  }

  void toggleBulkMode() {
    emit(
      state.copyWith(
        isBulkModeEnabled: !state.isBulkModeEnabled,
        selectedEntries: [],
      ),
    );
  }

  List<Sanction> _applyFilters() {
    var filtered = List<Sanction>.from(state.sanctions);

    // TAB FILTER
    switch (state.activeTab) {
      case SanctionTab.all:
        break;
      case SanctionTab.active:
        filtered = filtered.where((s) => s.status.name == 'active').toList();
        break;
      case SanctionTab.suspended:
        filtered = filtered.where((s) => s.type.name == 'suspension').toList();
        break;
      case SanctionTab.revoked:
        filtered = filtered.where((s) => s.type.name == 'revocation').toList();
        break;
      case SanctionTab.expired:
        filtered = filtered.where((s) => s.status.name == 'expired').toList();
        break;
    }

    // SEARCH FILTER
    if (state.searchQuery.isNotEmpty) {
      final q = state.searchQuery.toLowerCase();
      filtered =
          filtered.where((s) {
            return s.vehicleId.toLowerCase().contains(q) ||
                s.offenseNumber.toString().contains(q) ||
                s.type.toString().toLowerCase().contains(q);
          }).toList();
    }

    return filtered;
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
