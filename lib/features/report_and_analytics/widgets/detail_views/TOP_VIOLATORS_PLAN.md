# Top Violators Detail View - Implementation Plan

## Overview
A comprehensive view showing students/vehicles with the most violations, with ability to drill down into individual violation reports.

## Structure

### 1. **Chart Section** (Top - 300px height)
- Full-size stacked bar chart
- Shows top violators with violation counts
- Clickable bars to filter/view specific violator
- Uses existing `StackedBarWidget`

### 2. **Summary Statistics Cards** (Row of 4 cards)
- **Total Violators**: Count of unique violators
- **Total Violations**: Sum of all violations  
- **Average per Violator**: Total violations / violator count
- **Most Common Violation**: Type with highest count across all violators

### 3. **Filters & Search Bar** (Container with white background)
- **Search Field**: Search by owner name, plate number
  - Uses `SearchField` widget
  - Real-time filtering
- **Violation Type Filter**: Dropdown to filter by violation type
  - Uses `CustomDropdown` widget
  - Options: All, [dynamically loaded violation types]
- **Date Range Filter**: Last 7 days, 30 days, year, custom range
  - Uses `CustomDropdown` widget
- **Status Filter**: All, Pending, Resolved
  - Uses `CustomDropdown` widget
- **Export Button**: Export to CSV/PDF
  - Uses `CustomButton` with success color
  - Exports current filtered data

### 4. **Main Violators Table** (Full height, scrollable)
Uses `CustomTable` with `SfDataGrid`

**Columns:**
- **#**: Row number (50px width)
- **Owner/Student Name**: Full name (flexible width)
- **Plate Number**: Vehicle plate (150px width)
- **Total Violations**: Count of all violations (120px width)
- **Violation Breakdown**: List of violation types with counts 
  - Format: "Speeding (3), Parking (2), No Helmet (1)"
  - (flexible width, wraps text)
- **Last Violation Date**: Most recent violation date (150px width)
  - Format: "MMM dd, yyyy"
- **Status Summary**: "X Pending, Y Resolved" (150px width)
- **Actions**: "View Details" button (120px width)
  - Uses custom action button
  - Opens individual violation report dialog

**Features:**
- Sortable columns
- Pagination (50 rows per page)
- Row click opens individual report
- Alternating row colors

### 5. **Individual Violation Report Dialog**
Uses `CustomDialog` widget (width: 900px, height: 700px)

**Triggered by:**
- Clicking "View Details" button in table
- Clicking on a chart bar point
- Clicking on a table row

**Content Structure:**

**Header Section** (Top):
- Owner Name (read-only text field)
- Plate Number (read-only text field)
- Vehicle Details: Model, Type, Color (read-only text fields)
- Summary Stats: Total Violations, Pending Count, Resolved Count

**Violation History Table** (Middle - scrollable):
- Uses `CustomTable` with violation entries
- Columns: Date/Time, Violation Type, Status, Reported By, Actions
- Actions: Toggle Status button (similar to violation management)
- Shows all violations for selected violator

**Statistics Section** (Bottom):
- Violations by Type: Small donut/bar chart
- Resolution Rate: Percentage card
- Timeline: Optional mini line chart showing violations over time

**Actions:**
- Close button (dialog default)
- Export button: Export individual report to PDF/CSV

## Data Model

### ViolatorSummary Model (to be created)
```dart
class ViolatorSummary {
  final String ownerName;
  final String plateNumber;
  final String vehicleID;
  final int totalViolations;
  final Map<String, int> violationTypeCounts; // {violationType: count}
  final DateTime lastViolationDate;
  final int pendingCount;
  final int resolvedCount;
  final List<ViolationEntry> violations; // All violations for this violator
  
  // Helper methods
  String get violationBreakdown => violationTypeCounts.entries
    .map((e) => '${e.key} (${e.value})')
    .join(', ');
    
  String get statusSummary => '$pendingCount Pending, $resolvedCount Resolved';
}
```

## Implementation Steps

### Phase 1: Data Layer
1. **Create ViolatorSummary Model**
   - File: `lib/features/report_and_analytics/models/violator_summary_model.dart`
   - Aggregate violation data by owner/plate
   - Calculate statistics

2. **Update Analytics Repository**
   - Add method: `Future<List<ViolatorSummary>> fetchViolatorSummaries()`
   - Group violations by owner/plate
   - Calculate summary statistics
   - Fetch all violations for each violator

### Phase 2: UI Components
3. **Create Violators Table Components**
   - `violators_table_columns.dart`: Define table columns
   - `violators_data_source.dart`: Data source for table
   - `violators_table.dart`: Main table widget

4. **Create Individual Violation Report Dialog**
   - `individual_violation_report_dialog.dart`
   - Uses `CustomDialog` wrapper
   - Contains violation history table
   - Statistics section

5. **Update Top Violators Detail View**
   - Add summary cards
   - Add filters/search bar
   - Add violators table
   - Wire up click handlers

### Phase 3: Filtering & Export
6. **Add Filtering Logic**
   - Search functionality (owner name, plate number)
   - Filter by violation type
   - Filter by date range
   - Filter by status
   - Update table based on filters

7. **Implement Export**
   - CSV export of violators list
   - PDF export of individual reports

## File Structure
```
lib/features/report_and_analytics/
  ├── models/
  │   ├── chart_data_model.dart (existing)
  │   └── violator_summary_model.dart (new)
  ├── widgets/
  │   ├── detail_views/
  │   │   └── top_violators_detail_view.dart (update)
  │   ├── tables/
  │   │   ├── violators_table.dart (new)
  │   │   └── violators_table_columns.dart (new)
  │   ├── dialogs/
  │   │   └── individual_violation_report_dialog.dart (new)
  │   └── datasource/
  │       └── violators_data_source.dart (new)
  └── data/
      ├── analytics_repository.dart (update interface)
      └── firestore_analytics_repository.dart (update implementation)
```

## UI Layout Example

```
┌─────────────────────────────────────────────────────────┐
│  Chart Section (300px)                                  │
│  [Stacked Bar Chart - Top Violators]                    │
└─────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────┐
│  Summary Cards (Row)                                     │
│  [Total Violators] [Total Violations]                  │
│  [Average] [Most Common]                                │
└─────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────┐
│  Filters & Search                                        │
│  [Search] [Type Filter] [Date Filter] [Status] [Export]│
└─────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────┐
│  Violators Table (Expanded)                             │
│  # | Owner | Plate | Total | Breakdown | Last | Status │
│  1 | John  | ABC-1 |   15  | Speeding  | ...  | 5P,10R │
│  2 | Jane  | XYZ-2 |   12  | Parking   | ...  | 3P,9R  │
│  ...                                                     │
│  [Pagination Controls]                                  │
└─────────────────────────────────────────────────────────┘
```

## Next Steps
1. Review and approve this plan
2. Start with Phase 1 (Data Layer)
3. Implement Phase 2 (UI Components)
4. Complete Phase 3 (Filtering & Export)

