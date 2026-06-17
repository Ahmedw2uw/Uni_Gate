import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/courses/domain/entities/course_entity.dart';
import 'package:nuigate/features/courses/domain/usecases/courses_usecases.dart';
import 'course_registration_state.dart';

class CourseRegistrationCubit extends Cubit<CourseRegistrationState> {
  final GetAvailableCoursesUseCase getAvailableCoursesUseCase;
  final RegisterCoursesUseCase registerCoursesUseCase;
  final DropCourseUseCase dropCourseUseCase;
  final ConfirmCoursesUseCase confirmCoursesUseCase;
  final CheckCourseExistsUseCase checkCourseExistsUseCase;

  CourseRegistrationCubit({
    required this.getAvailableCoursesUseCase,
    required this.registerCoursesUseCase,
    required this.dropCourseUseCase,
    required this.confirmCoursesUseCase,
    required this.checkCourseExistsUseCase,
  }) : super(const CourseRegistrationInitial());

  Future<void> fetchAvailableCourses(String studentId) async {
    if (state is AvailableCoursesLoading) return;
    emit(const AvailableCoursesLoading());

    if (kDebugMode) {
      debugPrint('DEBUG fetchAvailableCourses -> studentId=$studentId');
    }

    try {
      final courses = await getAvailableCoursesUseCase(studentId);
      emit(
        AvailableCoursesLoaded(
          courses: courses,
          selectedCourseIds: const [],
          totalCreditHours: 0,
        ),
      );
      if (kDebugMode) {
        debugPrint('DEBUG availableCourses count=${courses.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('CourseRegistrationCubit.fetchAvailableCourses error: $e');
      }
      emit(AvailableCoursesError(message: e.toString()));
    }
  }

  void toggleCourseSelection(CourseEntity course) {
    if (state is! AvailableCoursesLoaded) return;
    final current = state as AvailableCoursesLoaded;
    final selected = List<String>.from(current.selectedCourseIds);
    int totalHours = current.totalCreditHours;

    if (selected.contains(course.id)) {
      selected.remove(course.id);
      totalHours -= course.creditHours;
    } else {
      selected.add(course.id);
      totalHours += course.creditHours;
    }

    emit(
      current.copyWith(
        selectedCourseIds: selected,
        totalCreditHours: totalHours,
      ),
    );
  }

  Future<void> registerCourses(String? studentId) async {
    if (state is! AvailableCoursesLoaded) return;
    final current = state as AvailableCoursesLoaded;

    if (current.selectedCourseIds.isEmpty) {
      emit(
        CourseRegistrationFailure(message: 'الرجاء اختيار مقرر واحد على الأقل'),
      );
      emit(current);
      return;
    }

    emit(const CourseRegistrationSubmitting());

    try {
      final courseIds = current.selectedCourseIds
          .map((id) => int.tryParse(id))
          .whereType<int>()
          .toList();

      final result = await registerCoursesUseCase(courseIds);
      emit(
        CourseRegistrationSuccess(
          message: result['message']?.toString() ?? 'تم التسجيل بنجاح',
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('CourseRegistrationCubit.registerCourses error: $e');
      }
      emit(CourseRegistrationFailure(message: e.toString()));
    }
  }

  Future<void> dropCourse({
    required String studentId,
    required String courseId,
  }) async {
    try {
      await dropCourseUseCase(studentId: studentId, courseId: courseId);
      emit(const CourseDroppedSuccess());
      await fetchAvailableCourses(studentId);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('CourseRegistrationCubit.dropCourse error: $e');
      }
      emit(CourseRegistrationFailure(message: e.toString()));
    }
  }

  Future<void> confirmCourses(String studentId) async {
    try {
      await confirmCoursesUseCase(studentId);
      emit(const CoursesConfirmedSuccess());
    } catch (e) {
      if (kDebugMode) {
        debugPrint('CourseRegistrationCubit.confirmCourses error: $e');
      }
      emit(CourseRegistrationFailure(message: e.toString()));
    }
  }

  Future<bool> checkCourseExists(String courseId) async {
    try {
      return await checkCourseExistsUseCase(courseId);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('CourseRegistrationCubit.checkCourseExists error: $e');
      }
      return false;
    }
  }

  void reset() {
    emit(const CourseRegistrationInitial());
  }
}
