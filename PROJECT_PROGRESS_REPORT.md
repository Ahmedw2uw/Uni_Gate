# UniGate Mobile App - Project Progress Report

Last updated: 2026-06-17

## 1. Project Overview

This is a Flutter mobile application for a student university portal. The app is currently organized around a feature-driven architecture under `lib/features`, with shared infrastructure in `lib/core`, `lib/network`, `lib/shared`, and `lib/utils`.

The dominant architecture is:

- Feature-Driven Architecture.
- Bloc/Cubit for state management.
- Layered feature structure where mature features use `data`, `domain`, `logic`, and `presentation`.
- Shared widgets for reusable UI primitives.
- `ServiceLocator` for manual dependency creation and Cubit wiring.

The app is Arabic-first and uses:

- `locale: Locale('ar')`
- Flutter localization delegates.
- RTL-oriented UI text and screens.

## 2. Current Feature Structure

Current main feature folders:

```text
lib/features/
  admission/
    data/
    domain/
    logic/
  auth/
    data/
    domain/
    logic/
    presentation/
  content/
    data/
    presentation/
  courses/
    data/
    domain/
    logic/
    presentation/
  dashboard/
    data/
    logic/
    presentation/
  exams/
    data/
    logic/
    presentation/
  onboarding/
    logic/
    presentation/
  payment/
    data/
    domain/
    logic/
    presentation/
  profile/
    presentation/
  requests/
    data/
    logic/
    presentation/
  results/
    data/
    logic/
    presentation/
  schedule/
    data/
    presentation/
  submission/
    data/
    logic/
    presentation/
```

Shared/system folders:

```text
lib/core/
  app_assets.dart
  app_colors.dart
  app_strings.dart
  service_locator.dart
  constants/api_endpoints.dart

lib/network/
  api_services.dart
  api_extensions.dart

lib/shared/widgets/
  app_scaffold.dart
  app_text_field.dart
  custom_text.dart
  primary_button.dart

lib/utils/
  helpers.dart
  jwt_helper.dart
  pref_helpers.dart
  user_session.dart
  validator.dart
```

## 3. State Management And Dependency Flow

The app uses `MultiBlocProvider` in `main.dart`. Cubits are created manually in `ServiceLocator.init()` and then provided with `BlocProvider.value`.

Current global Cubits:

- `AuthCubit`
- `CoursesCubit`
- `CourseRegistrationCubit`
- `AssignmentCubit`
- `ResultsCubit`
- `RequestsCubit`
- `PaymentCubit`

Dashboard uses a route-local `DashboardCubit` in `DashboardPage`, created from `ServiceLocator.dashboardCubit..getStudentData()`.

Current startup flow:

1. `main()` initializes Flutter bindings.
2. `PrefHelpers.init()` initializes SharedPreferences.
3. `ServiceLocator.init()` creates API service, repositories, use cases, and Cubits.
4. `_HomeWrapper` checks onboarding completion.
5. `_HomeWrapper` calls `AuthCubit.checkAuthStatus()`.
6. If authenticated, the user goes to `DashboardPage`; otherwise `LoginPage`.

## 4. Important API And Data Fixes Already Done

### Auth/login

Swagger login requires:

```json
{
  "email": "...",
  "password": "...",
  "nationalId": "..."
}
```

The login flow was updated so `nationalId` travels through:

```text
LoginPage
  -> LoginFormCard
  -> AuthCubit.login
  -> LoginUseCase
  -> AuthRepository
  -> AuthRemoteDataSource.login
  -> POST /Authentication/login
```

`LoginPage` now includes the national ID field.

### Student model/profile parsing

`/Students/me/profile` returns user data with the important student data nested under `student`.

`UserModel.fromJson` now reads key fields from the nested `student` object:

- `student.id`
- `student.fullName`
- `student.studentCode`
- `student.nationalId`
- `student.phone`
- `student.gender`
- `student.profileImageUrl`
- `student.academicYear`
- `student.semester`
- `student.departmentName`
- `student.departmentNameAr`
- `student.academicInfo`

`UserEntity` now includes `studentId`, and `UserModel.copyWith/toJson/props` preserves it.

### Results feature

The original bug:

```text
GET /api/Result/3?semester=1
```

This failed with server `500`.

After emulator testing, we confirmed that `/api/Result/{studentId}` expects the academic student code, not the internal database student ID.

Correct request now:

```text
GET /api/Result/1223117?semester=1
```

Implementation:

- `DashboardMenuGrid` passes `studentCode` first when opening results.
- `ResultsPage` uses the `studentId` argument if present.
- `ResultsCubit.fetchCurrentStudentResults()` remains as a fallback and also resolves by `studentCode` first.
- `ResultsCubit` handles:
  - `200`: parse and emit `ResultsSuccess`.
  - `404`: no results registered for this student/semester.
  - `500`: server-side failure message.

Current backend result observed:

```text
404 Results not found for student 1223117
```

Meaning: Flutter is now calling the correct endpoint. Displaying actual results depends on backend data existing for `studentCode=1223117` and `semester=1`.

### Exams feature

Endpoint and provider issues were fixed earlier:

- `startExam` should use `POST /Exam/{examId}/start`.
- Submit should use `POST /Exam/submit`.
- Submit body shape follows Swagger:

```json
{
  "examResultId": 0,
  "answers": [
    {
      "questionId": 0,
      "selectedOptionId": 0
    }
  ]
}
```

`ExamAttemptPage` is pushed with `BlocProvider.value` so it can access the existing `ExamsCubit`.

### Logging/performance

Heavy response printing was reduced in auth/profile flows to avoid printing full tokens/profile data and reduce emulator log noise.

`ApiServices` has a debug `LogInterceptor`, but sensitive/full response logging should remain limited.

## 5. UI Refactor Progress

The UI has been progressively modularized feature by feature.

Completed or heavily improved:

- Auth:
  - `auth_background.dart`
  - `login_header.dart`
  - `login_form_card.dart`
  - `app_text_field.dart`
  - `primary_button.dart`

- Content:
  - `content_empty_state.dart`

- Courses:
  - `courses_view.dart`
  - `courses_list.dart`
  - `course_card.dart`
  - `course_content_view.dart`
  - `course_info_card.dart`
  - `course_materials_section.dart`
  - `course_material_tile.dart`
  - `course_content_error_view.dart`
  - Course registration widgets under `presentation/widgets/registration/`

- Dashboard:
  - `dashboard_user_header.dart`
  - `dashboard_menu_item.dart`
  - `dashboard_menu_tile.dart`
  - `dashboard_menu_grid.dart`
  - `dashboard_success_view.dart`
  - `dashboard_error_view.dart`

- Exams:
  - `exams_list.dart`
  - `exams_empty_state.dart`
  - `exam_attempt_top_bar.dart`
  - `exam_timer_badge.dart`
  - `exam_question_card.dart`
  - `exam_option_tile.dart`
  - `exam_navigation_bar.dart`
  - `exam_card.dart`

- Payment:
  - Full data/domain/logic/presentation structure now exists.
  - Widgets include payment form fields, method selector, status badge, success dialog, student info card.

- Doctor:
  - A separate `lib/features/doctor/` feature has been started.
  - The first vertical slice is isolated from student logic.
  - `GET /api/instructor/courses` is wired through `DoctorRemoteDataSource`, `DoctorRepository`, `GetInstructorCoursesUseCase`, and `DoctorCoursesCubit`.
  - `DoctorDashboardPage` displays instructor courses using doctor-specific widgets.
  - Routing now supports `/doctor`, and authenticated users with role containing `doctor` or `instructor` are routed to the doctor dashboard.
  - `DoctorShellPage` now owns the mobile doctor layout with an RTL side drawer.
  - `DoctorNavigationCubit` controls tabs: dashboard, assignments, lectures, and exams.
  - Dashboard course cards are now displayed as full-width vertical cards to avoid mobile overflow.
  - Lectures tab now supports selecting PDF/video files, uploading lectures to `/api/instructor/courses/{courseId}/lectures`, reloading the lecture list from course details, deleting lectures, and downloading/opening uploaded files through a dedicated row action.
  - Lecture deletion treats both `200 OK` and `204 No Content` as success because the backend returns `204` for `DELETE /api/instructor/courses/{courseId}/lectures/{lectureId}`.
  - Lecture file access uses `fileUrl` when present, otherwise it falls back to `GET /api/instructor/courses/{courseId}/lectures/{lectureId}/download`; this avoids adding an expensive in-app PDF/video viewer at this stage.
  - Submissions tab now displays a table-style grading screen for student submissions, matching the instructor dashboard design direction.
  - Submission grading now uses `PATCH /api/instructor/courses/submissions/{submissionId}/grade` with `grade` and `feedback`.
  - Submission file opening now uses `GET /api/instructor/courses/submissions/{submissionId}` to resolve `fileUrl`, because Swagger does not define a separate submission download endpoint.
  - Assignments and exams have initial working screens; continue polishing them screen-by-screen from the provided screenshots.

- Profile:
  - `profile_header_card.dart`
  - `profile_sections_card.dart`
  - `info_section.dart`

## 6. Current Known Behavior

Working or verified recently:

- Auth login with `email`, `password`, and `nationalId`.
- Profile endpoint returns `200`.
- Results request now uses `studentCode`, not internal `student.id`.
- `flutter analyze` passed after results fixes.
- `flutter test` passed after results fixes.

Known backend/data-dependent behavior:

- Results currently return `404` for `studentCode=1223117`, `semester=1`.
- This is not currently a Flutter request bug; backend must have grades for that student and semester.

Known technical debt:

- Some files contain mojibake/encoding-corrupted Arabic comments and strings, for example `Ø...` sequences. UI strings may still render correctly in places, but many source comments/messages need encoding cleanup.
- Some features are fully layered while others are still lighter or placeholder-like (`content`, `schedule`, some repo placeholders).
- There are repeated profile requests on startup/dashboard in some flows. This is acceptable for now but should be optimized later.
- `ResultsCubit` still has fallback logic that fetches profile; preferred route is now passing `studentCode` from dashboard.
- Debug logs in `DashboardMenuGrid` and `ResultsCubit` should be removed or guarded once the results issue is fully accepted.

## 7. Current Git/Workspace Notes

The working tree contains many modified and untracked files. Do not reset or revert blindly.

Important untracked/added areas observed:

- New assets under `assets/`.
- `lib/core/app_assets.dart`
- `lib/features/onboarding/`
- Course registration files.
- Payment data/domain/logic/widgets.

Deleted/removed legacy files observed:

- `lib/features/courses/data/course_material.dart`
- `lib/features/courses/data/courses_repo.dart`

Treat these as intentional unless the user explicitly says otherwise.

## 8. Instructions For The Next AI/Developer

Follow these rules strictly:

1. Keep feature-driven architecture.
2. Put business state in `logic/cubit`, not inside `presentation`.
3. Keep UI widgets small and declarative.
4. Do not change API endpoints without checking Swagger or current backend behavior.
5. For results, use `studentCode` as the path parameter for `/Result/{studentId}`, not `student.id`.
6. For auth login, always send `nationalId`.
7. Preserve `studentId`, `studentCode`, `semester`, and `department` when copying or caching `UserModel`.
8. Avoid printing full API response bodies because they may include tokens or large profile data.
9. Before changing code, inspect existing patterns in that feature.
10. After meaningful code edits, run:

```text
flutter analyze
```

Run tests when changes affect logic or cross-feature behavior:

```text
flutter test
```

Run emulator only when the issue cannot be verified statically, to conserve time and credits.

## 9. Suggested Next Work

Recommended next steps:

1. Clean encoding-corrupted Arabic strings/comments.
2. Remove temporary debug logs once results behavior is approved.
3. Continue iterative UI refactor on the remaining feature folders.
4. Add focused unit tests for:
   - `UserModel.fromJson`
   - login request shape
   - results student code resolution
5. Optimize duplicate `/Students/me/profile` requests.
6. Confirm with backend team whether `/Result/{studentId}` permanently means `studentCode`.
7. Continue the doctor flow with course details, lecture upload, assignment upload, exam upload, submissions, and grading.
