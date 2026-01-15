# Breadcrumb Implementation (Shell Header)

## Goal

Breadcrumbs show the **current step / sub-page** inside a feature (example: Vehicle Management -> Add Vehicle -> Step 2).

The breadcrumbs are displayed inside the **global header** (`CustomHeader`) which lives in `ShellPage`.

## Why we needed a controller

At first, `BreadcrumbScope` was placed inside a feature page (like Vehicle Management). That does **not** work because:

- `CustomHeader` is built in `ShellPage`
- `ShellPage` is **above** the feature page in the widget tree
- `InheritedWidget` values only flow **down** to children

So the header could not “see” the breadcrumbs.

The fix is to store breadcrumbs in the shell (global layout) and let feature pages update it.

## Main pieces

### 1) `BreadcrumbItem`

File:

- `lib/core/widgets/navigation/bread_crumb_item.dart`

Purpose:

- Represents one breadcrumb segment.

Fields:

- `label`: text shown in the header
- `onTap`: optional callback for clicking the breadcrumb
- `isActive`: optional flag (currently not used by header rendering)

### 2) `BreadcrumbController`

File:

- `lib/features/shell/scope/breadcrumb_scope.dart`

Purpose:

- Holds the current list of breadcrumbs.
- Notifies listeners when breadcrumbs change.

API:

- `setBreadcrumbs(List<BreadcrumbItem> breadcrumbs)`

### 3) `BreadcrumbScope`

File:

- `lib/features/shell/scope/breadcrumb_scope.dart`

Purpose:

- Makes the `BreadcrumbController` available to all pages under the shell.

Key methods:

- `BreadcrumbScope.controllerOf(context)`: returns the controller
- `BreadcrumbScope.of(context)`: returns the current breadcrumb list

Important:

- This scope must wrap both:
  - the `CustomHeader`
  - the page body (`ShellNavigationConfig.getPage(...)`)

### 4) `ShellPage` owns the controller

File:

- `lib/features/shell/pages/shell_page.dart`

Implementation:

- `ShellPage` is a `StatefulWidget`
- It creates one `BreadcrumbController`
- It wraps the UI with:
  - `BreadcrumbScope(controller: _breadcrumbController, child: ...)`

This is what makes breadcrumbs visible to the header.

## How breadcrumbs are displayed

File:

- `lib/features/shell/widgets/custom_header.dart`

`CustomHeader` receives `breadcrumbs: List<BreadcrumbItem>` and renders:

- Root title (example: "Vehicle Management")
- Then each breadcrumb with a separator `>`
- The last breadcrumb is styled as active (bold + primary color)

## How feature pages update breadcrumbs

### Example: Vehicle Management

File:

- `lib/features/vehicle_management/pages/core/vehicle_management_page.dart`

Pattern used:

- Wrap the page with `BlocListener<VehicleCubit, VehicleState>`
- On any state change, compute breadcrumbs from `state.viewMode`
- Push the result into the controller:

- `BreadcrumbScope.controllerOf(context).setBreadcrumbs(...)`

This makes the header update immediately.

## Preventing breadcrumb “leakage” between pages

Because breadcrumbs live in the shell, if you don’t clear them, the last page that set breadcrumbs will “stick” and appear under another page.

We prevent that by clearing when sidebar navigation changes.

File:

- `lib/features/shell/pages/shell_page.dart`

Logic:

- Listen to `ShellCubit`
- When `selectedIndex` changes:
  - `_breadcrumbController.setBreadcrumbs(const [])`

Result:

- Switching pages resets breadcrumbs so each page starts clean.

### Note when using `IndexedStack`

If the shell uses an `IndexedStack` to keep pages alive:

- Off-screen pages are still mounted.
- Their BLoCs/Cubits can still emit.
- Any breadcrumb listener that always writes to the global controller can cause breadcrumb leakage.

To prevent this, pages that publish breadcrumbs should only publish when they are the active page.
Example rule:

- Check `ShellCubit.state.selectedIndex` and only call `setBreadcrumbs(...)` when it matches the page index.

### Restoring breadcrumbs when returning to a page

The shell clears breadcrumbs when switching sidebar pages. When you return to a page, the page might not emit a new state immediately, so breadcrumbs can stay empty until another interaction.

Fix pattern:

- Listen to `ShellCubit` index changes.
- When the page becomes active, re-apply breadcrumbs using the current Cubit state.

## Rules (follow these to avoid bugs)

- Feature pages that have sub-steps should **always** set breadcrumbs when their internal state changes.
- Pages that do not use breadcrumbs can do nothing (shell will clear on navigation).
- Never create a separate `BreadcrumbScope` inside a feature page to “try to override” the header. It won’t work for siblings/parents.
- If you add a new page with breadcrumbs:
  - Use the same pattern as Vehicle Management (listener + `_buildBreadcrumbs`).
  - Gate updates so only the active page can publish.
  - Re-apply breadcrumbs when the page becomes active again.

## Is this scalable for other pages?

Yes. It scales fine as long as you follow a simple rule:

- The shell owns the breadcrumb state.
- Any page that wants breadcrumbs must actively set them.

If a page never sets breadcrumbs, it will show none (and that is expected).

## How to apply it to another page

### Step 1: Choose what controls the breadcrumbs

Pick the thing that describes the current sub-page/step, for example:

- A Cubit/BLoC field like `viewMode`
- A tab index
- A local step variable

### Step 2: Build the breadcrumb list

Create a function that returns `List<BreadcrumbItem>` based on the state.

Example idea:

- List view: `[]`
- Add flow: `[BreadcrumbItem(label: 'Add User')]`
- Edit flow: `[BreadcrumbItem(label: 'Edit User')]`

Add `onTap` to items if you want the breadcrumb to be clickable.

### Step 3: Publish breadcrumbs when the state changes

Recommended pattern (same as Vehicle Management):

- Wrap the page with a `BlocListener`
- In the `listener`, call:
  - `BreadcrumbScope.controllerOf(context).setBreadcrumbs(...)`

If you are not using BLoC, call `setBreadcrumbs(...)` whenever your local state changes.

### Step 4 (optional): Clear on dispose

This is optional because the shell already clears breadcrumbs when sidebar navigation changes.

Only consider clearing in `dispose()` if you have navigation inside the same sidebar index (for example, nested routes) and you don’t want breadcrumbs to persist.

## Pitfalls

- Don’t wrap feature pages with their own `BreadcrumbScope` and expect the header to update. That scope will not affect widgets above it.
- Don’t set breadcrumbs only once if your view mode changes multiple times. Update them every time your step/state changes.
- If you want breadcrumbs to persist when switching sidebar pages, you need a different policy (example: store per `selectedIndex`).

## Multi-step forms: preventing progress from resetting

If a user is in the middle of a multi-step form and switches sidebar pages, you generally should not lose their progress.

Important idea:

- Breadcrumbs do not reset your form.
- Form reset happens when the page/widgets are disposed and rebuilt.

Recommended setup:

- Keep sidebar pages alive using an `IndexedStack` (so widget state like form fields/controllers can survive).
- Cache and reuse feature Cubits/Blocs (so view mode and draft data can survive).

Best practice:

- If the form is important, store the draft data in the Cubit/state (not only in `TextEditingController`).
- This makes the flow resilient even if the widget tree is rebuilt.

## Common problems and fixes

### 1) Breadcrumbs don’t show

Cause:

- `BreadcrumbScope` is not wrapping `CustomHeader`.

Fix:

- Ensure `ShellPage` wraps the scaffold with `BreadcrumbScope(controller: ...)`.

### 2) Breadcrumbs show on the wrong page

Cause:

- Breadcrumbs are global and were not cleared.

Fix:

- Clear breadcrumbs when `selectedIndex` changes (already implemented in `ShellPage`).

### 3) Tapping breadcrumb does nothing

Cause:

- `BreadcrumbItem.onTap` is null.

Fix:

- Provide `onTap` in the breadcrumb items for steps that should be clickable.

## Extending the system (optional improvements)

If you want stricter ownership (more “locked down”):

- Option A: Store breadcrumbs per `selectedIndex` (Map<int, List<BreadcrumbItem>>)

  - Pros: preserves breadcrumbs when you switch away and back
  - Cons: more state to manage

- Option B: Make each feature page clear breadcrumbs on `dispose`
  - Pros: explicit cleanup
  - Cons: easy to forget; shell-level clearing is still recommended
