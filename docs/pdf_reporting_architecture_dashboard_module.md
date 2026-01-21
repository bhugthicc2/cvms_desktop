# PDF Reporting Architecture – Dashboard Module

This document serves as a **long-term reference** for the PDF reporting implementation in the Dashboard module. It explains **why things are designed the way they are**, how data flows from Firestore to PDF, and how to extend the system safely in the future.

---

## 1. Purpose of This Architecture

The PDF reporting system is designed to be:

- ✅ **Maintainable** – easy to understand and modify
- ✅ **Scalable** – supports new report sections without refactoring
- ✅ **Professional** – suitable for academic (thesis) and real-world use
- ✅ **Not over-engineered** – beginner-friendly but architecturally sound

The key goal is to **separate concerns clearly** so that:

- Data fetching is isolated from presentation
- PDF layout is reusable
- Report content is modular and composable

---

## 2. High-Level Data Flow

```
UI Trigger
  ↓
DashboardCubit.generateReport()
  ↓
PdfExportUseCase
  ↓
ReportAssembler
  ↓
Repositories (Firestore)
  ↓
Report Model (GlobalVehicleReportModel)
  ↓
PDF Builder (GlobalReportBuilder)
  ↓
PDF Sections (PdfSection<T>)
  ↓
pdf.MultiPage → Uint8List
```

Each layer has **one responsibility only**.

---

## 3. Core Architectural Rules

### Rule 1: PDF Sections NEVER access Firestore

❌ Wrong:
```dart
FirebaseFirestore.instance.collection('vehicles')
```

✅ Correct:
```dart
section.build(GlobalVehicleReportModel report)
```

All data must be prepared **before** PDF generation.

---

### Rule 2: One Section Interface Only

All PDF sections must implement:

```dart
abstract class PdfSection<T> {
  List<pw.Widget> build(T report);
}
```

❌ Do not introduce parallel interfaces (e.g. `PdfReportSection`).

---

### Rule 3: Report Models Are Immutable Snapshots

Example:
```dart
class GlobalVehicleReportModel {
  final int totalVehicles;
  final Map<String, int> vehiclesByCity;
  final Map<String, int> vehiclesByYearLevel;
  final DateRange period;
}
```

- Report models represent a **point-in-time snapshot**
- They are safe to pass across layers

---

## 4. Folder Structure (Important)

```
lib/features/dashboard/
├── models/report/
│   └── global_vehicle_report_model.dart
│
├── repositories/report/
│   └── global_report_repository.dart
│
├── assemblers/report/
│   └── global_report_assembler.dart
│
├── pdf/
│   ├── core/
│   │   ├── pdf_section.dart
│   │   └── pdf_insight.dart
│   │
│   ├── templates/
│   │   └── default_pdf_page_template.dart
│   │
│   ├── components/
│   │   ├── tables/
│   │   │   └── pdf_table.dart
│   │   ├── sections/
│   │   │   └── pdf_section_title.dart
│   │   └── texts/
│   │
│   └── sections/global/
│       ├── global_summary_section.dart
│       ├── year_level_breakdown_section.dart
│       └── top_cities_section.dart
```

This structure ensures **discoverability and consistency**.

---

## 5. Repository Design Principles

Repositories:
- Talk directly to Firestore
- Return **raw or aggregated data only**
- Do NOT sort, rank, or format

Example:
```dart
Future<Map<String, int>> getVehiclesByCity();
```

Ranking (Top 5, Top 10) is a **presentation concern**, not a data concern.

---

## 6. Assembler Responsibilities

Assemblers:
- Coordinate multiple repository calls
- Execute queries in parallel (`Future.wait`)
- Convert raw data into domain models

Example responsibilities:
- Convert maps to chart data
- Map Firestore documents to model objects
- Build a complete `GlobalVehicleReportModel`

Assemblers must not:
- Generate PDF widgets
- Know about layout or formatting

---

## 7. PDF Template Strategy

### DefaultPdfPageTemplate

Responsibilities:
- Page format (Legal / A4)
- Header (branding)
- Footer (branding + page numbers)

Important design decision:
- **Margins apply only to content, NOT header/footer**

This is achieved by applying padding **inside sections**, not via `PageTheme.margin`.

---

## 8. PDF Section Design Pattern

Each section:

```dart
class ExampleSection implements PdfSection<GlobalVehicleReportModel> {
  @override
  List<pw.Widget> build(GlobalVehicleReportModel report) {
    return [
      PdfSectionTitle(...),
      PdfTable(...),
      PdfInsightBox(...),
    ];
  }
}
```

### Section Guidelines

- Always return `List<pw.Widget>`
- Never assume data exists
- Handle empty states gracefully
- Use `PdfInsightBox` for smart remarks

---

## 9. Smart Text / Insight Strategy

Insights are:
- Deterministic
- Data-driven
- Explainable

Example:
```text
Dipolog City recorded the highest number of registered vehicles with 23 vehicles,
representing 54.3% of the total vehicle population.
```

Insights must NOT:
- Be vague
- Use AI-style fluff
- Contradict table data

---

## 10. Table-First, Chart-Ready Philosophy

For PDFs:
- Tables are primary (clarity, printability)
- Charts are secondary (visual summary)

All distributions are modeled as:
```dart
Map<String, int>
```

This allows:
- Table rendering now
- Donut / bar charts later without refactor

---

## 11. Scalability Example: Top Cities

The system models:

```dart
vehiclesByCity: Map<String, int>
```

The section decides:

```dart
TopCitiesSection(limit: 5)
```

To show:
- Top 5
- Top 10
- All cities

No backend change required.

---

## 12. Testing Strategy (Current Scope)

For thesis scope:
- Manual testing is acceptable
- Visual PDF inspection
- Console logging for debugging

Future improvements (optional):
- Snapshot PDF tests
- Golden file comparison

---

## 13. Non-Goals (Explicitly Out of Scope)

We intentionally do NOT:
- Over-optimize Firestore queries
- Build a generic chart engine
- Support multi-institution tenancy
- Add dynamic layout engines

This keeps the system understandable and defensible.

---

## 14. How to Add a New Report Section (Checklist)

1. Decide the data needed
2. Add field to report model
3. Add repository method
4. Fetch data in assembler
5. Create `PdfSection<T>` implementation
6. Add section to report builder

If you follow this order, the architecture stays clean.

---

## 15. Final Note

This architecture balances:
- Academic clarity
- Professional structure
- Practical implementation

It is intentionally **simple but correct** — the best kind of foundation.

Future you (or another developer) should be able to understand this system **without guesswork**.

