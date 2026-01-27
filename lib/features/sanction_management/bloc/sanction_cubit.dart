import 'dart:async';

import 'package:cvms_desktop/features/sanction_management/models/saction_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/sanction_enums.dart';
import '../models/sanction_tab.dart';
import '../repository/sanction_repository.dart';
import '../widgets/tables/top_bar.dart';
import 'sanction_state.dart';

class SanctionCubit extends Cubit<SanctionState> {
  final SanctionRepository repository;
  StreamSubscription<List<Sanction>>? _subscription;

  SanctionCubit(this.repository) : super(SanctionState.initial());

  /// 🔌 Start listening to sanctions
  void startListening() {
    emit(state.copyWith(isLoading: true));

    _subscription = repository.watchSanctions().listen(
      (sanctions) async {
        //  Evaluate active sanctions (client-side expiry)
        for (final sanction in sanctions) {
          if (sanction.status == SanctionStatus.active &&
              sanction.type == SanctionType.suspension) {
            await repository.evaluateSanctionIfNeeded(sanction);
          }
        }

        emit(
          state.copyWith(
            isLoading: false,
            sanctions: sanctions,
            filteredEntries: _applyFilters(
              sanctions: sanctions,
              tab: state.activeTab,
              searchQuery: state.searchQuery,
            ),
          ),
        );
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

  ///  Change active tab
  void changeTab(SanctionTab tab) {
    emit(
      state.copyWith(
        activeTab: tab,
        selectedEntries: [],
        isBulkModeEnabled: false,
        filteredEntries: _applyFilters(
          sanctions: state.sanctions,
          tab: tab,
          searchQuery: state.searchQuery,
        ),
      ),
    );
  }

  ///  Metrics for top bar
  TopBarMetrics getMetrics() {
    final all = state.sanctions;

    return TopBarMetrics(
      activeSanctions:
          all.where((s) => s.status == SanctionStatus.active).length,

      activeSuspensions:
          all
              .where(
                (s) =>
                    s.status == SanctionStatus.active &&
                    s.type == SanctionType.suspension,
              )
              .length,

      revokedMVPS: all.where((s) => s.type == SanctionType.revocation).length,

      expiringSoon:
          all
              .where(
                (s) =>
                    s.status == SanctionStatus.active &&
                    s.endAt != null &&
                    s.endAt!.isBefore(
                      DateTime.now().add(const Duration(days: 3)),
                    ),
              )
              .length,
    );
  }

  /// Search filter
  void updateSearch(String query) {
    emit(
      state.copyWith(
        searchQuery: query,
        filteredEntries: _applyFilters(
          sanctions: state.sanctions,
          tab: state.activeTab,
          searchQuery: query,
        ),
      ),
    );
  }

  /// ☑ Select row
  void selectEntry(Sanction entry) {
    final selected = List<Sanction>.from(state.selectedEntries);

    selected.contains(entry) ? selected.remove(entry) : selected.add(entry);

    emit(state.copyWith(selectedEntries: selected));
  }

  /// ☑ Select all rows
  void selectAllEntries() {
    final allFiltered = state.filteredEntries;
    final allSelected =
        allFiltered.isNotEmpty &&
        allFiltered.every(state.selectedEntries.contains);

    emit(
      state.copyWith(
        selectedEntries: allSelected ? [] : List<Sanction>.from(allFiltered),
      ),
    );
  }

  ///  Toggle bulk mode
  void toggleBulkMode() {
    emit(
      state.copyWith(
        isBulkModeEnabled: !state.isBulkModeEnabled,
        selectedEntries: [],
      ),
    );
  }

  /// Core filtering logic
  List<Sanction> _applyFilters({
    required List<Sanction> sanctions,
    required SanctionTab tab,
    required String searchQuery,
  }) {
    var filtered = List<Sanction>.from(sanctions);

    switch (tab) {
      case SanctionTab.all:
        break;
      case SanctionTab.active:
        filtered =
            filtered.where((s) => s.status == SanctionStatus.active).toList();
        break;
      case SanctionTab.suspended:
        filtered =
            filtered.where((s) => s.type == SanctionType.suspension).toList();
        break;
      case SanctionTab.revoked:
        filtered =
            filtered.where((s) => s.type == SanctionType.revocation).toList();
        break;
      case SanctionTab.expired:
        filtered =
            filtered.where((s) => s.status == SanctionStatus.expired).toList();
        break;
    }

    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      filtered =
          filtered.where((s) {
            return s.vehicleId.toLowerCase().contains(q) ||
                s.offenseNumber.toString().contains(q) ||
                s.type.name.contains(q);
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
