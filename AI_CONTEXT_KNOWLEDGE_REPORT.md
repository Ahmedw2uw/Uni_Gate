# AI Context Knowledge Report

## Architecture

The project now follows a Feature-Driven Architecture for the Flutter mobile app.
Each feature owns its files under `lib/features/<feature_name>/` and is split by responsibility:

- `data`: API/data sources, models, and repositories.
- `logic`: Cubits, states, and feature business state transitions.
- `presentation`: pages, views, and widgets only.
- `domain`: kept where it already exists for entities, repository contracts, and use cases.

Strict rule: no Cubit or State files should live under `presentation`. Presentation must depend on logic, not contain it.

## Current Directory Tree

```text
lib/
  core/
    constants/
    service_locator.dart
  network/
    api_services.dart
    api_extensions.dart
  shared/
    widgets/
  features/
    admission/
      data/
      domain/
      logic/cubit/
    auth/
      data/
      domain/
      logic/cubit/
      presentation/view/
    content/
      data/
      presentation/view/
    courses/
      data/
      domain/
      logic/cubit/
      presentation/view/
      presentation/widgets/
    dashboard/
      data/datasources/
      data/repositories/
      logic/cubit/
      presentation/view/
    exams/
      data/
      logic/cubit/
      presentation/view/
      presentation/widgets/
    payment/
      presentation/view/
    profile/
      presentation/view/
      presentation/widgets/
    requests/
      presentation/view/
    results/
      data/
      presentation/view/
    schedule/
      data/
      presentation/view/
    submission/
      data/
      logic/cubit/
      presentation/view/
test/
  widget_test.dart
```

## State Management

The app uses `flutter_bloc` with Cubit-based state management.

`ServiceLocator.init()` creates the shared dependencies:

- `ApiServices`
- `SharedPreferences`
- feature data sources and repositories
- `AuthCubit`
- `CoursesCubit`
- `DashboardCubit`
- `ExamsCubit`
- `AssignmentCubit`

The root app in `main.dart` provides shared Cubits through `MultiBlocProvider`.
UI files use `BlocBuilder` for rendering states and `BlocListener` for one-time side effects such as navigation, snack bars, and loading dialogs.

Expected Cubit state flow:

```text
UI event -> Cubit method -> Data/API call -> Loading -> Success or Failure -> UI rebuild/listener side effect
```

## Main Fixes Applied

- Moved Cubit and State files out of `presentation` into `logic/cubit`.
- Moved loose feature pages into `presentation/view`.
- Moved feature widgets into `presentation/widgets`.
- Flattened the dashboard data path from `data/datasources/data/...` to:
  - `data/datasources/dashboard_remote_datasource.dart`
  - `data/repositories/dashboard_repository_impl.dart`
- Renamed the misspelled exam attempt page path to `exam_attempt_page.dart`.
- Updated all imports after the restructuring.
- Cleaned duplicate and stale imports in `ServiceLocator`.
- Fixed `ExamsPage` so `fetchMyExams()` runs from `initState`, not from `build`.
- Added cached exams in `ExamsCubit` so the exam list does not disappear while loading questions or submitting sub-flows.
- Guarded the exam questions loading dialog to avoid unsafe repeated `Navigator.pop()` calls.
- Fixed `CourseContentPage` initialization to avoid using `BuildContext` across an async gap.
- Replaced production `print` calls with `debugPrint`.
- Replaced deprecated `withOpacity` calls with `withValues(alpha: ...)`.
- Removed duplicate inherited field declarations from `UserModel`.
- Updated the default widget test so it initializes `PrefHelpers` and `ServiceLocator` before pumping `MyApp`.

## Verification

The project was checked with:

```text
flutter analyze
flutter test
```

Final result:

```text
flutter analyze -> No issues found.
flutter test -> All tests passed.
```

## Instructions For The Next AI

When adding a new feature:

1. Create `lib/features/<feature>/data`, `logic/cubit`, and `presentation`.
2. Put API calls, models, and repositories in `data`.
3. Put Cubit and State files only in `logic/cubit`.
4. Put pages and widgets only in `presentation/view` and `presentation/widgets`.
5. Register dependencies in `core/service_locator.dart` if the feature needs shared injection.
6. Expose Cubits with `BlocProvider` at the narrowest useful scope.
7. Never call API-loading Cubit methods directly inside `build`; use `initState`, route creation, or a guarded post-frame callback.
8. Keep UI side effects in `BlocListener`, and rendering in `BlocBuilder`.
9. After changes, run `dart format lib test`, `flutter analyze`, and `flutter test`.

