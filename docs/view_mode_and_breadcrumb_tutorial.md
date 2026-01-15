# View Mode + Breadcrumb Tutorial (Reusable Pattern)

## What this tutorial is

This is a simple guide on how **view mode switching** works together with the **global breadcrumbs** shown in the header.

Use this pattern when you want a feature page to have multiple internal screens (example: list view vs add view) while keeping the header breadcrumb accurate.

This tutorial uses the Vehicle Management feature as the reference implementation.

## Key idea (one sentence)

- The **shell** owns the breadcrumb state.
- A **feature page** decides its view mode (list/add/etc.) using a Cubit.
- The feature page **publishes** the correct breadcrumbs to the shell whenever the state changes.

## Where things live (files)

### Breadcrumb system

- `lib/features/shell/pages/shell_page.dart`

  - Owns the `BreadcrumbController`
  - Clears breadcrumbs when sidebar page changes

- `lib/features/shell/scope/breadcrumb_scope.dart`

  - Provides `BreadcrumbController` to descendants

- `lib/features/shell/widgets/custom_header.dart`
  - Renders the root title + breadcrumb items

### View mode system (example)

- `lib/features/vehicle_management/bloc/vehicle_cubit.dart`

  - Holds functions that switch view modes

- `lib/features/vehicle_management/bloc/vehicle_state.dart`

  - Holds the current `viewMode`

- `lib/features/vehicle_management/pages/core/vehicle_management_page.dart`
  - Chooses which view widget to display based on `state.viewMode`
  - Publishes breadcrumbs for the current `viewMode`

## How the UI updates (data flow)

### 1) User clicks something

Example: User clicks “Add Vehicle” button.

### 2) Page calls the Cubit

The page calls a method like:

- `context.read<VehicleCubit>().startAddVehicle()`

### 3) Cubit emits a new state

The cubit updates `viewMode` and emits a new `VehicleState`.

### 4) UI rebuilds and breadcrumbs update

In `VehicleManagementPage`:

- A `BlocBuilder` rebuilds the page body (switching list -> add view)
- A `BlocListener` publishes breadcrumbs to the shell via `BreadcrumbScope.controllerOf(context).setBreadcrumbs(...)`

Result:

- The header shows:
  - Root title: "Vehicle Management"
  - Breadcrumb: "Add Vehicle" (when in add mode)

## The reference pattern (Vehicle Management)

### A) Create a view mode enum

Example (in cubit file):

- `VehicleViewMode { list, addVehicle }`

Keep it simple:

- Use view modes for **page-level** screens (list vs add)
- Don’t use breadcrumbs for step-level UI (use a stepper inside the add view)

### B) Put `viewMode` in state

In the state object:

- `final VehicleViewMode viewMode;`

Provide a default:

- `VehicleViewMode.list`

### C) Add cubit methods to switch modes

Example methods:

- `startAddVehicle()`
- `backToList()`

These should only do one job: emit a new state with a new `viewMode`.

### D) Render different widgets based on `viewMode`

In your page:

- Use `BlocBuilder<VehicleCubit, VehicleState>`
- `switch (state.viewMode)`
  - list -> show table
  - add -> show add view

### E) Publish breadcrumbs based on `viewMode`

In your page:

- Build breadcrumbs using a helper:
  - `_buildBreadcrumbs(context, state)`

Example behavior:

- list -> `[]`
- add -> `[BreadcrumbItem(label: 'Add Vehicle')]`

Then publish breadcrumbs when state changes:

- `BreadcrumbScope.controllerOf(context).setBreadcrumbs(breadcrumbs)`

## Important details (so you don’t get bugs)

### 1) Gating (important when using IndexedStack)

If your shell keeps pages alive using `IndexedStack`, hidden pages can still emit state.

That can cause breadcrumb leakage unless you gate updates.

Fix:

- Check the active sidebar index before publishing:
  - `if (context.read<ShellCubit>().state.selectedIndex != <yourPageIndex>) return;`

Example:

- Vehicle Management is index `3`

### 2) Restoring breadcrumbs when returning to the page

The shell clears breadcrumbs when switching sidebar pages.

When you return to your page, your cubit might not emit immediately, so breadcrumbs may stay empty.

Fix:

- Listen to `ShellCubit` index changes
- When the index becomes your page, re-apply breadcrumbs using the current cubit state

### 3) Don’t put stepper steps in breadcrumbs

Breadcrumbs are for navigation between _screens_.

If you have a multi-step form:

- Use a Stepper or internal tabs
- Keep breadcrumbs at the page-level (example: only "Add Vehicle")

## How to apply this to another page (recipe)

Example: Reports page wants two views:

- List reports
- Create report

### Step 1: Add an enum

- `ReportsViewMode { list, create }`

### Step 2: Add it to state

- `final ReportsViewMode viewMode;`

### Step 3: Add cubit methods

- `showList()`
- `startCreate()`

### Step 4: Build page body using `switch`

- list -> show table
- create -> show create form

### Step 5: Build + publish breadcrumbs

- list -> `[]`
- create -> `[BreadcrumbItem(label: 'Create Report')]`

Publish on state changes using `BreadcrumbScope.controllerOf(context).setBreadcrumbs(...)`

### Step 6: Add gating + restore (if needed)

If your app uses `IndexedStack`:

- gate publishing by `selectedIndex`
- restore breadcrumbs when the page becomes active

## Troubleshooting

### Breadcrumbs show on the wrong page

Cause:

- A hidden page is still publishing breadcrumbs.

Fix:

- Add gating by `ShellCubit.state.selectedIndex`

### Breadcrumbs disappear when you return to the page

Cause:

- Shell clears breadcrumbs on page change
- Page didn’t re-publish since cubit didn’t emit

Fix:

- Listen to `ShellCubit` index changes and re-apply breadcrumbs

### View mode doesn’t change

Cause:

- Cubit method wasn’t called
- Cubit method doesn’t emit

Fix:

- Ensure you call the cubit method from the UI
- Ensure the method uses `emit(state.copyWith(...))`

## Summary

To reuse this pattern on any feature page:

- Put a `viewMode` in your cubit state
- Emit a new `viewMode` when user navigates
- Switch the page body based on `viewMode`
- Publish breadcrumbs based on `viewMode`
- If using `IndexedStack`, gate publishing + restore breadcrumbs on activation
