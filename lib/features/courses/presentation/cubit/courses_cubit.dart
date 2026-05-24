import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/auth/domain/entities/user_entity.dart';
import 'package:nuigate/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nuigate/features/auth/presentation/cubit/auth_state.dart';
import 'package:nuigate/features/courses/domain/entities/course_entity.dart';
import 'package:nuigate/features/courses/domain/usecases/courses_usecases.dart';
import 'courses_state.dart';

class CoursesCubit extends Cubit<CoursesState> {
  final GetCoursesUseCase getCoursesUseCase;
  final GetCourseByIdUseCase getCourseByIdUseCase;
  final SearchCoursesUseCase searchCoursesUseCase;
  final AuthCubit authCubit;

  String? _currentCourseId;

  CoursesCubit({
    required this.getCoursesUseCase,
    required this.getCourseByIdUseCase,
    required this.searchCoursesUseCase,
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
      if (user == null) return;

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

  Future<void> searchCourses(String query) async {
    if (query.isEmpty) {
      await fetchCourses();
      return;
    }
    emit(const CoursesLoading());
    try {
      final allCourses = await searchCoursesUseCase(query);
      emit(CoursesSuccess(courses: allCourses));
    } catch (e) {
      emit(CoursesFailure(message: e.toString()));
    }
  }

  Future<void> fetchCourseContent(String courseId) async {
    final currentCourses = (state is CoursesSuccess) ? (state as CoursesSuccess).courses : <CourseEntity>[];
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
      final courseDetails = await getCourseByIdUseCase(courseId);

      if (kDebugMode) {
        print(
          "DEBUG: Course Details Retrieved -> ${courseDetails.id}, ${courseDetails.name}",
        );
      }

    emit(CourseContentSuccess(
  course: courseDetails,
  courseContent: courseDetails.content,));
    } catch (e) {
      if (kDebugMode) {
        print("ERROR in fetchCourseContent: $e");
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
