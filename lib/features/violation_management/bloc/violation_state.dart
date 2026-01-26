part of 'violation_cubit.dart';

class ViolationState {
  final String? message;
  final SnackBarType? messageType;
  final List<ViolationEntry> allEntries;
  final List<ViolationEntry> filteredEntries;
  final List<ViolationEntry> selectedEntries;
  final List<ViolationEntry> pendingEntries;
  final ViolationTab activeTab;

  final String dateFilter;
  final String searchQuery;
  final bool isBulkModeEnabled;
  final bool isLoading;

  ViolationState({
    this.message,
    this.messageType,
    required this.allEntries,
    required this.filteredEntries,
    required this.selectedEntries,
    required this.pendingEntries,
    required this.dateFilter,
    required this.searchQuery,
    required this.isBulkModeEnabled,
    this.isLoading = false,
    this.activeTab = ViolationTab.all,
  });

  factory ViolationState.initial() => ViolationState(
    allEntries: [],
    filteredEntries: [],
    selectedEntries: [],
    pendingEntries: [],
    dateFilter: 'All', //todo implement date filtering
    searchQuery: '',
    isBulkModeEnabled: false,
    isLoading: true,
    activeTab: ViolationTab.all,
  );

  ViolationState copyWith({
    ViolationStatus? violationStatusFilter,
    String? message,
    SnackBarType? messageType,
    List<ViolationEntry>? allEntries,
    List<ViolationEntry>? filteredEntries,
    List<ViolationEntry>? selectedEntries,
    List<ViolationEntry>? pendingEntries,
    String? dateFilter,
    String? searchQuery,
    bool? isBulkModeEnabled,
    bool? isLoading,
    ViolationTab? activeTab,
  }) {
    return ViolationState(
      message: message ?? this.message,
      messageType: messageType ?? this.messageType,
      allEntries: allEntries ?? this.allEntries,
      filteredEntries: filteredEntries ?? this.filteredEntries,
      selectedEntries: selectedEntries ?? this.selectedEntries,
      pendingEntries: pendingEntries ?? this.pendingEntries,
      dateFilter: dateFilter ?? this.dateFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      isBulkModeEnabled: isBulkModeEnabled ?? this.isBulkModeEnabled,
      isLoading: isLoading ?? this.isLoading,
      activeTab: activeTab ?? this.activeTab,
    );
  }

  // Loading state added for skeletonizer
}
