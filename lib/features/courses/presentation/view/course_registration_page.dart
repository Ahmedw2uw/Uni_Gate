import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/auth/domain/entities/user_entity.dart';
import 'package:nuigate/features/auth/logic/cubit/auth_cubit.dart';
import 'package:nuigate/features/auth/logic/cubit/auth_state.dart';
import 'package:nuigate/features/courses/domain/entities/course_entity.dart';
import 'package:nuigate/features/courses/logic/cubit/course_registration_cubit.dart';
import 'package:nuigate/features/courses/logic/cubit/course_registration_state.dart';
import 'package:nuigate/features/courses/presentation/widgets/registration/available_course_card.dart';
import 'package:nuigate/features/courses/presentation/widgets/registration/registration_bottom_bar.dart';
import 'package:nuigate/features/courses/presentation/widgets/registration/registration_confirm_dialog.dart';
import 'package:nuigate/features/courses/presentation/widgets/registration/registration_filter_bar.dart';
import 'package:nuigate/shared/widgets/app_scaffold.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class CourseRegistrationPage extends StatefulWidget {
  const CourseRegistrationPage({super.key});

  @override
  State<CourseRegistrationPage> createState() => _CourseRegistrationPageState();
}

class _CourseRegistrationPageState extends State<CourseRegistrationPage> {
  int? _selectedYear;
  int? _selectedSemester;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final user = _getUser(context);
      final studentId = user?.studentId ?? int.tryParse(user?.id ?? '');
      if (kDebugMode) {
        debugPrint(
          'DEBUG CourseRegistrationPage.initState -> userId=${user?.id} '
          'studentId=${user?.studentId} '
          'resolvedStudentId=$studentId',
        );
      }
      if (studentId != null && studentId > 0) {
        context.read<CourseRegistrationCubit>().fetchAvailableCourses(
          studentId.toString(),
        );
      }
    });
  }

  UserEntity? _getUser(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) return authState.user;
    if (authState is Authenticated) return authState.user;
    return null;
  }

  List<CourseEntity> _filterCourses(List<CourseEntity> courses) {
    return courses.where((course) {
      var yearMatch = true;
      var semesterMatch = true;
      if (_selectedYear != null && course.academicYear != null) {
        yearMatch = course.academicYear == _selectedYear;
      }
      if (_selectedSemester != null && course.semester != null) {
        semesterMatch = course.semester == _selectedSemester;
      }
      return yearMatch && semesterMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'تسجيل المقررات',
      child: BlocConsumer<CourseRegistrationCubit, CourseRegistrationState>(
        listener: (context, state) {
          if (state is CourseRegistrationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is CourseRegistrationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AvailableCoursesLoading ||
              state is CourseRegistrationInitial) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (state is AvailableCoursesError) {
            return _ErrorView(
              message: state.message,
              onRetry: () {
                final user = _getUser(context);
                final studentId =
                    user?.studentId ?? int.tryParse(user?.id ?? '');
                if (studentId != null && studentId > 0) {
                  context.read<CourseRegistrationCubit>().fetchAvailableCourses(
                    studentId.toString(),
                  );
                }
              },
            );
          }

          final loaded = _resolveLoadedState(context, state);
          if (loaded == null) return const SizedBox.shrink();

          final filtered = _filterCourses(loaded.courses);
          final isSubmitting = state is CourseRegistrationSubmitting;

          return Column(
            children: [
              RegistrationFilterBar(
                selectedYear: _selectedYear,
                selectedSemester: _selectedSemester,
                onYearChanged: (value) => setState(() => _selectedYear = value),
                onSemesterChanged: (value) =>
                    setState(() => _selectedSemester = value),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? const _EmptyView()
                    : ListView.builder(
                        padding: EdgeInsets.all(16.r),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final course = filtered[index];
                          return AvailableCourseCard(
                            course: course,
                            isSelected: loaded.selectedCourseIds.contains(
                              course.id,
                            ),
                            onToggle: (_) {
                              context
                                  .read<CourseRegistrationCubit>()
                                  .toggleCourseSelection(course);
                            },
                          );
                        },
                      ),
              ),
              RegistrationBottomBar(
                selectedCount: loaded.selectedCourseIds.length,
                totalCreditHours: loaded.totalCreditHours,
                isLoading: isSubmitting,
                onRegister: () => _showConfirmDialog(context, loaded),
              ),
            ],
          );
        },
      ),
    );
  }

  AvailableCoursesLoaded? _resolveLoadedState(
    BuildContext context,
    CourseRegistrationState state,
  ) {
    if (state is AvailableCoursesLoaded) return state;

    final current = context.read<CourseRegistrationCubit>().state;
    if (current is AvailableCoursesLoaded &&
        (state is CourseRegistrationSubmitting ||
            state is CourseRegistrationFailure)) {
      return current;
    }

    return null;
  }

  void _showConfirmDialog(BuildContext context, AvailableCoursesLoaded state) {
    final user = _getUser(context);
    showDialog(
      context: context,
      builder: (_) => RegistrationConfirmDialog(
        selectedCount: state.selectedCourseIds.length,
        onConfirm: () {
          context.read<CourseRegistrationCubit>().registerCourses(user?.id);
        },
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.library_books_outlined,
              size: 64.r,
              color: AppColors.primary.withValues(alpha: 0.4),
            ),
            SizedBox(height: 16.h),
            const CustomText(
              'لا توجد مقررات متاحة للتسجيل حاليا',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            const CustomText(
              'يرجى مراجعة شؤون الطلاب للاستفسار عن المقررات المتاحة.',
              fontSize: 13,
              color: Colors.black54,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64.r, color: Colors.red[300]),
            SizedBox(height: 16.h),
            const CustomText(
              'حدث خطأ',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 8.h),
            CustomText(
              message,
              fontSize: 13,
              color: Colors.black54,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
