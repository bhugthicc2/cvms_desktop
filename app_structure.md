## lib/

- **main.dart** (contains AuthWrapper for session management)
- **firebase_options.dart**
- **core/**
  - **error/**
    - failures.dart
  - **routes/**
    - app_routes.dart
  - **theme/**
    - app_colors.dart
    - app_dimensions.dart
    - app_font_sizes.dart
    - app_icon_sizes.dart
    - app_spacing.dart
    - app_theme.dart
  - **utils/**
    - custom_window_titlebar.dart
    - form_validator.dart
    - logger.dart
  - **widgets/**
    - custom_appbar.dart
    - custom_button.dart
    - custom_checkbox.dart
    - custom_loading_screen.dart
    - custom_progress_indicator.dart
    - custom_snackbar.dart
    - custom_text_field.dart
    - custom_window_buttons.dart
    - custom_window_icon_button.dart
    - spacing.dart
- **features/**
  - **auth/**
    - **bloc/**
      - auth_bloc.dart (enhanced with session persistence)
      - auth_event.dart
      - auth_state.dart
    - **models/**
      - user_model.dart
    - **pages/**
      - email_sent_page.dart
      - forgot_password_page.dart
      - signin_page.dart (enhanced with stateful widget for checkbox management)
      - signup_page.dart
    - **services/**
      - auth_persistence.dart (custom session persistence)
      - firebase_service.dart
    - **widgets/**
      - auth_scaffold.dart
      - auth_window_titlebar.dart
      - custom_alert_dialog.dart
      - custom_auth_link.dart (enhanced with checkbox state management)
      - custom_form_header.dart
      - custom_illustration.dart
      - custom_text_button.dart
      - form_title.dart
      - text_heading.dart
      - text_subheading.dart
  - **dashboard/**
    - **bloc/**
      - dashboard_bloc.dart
    - **data/**
      - vehicle_data_source.dart
    - **models/**
      - vehicle_entry.dart
    - **pages/**
      - dashboard_page.dart
    - **widgets/**
      - custom_data_pager.dart
      - custom_sort_icon.dart
      - dashboard_overview.dart
      - dashboard_stats_card.dart
      - empty_state.dart
      - search_field.dart
      - vehicle_table.dart
      - vehicle_table_columns.dart
      - vehicle_table_header.dart
  - **profile/**
    - **pages/**
      - profile_page.dart
  - **report_and_analytics/**
    - **pages/**
      - report_and_analytics_page.dart
  - **settings/**
    - **pages/**
      - settings_page.dart
  - **shell/**
    - **bloc/**
      - shell_cubit.dart
    - **models/**
      - nav_item.dart
    - **pages/**
      - shell_page.dart
    - **widgets/**
      - custom_header.dart
      - custom_sidebar.dart
      - custom_sidebar_header.dart
      - custom_sidebar_tile.dart
  - **user_management/**
    - **pages/**
      - user_management_page.dart
  - **vehicle_management/**
    - **pages/**
      - vehicle_management_page.dart
  - **vehicle_monitoring/**
    - **pages/**
      - vehicle_monitoring_page.dart
  - **violation_management/**
    - **pages/**
      - violation_management_page.dart

## Keep Me Logged In Functionality Structure

The "Keep Me Logged In" functionality spans across multiple components:

### Core Components:

- **main.dart** - Contains `AuthWrapper` class for session management and initial routing
- **auth_persistence.dart** - Custom session persistence service using SharedPreferences
- **auth_bloc.dart** - Enhanced with session saving/clearing logic
- **signin_page.dart** - Stateful widget with checkbox state management

### Data Flow:

1. **Session Storage**: `AuthPersistence` manages user session data in SharedPreferences
2. **State Management**: `AuthBloc` handles authentication events and session persistence
3. **UI Management**: `SignInPage` manages checkbox state and user interaction
4. **App Initialization**: `AuthWrapper` determines initial route based on session validity

### Key Features:

- Custom session persistence for desktop platforms
- SharedPreferences-based data storage
- Firebase Auth integration with fallback session management
- Stateful checkbox management
- Automatic routing based on authentication state
