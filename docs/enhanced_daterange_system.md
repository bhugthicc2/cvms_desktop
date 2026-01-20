# Enhanced DateRange System Documentation

## Overview

This document describes the enhanced DateRange system implemented to provide intelligent period formatting for PDF reports and UI displays. The system addresses the issue where date ranges were always displayed in "start - end" format, even for whole months or years.

## Problem Statement

### Previous Issues

- **Whole months** displayed as "Jan 1, 2026 - Jan 31, 2026" instead of "January 2026"
- **Whole years** displayed as "Jan 1, 2026 - Dec 31, 2026" instead of "2026"
- **Inconsistent formatting** across different period types
- **Confusing user experience** when generating reports

### Root Cause

The original `DateRange` class always used the default constructor which set `type = DatePeriodType.customRange`, regardless of the actual period type selected by the user.

## Solution Architecture

### 1. Enhanced DateRange Class

**Location**: `lib/features/dashboard2/models/report/date_range.dart`

```dart
enum DatePeriodType {
  day, week, month, year, customRange,
}

class DateRange {
  final DateTime start;
  final DateTime end;
  final DatePeriodType type;

  // Factory constructors for different period types
  factory DateRange.day(DateTime date) => DateRange(date, date, DatePeriodType.day);
  factory DateRange.week(DateTime start, DateTime end) => DateRange(start, end, DatePeriodType.week);
  factory DateRange.month(int year, int month) => DateRange(start, end, DatePeriodType.month);
  factory DateRange.year(int year) => DateRange(start, end, DatePeriodType.year);
  factory DateRange.customRange(DateTime start, DateTime end) => DateRange(start, end, DatePeriodType.customRange);

  @override
  String toString() {
    switch (type) {
      case DatePeriodType.day:
        return DateTimeFormatter.formatAbbreviated(start);
      case DatePeriodType.week:
        return '${DateTimeFormatter.formatAbbreviated(start)} - ${DateTimeFormatter.formatAbbreviated(end)}';
      case DatePeriodType.month:
        return '${monthNames[start.month - 1]} ${start.year}';
      case DatePeriodType.year:
        return start.year.toString();
      case DatePeriodType.customRange:
        return '${DateTimeFormatter.formatAbbreviated(start)} - ${DateTimeFormatter.formatAbbreviated(end)}';
    }
  }
}
```

### 2. Smart toString() Method

The enhanced `toString()` method provides intelligent formatting based on period type:

| Period Type  | Input                    | Output                    |
| ------------ | ------------------------ | ------------------------- |
| Day          | 2026-01-20               | "Jan. 20, 2026"           |
| Week         | 2026-01-15 to 2026-01-22 | "Jan. 15 - Jan. 22, 2026" |
| Month        | January 2026             | "January 2026"            |
| Year         | 2026                     | "2026"                    |
| Custom Range | 2026-01-20 to 2026-01-23 | "Jan. 20 - Jan. 23, 2026" |

### 3. CustomDateFilter Integration

**Location**: `lib/core/widgets/app/custom_date_filter.dart`

The date filter was updated to use the appropriate factory constructors:

```dart
switch (_selectedMode) {
  case 'Month':
    _selectedPeriod = DateRange.month(start.year, start.month);
    break;
  case 'Year':
    _selectedPeriod = DateRange.year(start.year);
    break;
  case 'Week':
    _selectedPeriod = DateRange.week(start, end);
    break;
  case 'Day':
    _selectedPeriod = DateRange.day(start);
    break;
  case 'Range':
    _selectedPeriod = DateRange.customRange(start, end);
    break;
}
```

### 4. Report Generation Pipeline Updates

#### IndividualReportQuery

**Location**: `lib/features/dashboard2/models/report/individual_report_query.dart`

```dart
class IndividualReportQuery {
  final String vehicleId;
  final DateRange range;  // Changed from separate start/end
  final IndividualReportOptions options;
}
```

#### IndividualReportAssembler

**Location**: `lib/features/dashboard2/assemblers/report/individual_report_assembler.dart`

```dart
Future<IndividualVehicleReportModel> assemble(IndividualReportQuery query) async {
  final range = query.range; // Use original DateRange object
  // ... rest of assembly logic
}
```

#### IndividualPdfExportUseCase

**Location**: `lib/features/dashboard2/use_cases/pdf/individual_pdf_export_usecase.dart`

```dart
final report = await assembler.assemble(
  IndividualReportQuery(
    vehicleId: vehicleId,
    range: range, // Pass entire DateRange object
    options: options,
  ),
);
```

## Implementation Details

### Key Changes Made

1. **DateRange Class Enhancement**
   - Added `DatePeriodType` enum
   - Added factory constructors for each period type
   - Enhanced `toString()` method with smart formatting
   - Maintained backward compatibility

2. **CustomDateFilter Updates**
   - Integrated with new factory constructors
   - Preserved period type information
   - Maintained existing UI behavior

3. **Report Pipeline Refactoring**
   - Updated `IndividualReportQuery` to accept `DateRange` object
   - Modified assembler to preserve original DateRange
   - Updated use cases to pass complete DateRange objects

4. **ReportPeriod.resolve() Fix**
   - Updated to use factory constructors instead of default constructor
   - Ensures proper period type assignment

### Files Modified

| File                                 | Purpose              | Key Changes                             |
| ------------------------------------ | -------------------- | --------------------------------------- |
| `date_range.dart`                    | Core DateRange class | Added enum, factories, smart toString() |
| `custom_date_filter.dart`            | Date picker UI       | Uses factory constructors               |
| `individual_report_query.dart`       | Report query model   | Accepts DateRange object                |
| `individual_report_assembler.dart`   | Report assembly      | Preserves DateRange type                |
| `individual_pdf_export_usecase.dart` | PDF export           | Passes DateRange object                 |
| `report_period.dart`                 | Period resolution    | Uses factory constructors               |

## Usage Examples

### Creating DateRange Objects

```dart
// Single day
final dayRange = DateRange.day(DateTime(2026, 1, 20));
print(dayRange.toString()); // "Jan. 20, 2026"

// Whole month
final monthRange = DateRange.month(2026, 1);
print(monthRange.toString()); // "January 2026"

// Whole year
final yearRange = DateRange.year(2026);
print(yearRange.toString()); // "2026"

// Custom range
final customRange = DateRange.customRange(
  DateTime(2026, 1, 20),
  DateTime(2026, 1, 23),
);
print(customRange.toString()); // "Jan. 20 - Jan. 23, 2026"
```

### PDF Generation

```dart
// In PDF builder
pw.Align(
  alignment: pw.Alignment.center,
  child: PdfSubtitleText(
    label: 'Period: ',
    value: '${data.period}', // Automatically calls toString()
  ),
),
```

## Benefits

### User Experience

✅ **Clear Communication**: "January 2026" instead of "Jan 1, 2026 - Jan 31, 2026"  
✅ **Professional Reports**: Clean, readable period labels  
✅ **Intuitive Display**: Format matches user expectations

### Developer Experience

✅ **Type Safety**: Factory constructors ensure correct period types  
✅ **Maintainable**: Single source of truth for formatting logic  
✅ **Extensible**: Easy to add new period types

### System Architecture

✅ **Consistent**: Same formatting across UI and PDF  
✅ **Scalable**: Supports future period type additions  
✅ **Backward Compatible**: Existing code continues to work

## Testing

### Manual Testing Steps

1. **Open Date Picker**: Click date selection button
2. **Select Month Mode**: Choose "Month" segment button
3. **Pick Any Date**: Click any date in desired month
4. **Generate PDF**: Click "Apply Filter" then generate report
5. **Verify Output**: Check PDF shows "January 2026" format

### Expected Results

| Selection Mode | Expected PDF Output       |
| -------------- | ------------------------- |
| Day            | "Jan. 20, 2026"           |
| Week           | "Jan. 15 - Jan. 22, 2026" |
| Month          | "January 2026"            |
| Year           | "2026"                    |
| Custom Range   | "Jan. 20 - Jan. 23, 2026" |

## Migration Guide

### For Existing Code

If you have existing code that creates DateRange objects:

```dart
// Old way (still works but loses type information)
final range = DateRange(start, end);

// New way (preserves type information)
final range = DateRange.month(year, month);
```

### For New Development

Always use the appropriate factory constructor:

```dart
// Use factory constructors
final dayRange = DateRange.day(date);
final monthRange = DateRange.month(year, month);
final yearRange = DateRange.year(year);
final weekRange = DateRange.week(start, end);
final customRange = DateRange.customRange(start, end);
```

## Future Enhancements

### Potential Additions

1. **Quarter Support**: `DateRange.quarter(year, quarter)`
2. **Semester Support**: `DateRange.semester(year, semester)`
3. **Fiscal Year**: `DateRange.fiscalYear(startMonth)`
4. **Academic Year**: `DateRange.academicYear(startYear)`

### Localization Support

The system can be extended to support localized month names:

```dart
// Future enhancement
String toString([Locale? locale]) {
  switch (type) {
    case DatePeriodType.month:
      return formatMonthName(start.month, start.year, locale);
    // ... other cases
  }
}
```

## Troubleshooting

### Common Issues

1. **Still Showing Range Format**
   - Check if DateRange is being recreated with default constructor
   - Verify factory constructors are being used
   - Ensure DateRange object is preserved through the pipeline

2. **Wrong Period Type**
   - Verify correct factory constructor is called
   - Check debug output for `DateRange.type` field
   - Ensure no intermediate DateRange recreation

3. **Import Issues**
   - Ensure correct DateRange import from `date_range.dart`
   - Check for conflicting DateRange imports

### Debug Steps

1. Add debug prints to trace DateRange creation
2. Verify `DateRange.type` field value
3. Check `toString()` output at each pipeline stage
4. Confirm DateRange object preservation

## Conclusion

The Enhanced DateRange System provides a robust, maintainable solution for intelligent date period formatting. It significantly improves user experience while maintaining backward compatibility and providing a solid foundation for future enhancements.

The system demonstrates best practices in:

- **Clean Architecture**: Separation of concerns and single responsibility
- **Type Safety**: Factory constructors and enum-based type system
- **User Experience**: Intelligent formatting based on context
- **Maintainability**: Extensible design with clear documentation
