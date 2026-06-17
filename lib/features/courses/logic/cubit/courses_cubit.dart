import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/auth/domain/entities/user_entity.dart';
import 'package:nuigate/features/auth/logic/cubit/auth_cubit.dart';
import 'package:nuigate/features/auth/logic/cubit/auth_state.dart';
import 'package:nuigate/features/courses/domain/entities/course_entity.dart';
import 'package:nuigate/features/courses/domain/usecases/courses_usecases.dart';
import 'courses_state.dart';

class CoursesCubit extends Cubit<CoursesState> {
  final GetCoursesUseCase getCoursesUseCase;
  final GetCourseByIdUseCase getCourseByIdUseCase;
  final GetCourseWithContentUseCase getCourseWithContentUseCase;
  final GetCourseContentUseCase getCourseContentUseCase;
  final GetMyCoursesUseCase getMyCoursesUseCase;
  final AuthCubit authCubit;

  String? _currentCourseId;

  CoursesCubit({
    required this.getCoursesUseCase,
    required this.getCourseByIdUseCase,
    required this.getCourseWithContentUseCase,
    required this.getCourseContentUseCase,
    required this.getMyCoursesUseCase,
    required this.authCubit,
  }) : super(const CoursesInitial());

  Future<void> fetchCourses() async {
    if (state is CoursesLoading) return;
    emit(const CoursesLoading());

    try {
      final authState = authCubit.state;
      UserEntity? user;
      if (authState is AuthSuccess) user = authState.user;
      if (authState is Authenticated) user = authState.user;
      if (user == null) {
        emit(const CoursesFailure(message: 'يجب تسجيل الدخول لعرض المقررات'));
        return;
      }

      final int? deptId = user.departmentId;
      if (deptId == null || deptId == 0) {
        emit(const CoursesUserNotAssigned());
        return;
      }

      final int year = (user.academicYear != null && user.academicYear != 0)
          ? user.academicYear!
          : 1;

      final courses = await getCoursesUseCase(
        year: year,
        semester: user.semester ?? 1,
        departmentId: deptId,
      );

      emit(CoursesSuccess(courses: courses));
    } catch (e) {
      emit(CoursesFailure(message: e.toString()));
    }
  }

  Future<void> fetchMyCourses() async {
    if (state is CoursesLoading) return;
    emit(const CoursesLoading());

    try {
      final courses = await getMyCoursesUseCase();
      emit(CoursesSuccess(courses: courses));
    } catch (e) {
      emit(CoursesFailure(message: e.toString()));
    }
  }

  Future<void> fetchCourseContent(String courseId) async {
    if (courseId.isEmpty) {
      emit(const CourseContentFailure(message: 'معرف المقرر غير صحيح'));
      return;
    }

    if (_currentCourseId == courseId && state is CourseContentLoading) {
      return;
    }

    _currentCourseId = courseId;
    emit(const CourseContentLoading());

    try {
      final authState = authCubit.state;
      UserEntity? user;
      if (authState is AuthSuccess) user = authState.user;
      if (authState is Authenticated) user = authState.user;

      final int? studentId = user?.studentId ?? int.tryParse(user?.id ?? '');

      if (kDebugMode) {
        debugPrint(
          'DEBUG fetchCourseContent -> authUserId=${user?.id} '
          'authUserStudentId=${user?.studentId} '
          'resolvedStudentId=$studentId '
          'courseId=$courseId',
        );
      }

      if (studentId == null || studentId <= 0) {
        emit(
          const CourseContentFailure(
            message: 'لا يوجد معرف طالب صالح للوصول للمحتوى',
          ),
        );
        return;
      }

      late final CourseEntity courseDetails;
      try {
        courseDetails = await getCourseWithContentUseCase(courseId);
      } catch (e) {
        if (kDebugMode) {
          debugPrint(
            'DEBUG: getCourseWithContent failed, fallback to student-specific content: $e',
          );
        }
        courseDetails = await getCourseContentUseCase(
          studentId: studentId.toString(),
          courseId: courseId,
        );
      }

      if (kDebugMode) {
        debugPrint(
          'DEBUG: Course Details Retrieved -> ${courseDetails.id}, ${courseDetails.name}',
        );
      }

      emit(
        CourseContentSuccess(
          course: courseDetails,
          courseContent: courseDetails.content,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ERROR in fetchCourseContent: $e');
      }

      String errorMessage = 'حدث خطأ أثناء جلب البيانات';
      if (e.toString().contains('403') || e.toString().contains('Forbidden')) {
        errorMessage = 'عفواً، أنت غير مسجل في هذا المقرر للوصول للمحتوى';
      } else {
        errorMessage = e.toString();
      }

      emit(CourseContentFailure(message: errorMessage));
    }
  }
}
