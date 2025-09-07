part of 'user_cubit.dart';

class UserState {
  final List<UserEntry> allEntries;
  final List<UserEntry> filteredEntries;
  final List<UserEntry> selectedEntries;
  final String roleFilter;
  final String searchQuery;
  final bool isBulkModeEnabled;

  UserState({
    required this.allEntries,
    required this.filteredEntries,
    required this.selectedEntries,
    required this.roleFilter,
    required this.searchQuery,
    required this.isBulkModeEnabled,
  });

  factory UserState.initial() => UserState(
    allEntries: [],
    filteredEntries: [],
    selectedEntries: [],
    roleFilter: 'All',
    searchQuery: '',
    isBulkModeEnabled: false,
  );

  UserState copyWith({
    List<UserEntry>? allEntries,
    List<UserEntry>? filteredEntries,
    List<UserEntry>? selectedEntries,
    String? roleFilter,
    String? searchQuery,
    bool? isBulkModeEnabled,
  }) {
    return UserState(
      allEntries: allEntries ?? this.allEntries,
      filteredEntries: filteredEntries ?? this.filteredEntries,
      selectedEntries: selectedEntries ?? this.selectedEntries,
      roleFilter: roleFilter ?? this.roleFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      isBulkModeEnabled: isBulkModeEnabled ?? this.isBulkModeEnabled,
    );
  }
}
