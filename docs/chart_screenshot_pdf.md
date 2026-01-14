# Chart Screenshot -> PDF Export

## Purpose

This feature lets the app export the **actual charts shown on the Reports screen** into the PDF report.

A key requirement is that screenshots should capture **only the chart body**, not the chart title/header.

---

## What “chart screenshot bytes” means

When a chart is captured, the `screenshot` package returns the image as `Uint8List` bytes (PNG image bytes).

These bytes are then passed through the Reports flow and finally embedded in the PDF.

---

## Main building blocks

### 1) `ScreenshotController`

A `ScreenshotController` is used to “take a picture” of a widget.

- You attach a controller to a `Screenshot` widget.
- Later you call `controller.capture()` to get `Uint8List` image bytes.

### 2) Chart widgets support optional screenshot

All chart widgets now support:

- `ScreenshotController? screenshotController`

If it is provided, the chart wraps **only its body** with `Screenshot`.

If it is not provided, the chart behaves normally (no screenshot wrapper).

### 3) BLoC state carries captured images

The screenshots are stored in `ReportsState` so the PDF preview page can access them.

### 4) PDF builder embeds images

The PDF builder receives the bytes (via a map) and embeds them using `pw.Image(pw.MemoryImage(bytes))`.

---

## End-to-end flow (simple overview)

### Step 1: Controllers are created in `ReportsPage`

File:

- `lib/features/reports/pages/reports_page.dart`

`ReportsPage` owns all `ScreenshotController` instances because the **Export PDF** button lives here.

Examples:

- `_vehicleDistributionController`
- `_yearLevelBreakdownController`
- `_cityBreakdownController`
- `_fleetLogsController`

### Step 2: Controllers are passed to `GlobalChartsSection`

File:

- `lib/features/reports/widgets/sections/charts/global_charts_section.dart`

`ReportsPage` passes controllers down so the chart widgets can attach them internally.

### Step 3: Chart widgets wrap only the body

Files:

- `lib/features/dashboard/widgets/charts/donut_chart_widget.dart`
- `lib/features/dashboard/widgets/charts/bar_chart_widget.dart`
- `lib/features/dashboard/widgets/charts/line_chart_widget.dart`
- `lib/features/dashboard/widgets/charts/stacked_bar_widget.dart`
- `lib/features/dashboard/widgets/charts/semi_donut_chart.dart`

Pattern used inside each chart widget:

- Title/header stays outside the screenshot
- Only the main chart area is wrapped

Concept:

```dart
Column(
  children: [
    TitleWidget(), // not captured
    Expanded(
      child: screenshotController == null
          ? body
          : Screenshot(controller: screenshotController!, child: body),
    ),
  ],
)
```

### Step 4: Export PDF captures screenshots

File:

- `lib/features/reports/pages/reports_page.dart`

On export, `_handleExportPdf` runs:

- Calls `capture()` on each controller
- Stores the returned `Uint8List?`
- Calls `ReportsCubit.showPdfPreview(...)` passing all captured bytes

The code uses `try/catch` per capture so export still proceeds if one chart fails.

### Step 5: ReportsCubit stores bytes in ReportsState

Files:

- `lib/features/reports/bloc/reports/reports_cubit.dart`
- `lib/features/reports/bloc/reports/reports_state.dart`

`showPdfPreview(...)` sets:

- `showPdfPreview = true`
- all `...ChartBytes` fields in state

### Step 6: PdfReportPage forwards bytes to PdfEditorCubit

File:

- `lib/features/reports/pages/pdf_report_page.dart`

`PdfReportPage` receives the bytes via constructor parameters and passes them into `PdfEditorCubit`.

### Step 7: PdfEditorCubit passes bytes to PdfReportBuilder

File:

- `lib/features/reports/bloc/pdf/pdf_editor_cubit.dart`

`generatePdf()` calls:

- `PdfReportBuilder.buildVehicleReport(globalData: {...})`

`globalData` is a map containing the bytes under keys like:

- `vehicleDistributionChartBytes`
- `yearLevelBreakdownChartBytes`
- `fleetLogsChartBytes`

### Step 8: PdfReportBuilder embeds images into PDF

File:

- `lib/features/reports/controllers/pdf_report_builder.dart`

Inside `buildGlobalChartReport(...)`:

- Reads bytes from `globalData`
- If non-null, embeds them using:

```dart
pw.Image(
  pw.MemoryImage(chartBytes),
  height: 220,
  fit: pw.BoxFit.contain,
)
```

---

## Common problems and how to fix them

### Problem: Screenshot includes the title

Cause:

- You wrapped the whole chart widget with `Screenshot`.

Fix:

- Wrap only the chart body (usually the `Expanded` content), keep the title outside.

### Problem: PDF shows blank/missing charts

Common causes:

- Controller was never captured during export
- Bytes were not stored in `ReportsState`
- Bytes were not forwarded into `PdfReportPage` / `PdfEditorCubit`
- Map key mismatch between `PdfEditorCubit` and `PdfReportBuilder`

Fix:

- Ensure the export handler captures and passes all charts.
- Ensure the same key names are used everywhere.

---

## Quick file reference

### UI / Controllers / Capture

- `lib/features/reports/pages/reports_page.dart`
- `lib/features/reports/widgets/sections/charts/global_charts_section.dart`

### Chart widgets (body-only screenshot support)

- `lib/features/dashboard/widgets/charts/*.dart`

### BLoC plumbing

- `lib/features/reports/bloc/reports/reports_state.dart`
- `lib/features/reports/bloc/reports/reports_cubit.dart`

### PDF generation

- `lib/features/reports/pages/pdf_report_page.dart`
- `lib/features/reports/bloc/pdf/pdf_editor_cubit.dart`
- `lib/features/reports/controllers/pdf_report_builder.dart`
