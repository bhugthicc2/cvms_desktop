# Report Loading System Documentation

## Overview

This document describes the implementation of the report loading system that provides visual feedback to users during PDF generation process in the CVMS dashboard.

## Components

### 1. ReportLoadingAnim Widget

**Location**: `lib/core/widgets/animation/report_loading_anim.dart`

**Purpose**: Custom loading widget with Lottie animation for report generation.

**Key Features**:

- Uses Lottie animation from `assets/anim/report_loadin_anim.json`
- Customizable message parameter
- Semi-transparent background overlay
- Consistent app styling with AppColors and AppFontSizes

**Constructor**:

```dart
const ReportLoadingAnim({
  super.key,
  this.message = "Please wait while we prepare your report data.",
});
```

**Usage**:

```dart
if (state.loading) {
  ReportLoadingAnim(
    message: "Generating your vehicle report...",
  )
}
```

### 2. ExportReportButton Enhancement

**Location**: `lib/features/dashboard/widgets/navigation/action_buttons.dart`

**Purpose**: Export button with loading state integration.

**Key Changes**:

- Added `isLoading` boolean parameter
- Shows loading spinner when `isLoading = true`
- Changes button text to "GENERATING..."
- Disables button interactions during loading
- Changes button color to grey when loading

**Constructor**:

```dart
const ExportReportButton({
  super.key,
  this.text = 'GENERATE REPORT',
  required this.onPressed,
  this.isLoading = false,
});
```

### 3. DashboardControlsSection Integration

**Location**: `lib/features/dashboard/widgets/sections/dashboard_controls_section.dart`

**Purpose**: Passes loading state to ExportReportButton.

**Key Changes**:

- Added `isLoading` parameter
- Forwards loading state to ExportReportButton

**Constructor**:

```dart
const DashboardControlsSection({
  // ... other parameters
  this.isLoading = false,
});
```

### 4. DashboardPage Loading Overlay

**Location**: `lib/features/dashboard/pages/core/dasboard_page.dart`

**Purpose**: Main loading overlay that covers the entire dashboard during report generation.

**Implementation**:

- Uses Stack to overlay loading animation
- Shows `ReportLoadingAnim` when `state.loading = true`
- Prevents user interaction with underlying content
- Integrated with existing GlobalDashboardCubit loading state

**Key Code**:

```dart
Stack(
  children: [
    // Main content
    Container(...),

    // Loading overlay
    if (state.loading)
      ReportLoadingAnim(),
  ],
)
```

## State Management

### GlobalDashboardCubit Integration

**Location**: `lib/features/dashboard/bloc/dashboard/global/global_dashboard_cubit.dart`

**Loading State Flow**:

1. User clicks "Generate Report" button
2. `generateReport()` method called
3. `emit(state.copyWith(loading: true))` - Shows loading overlay
4. PDF generation process executes
5. `emit(state.copyWith(loading: false, pdfBytes: pdfBytes))` - Hides loading, shows PDF

**Key Methods**:

```dart
Future<void> generateReport({required DateRange range}) async {
  emit(state.copyWith(loading: true));  // Show loading

  try {
    // PDF generation logic
    Uint8List pdfBytes = await ...;

    emit(state.copyWith(
      pdfBytes: pdfBytes,
      viewMode: DashboardViewMode.pdfPreview,
      loading: false,  // Hide loading
    ));
  } catch (e) {
    emit(state.copyWith(loading: false, error: e.toString()));
  }
}
```

## User Experience Flow

### Normal Flow:

1. User clicks "GENERATE REPORT" button
2. Button shows loading state (spinner + "GENERATING...")
3. Full-screen loading overlay appears with Lottie animation
4. User sees "Loading..." message and custom description
5. PDF generation completes
6. Loading overlay disappears
7. PDF preview view opens

### Error Handling:

- If PDF generation fails, loading state is cleared
- Error message is stored in state
- Loading overlay disappears
- User can try again

## File Dependencies

### Required Assets:

- `assets/anim/report_loadin_anim.json` - Lottie animation file

### Required Imports:

```dart
import 'package:cvms_desktop/core/widgets/animation/report_loading_anim.dart';
import 'package:lottie/lottie.dart';
```

### Theme Dependencies:

- `AppColors.greySurface` - Background color
- `AppColors.black` - Text color
- `AppFontSizes.large` and `AppFontSizes.medium` - Text sizing
- `AppSpacing.small` - Spacing between elements

## Customization Options

### Changing Animation:

1. Replace `assets/anim/report_loadin_anim.json` with new animation
2. Update animation path in `ReportLoadingAnim` widget

### Changing Messages:

1. Modify default message in `ReportLoadingAnim` constructor
2. Pass custom message when using the widget:

```dart
ReportLoadingAnim(
  message: "Custom loading message here",
)
```

### Changing Styling:

1. Update colors in `ReportLoadingAnim` build method
2. Modify font sizes using `AppFontSizes`
3. Adjust animation size in Lottie.asset parameters

## Removal Instructions

### To Remove Entire Loading System:

1. **Remove ReportLoadingAnim widget**:
   - Delete `lib/core/widgets/animation/report_loading_anim.dart`

2. **Revert ExportReportButton**:
   - Remove `isLoading` parameter
   - Remove loading state logic from build method
   - Restore original button implementation

3. **Revert DashboardControlsSection**:
   - Remove `isLoading` parameter
   - Remove `isLoading: isLoading` from ExportReportButton call

4. **Revert DashboardPage**:
   - Remove Stack wrapper
   - Remove loading overlay conditional
   - Remove import for ReportLoadingAnim

5. **Clean Up**:
   - Remove Lottie animation asset if no longer needed
   - Remove Lottie dependency from pubspec.yaml if unused elsewhere

## Troubleshooting

### Common Issues:

1. **Animation not showing**:
   - Check if `report_loadin_anim.json` exists in assets
   - Verify asset is properly registered in pubspec.yaml
   - Ensure Lottie package is imported

2. **Loading state not updating**:
   - Verify GlobalDashboardCubit state management
   - Check if emit calls are properly executed
   - Ensure BlocBuilder is listening to state changes

3. **Button not disabling during loading**:
   - Check `isLoading` parameter is passed correctly
   - Verify ExportReportButton loading logic
   - Ensure state.loading is properly set

## Performance Considerations

- Lottie animation uses `RenderCache.raster` for better performance
- Loading overlay prevents unnecessary UI interactions
- State management ensures minimal rebuilds
- Animation size is optimized at 280px width

## Future Enhancements

- Add progress percentage display
- Include cancel functionality for long-running reports
- Add different animations for different report types
- Implement retry mechanism for failed generations
