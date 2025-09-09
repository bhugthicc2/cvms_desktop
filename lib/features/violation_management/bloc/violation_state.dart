part of 'violation_cubit.dart';

class ViolationState {
  final String? message;
  final SnackBarType? messageType;
  final List<ViolationEntry> allEntries;
  final List<ViolationEntry> filteredEntries;
  final List<ViolationEntry> selectedEntries;

  final String dateFilter;
  final String searchQuery;
  final bool isBulkModeEnabled;

  ViolationState({
    this.message,
    this.messageType,
    required this.allEntries,
    required this.filteredEntries,
    required this.selectedEntries,
    required this.dateFilter,
    required this.searchQuery,
    required this.isBulkModeEnabled,
  });

  factory ViolationState.initial() => ViolationState(
    allEntries: [],
    filteredEntries: [],
    selectedEntries: [],
    dateFilter: 'All', //todo implement date filtering
    searchQuery: '',
    isBulkModeEnabled: false,
  );

  ViolationState copyWith({
    String? message,
    SnackBarType? messageType,
    List<ViolationEntry>? allEntries,
    List<ViolationEntry>? filteredEntries,
    List<ViolationEntry>? selectedEntries,
    String? dateFilter,
    String? searchQuery,
    bool? isBulkModeEnabled,
  }) {
    return ViolationState(
      message: message ?? this.message,
      messageType: messageType ?? this.messageType,
      allEntries: allEntries ?? this.allEntries,
      filteredEntries: filteredEntries ?? this.filteredEntries,
      selectedEntries: selectedEntries ?? this.selectedEntries,
      dateFilter: dateFilter ?? this.dateFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      isBulkModeEnabled: isBulkModeEnabled ?? this.isBulkModeEnabled,
    );
  }

  //todo might add loading state soon
}
