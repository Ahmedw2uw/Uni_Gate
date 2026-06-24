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
      final user = _currentUser;
      if (user == null) {
        emit(const CoursesFailure(message: 'يجب تسجيل الدخول لعرض المقررات'));
        return;
      }

      final deptId = user.departmentId;
      if (deptId == null || deptId == 0) {
        emit(const CoursesUserNotAssigned());
        return;
      }

      final year = (user.academicYear != null && user.academicYear != 0)
          ? user.academicYear!
          : 1;

      final courses = await getCoursesUseCase(
        year: year,
        semester: user.semester ?? 1,
        departmentId: deptId,
      );

      emit(CoursesSuccess(courses: courses));
    } catch (error) {
      emit(CoursesFailure(message: error.toString()));
    }
  }

  Future<void> fetchMyCourses() async {
    if (state is CoursesLoading) return;
    emit(const CoursesLoading());

    try {
      final courses = await getMyCoursesUseCase();
      emit(CoursesSuccess(courses: courses));
    } catch (error) {
      emit(CoursesFailure(message: error.toString()));
    }
  }

  Future<void> fetchCourseContent(String courseId) async {
    if (courseId.isEmpty) {
      emit(const CourseContentFailure(message: 'معرف المقرر غير صحيح'));
      return;
    }

    if (_currentCourseId == courseId && state is CourseContentLoading) return;

    _currentCourseId = courseId;
    emit(const CourseContentLoading());

    final user = _currentUser;
    final studentId = user?.studentId ?? int.tryParse(user?.id ?? '');

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

    try {
      final courseDetails = await _loadCourseContent(
        courseId: courseId,
        studentId: studentId,
      );

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
    } catch (error) {
      if (kDebugMode) debugPrint('ERROR in fetchCourseContent: $error');

      if (_isUnavailableContentError(error)) {
        final emptyCourse = CourseEntity(
          id: courseId,
          name: 'محتوى المقرر',
          code: '',
          creditHours: 0,
          price: 0,
          content: const <dynamic>[],
        );
        emit(
          CourseContentSuccess(
            course: emptyCourse,
            courseContent: const <dynamic>[],
          ),
        );
        return;
      }

      emit(CourseContentFailure(message: _courseContentErrorMessage(error)));
    }
  }

  Future<CourseEntity> _loadCourseContent({
    required String courseId,
    required int studentId,
  }) async {
    try {
      return await getCourseWithContentUseCase(courseId);
    } catch (error) {
      if (kDebugMode) {
        debugPrint(
          'DEBUG: getCourseWithContent failed, fallback to student-specific content: $error',
        );
      }
      return getCourseContentUseCase(
        studentId: studentId.toString(),
        courseId: courseId,
      );
    }
  }

  UserEntity? get _currentUser {
    final authState = authCubit.state;
    if (authState is AuthSuccess) return authState.user;
    if (authState is Authenticated) return authState.user;
    return null;
  }

  bool _isUnavailableContentError(Object error) {
    final text = error.toString().toLowerCase();
    return text.contains('403') ||
        text.contains('404') ||
        text.contains('forbidden') ||
        text.contains('not found');
  }

  String _courseContentErrorMessage(Object error) {
    final text = error.toString();
    if (text.contains('401') || text.toLowerCase().contains('unauthorized')) {
      return 'انتهت جلسة الدخول. برجاء تسجيل الدخول مرة أخرى.';
    }
    return 'حدث خطأ أثناء جلب محتوى المقرر';
  }
}
