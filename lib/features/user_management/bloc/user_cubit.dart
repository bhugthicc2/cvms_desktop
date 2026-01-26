import 'dart:async';
import 'package:cvms_desktop/features/user_management/widgets/tables/top_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../data/user_repository.dart';
part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _repository;
  StreamSubscription<List<UserEntry>>? _usersSubscription;

  UserCubit({required UserRepository repository})
    : _repository = repository,
      super(UserState.initial());

  void listenUsers() {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    _usersSubscription?.cancel();
    _usersSubscription = _repository.getUsersStream().listen(
      (users) {
        emit(
          state.copyWith(
            allEntries: users,
            isLoading: false,
            errorMessage: null,
          ),
        );
        _applyFilters();
      },
      onError: (error) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Failed to load users: $error',
          ),
        );
      },
    );
  }

  Future<void> loadUsers() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final users = await _repository.getUsers();
      emit(
        state.copyWith(allEntries: users, isLoading: false, errorMessage: null),
      );
      _applyFilters();
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load users: $e',
        ),
      );
    }
  }

  Future<void> createUser(UserEntry user) async {
    try {
      await _repository.createUser(user);
      // Stream will automatically update the UI
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to create user: $e'));
    }
  }

  Future<void> updateUser(UserEntry user) async {
    try {
      await _repository.updateUser(user);
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to update user: $e'));
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _repository.deleteUser(userId);
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to delete user: $e'));
    }
  }

  Future<void> bulkDeleteUsers(List<String> userIds) async {
    try {
      await _repository.bulkDeleteUsers(userIds);
      emit(state.copyWith(selectedEntries: []));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to bulk delete users: $e'));
    }
  }

  Future<void> bulkUpdateUserStatus(List<String> userIds, String status) async {
    try {
      await _repository.bulkUpdateUserStatus(userIds, status);
      emit(state.copyWith(selectedEntries: []));
    } catch (e) {
      emit(
        state.copyWith(errorMessage: 'Failed to bulk update user status: $e'),
      );
    }
  }

  TopBarMetrics getMetrics() {
    final all = state.allEntries;

    // Total users count
    final totalUsers = all.length;

    // Active users (status 'active')
    final activeUsers =
        all.where((user) => user.status.toLowerCase() == 'active').length;

    // Inactive users (status 'inactive' or other non-active statuses)
    final inActiveUsers =
        all.where((user) => user.status.toLowerCase() != 'active').length;

    // Users logged in recently (within last 7 days)
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final usersLoggedInRecently =
        all.where((user) => user.lastLogin.isAfter(sevenDaysAgo)).length;

    return TopBarMetrics(
      totalUsers: totalUsers,
      activeUsers: activeUsers,
      inActiveUsers: inActiveUsers,
      usersLoggedInRecently: usersLoggedInRecently,
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

  void filterByRole(String role) {
    emit(state.copyWith(roleFilter: role));
    _applyFilters();
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  void _applyFilters() {
    var filtered = state.allEntries;
    if (state.searchQuery.isNotEmpty) {
      final q = state.searchQuery.toLowerCase();
      filtered =
          filtered.where((e) {
            final lastLoginStr =
                DateFormat('MMM dd, yyyy').format(e.lastLogin).toLowerCase();
            return e.fullname.toLowerCase().contains(q) ||
                e.email.toLowerCase().contains(q) ||
                e.role.toLowerCase().contains(q) ||
                e.status.toLowerCase().contains(q) ||
                lastLoginStr.contains(q);
          }).toList();
    }

    if (state.roleFilter != 'All') {
      filtered = filtered.where((e) => e.role == state.roleFilter).toList();
    }

    emit(state.copyWith(filteredEntries: filtered));
  }

  @override
  Future<void> close() {
    _usersSubscription?.cancel();
    return super.close();
  }
}
