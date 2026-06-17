import 'package:nuigate/features/courses/domain/entities/course_entity.dart';
import 'package:nuigate/features/courses/domain/repositories/courses_repository.dart';

class GetCoursesUseCase {
  final CoursesRepository repository;

  GetCoursesUseCase(this.repository);

  Future<List<CourseEntity>> call({
    required int year,
    required int semester,
    required int departmentId,
  }) {
    return repository.getCourses(
      year: year,
      semester: semester,
      departmentId: departmentId,
    );
  }
}

class GetCourseByIdUseCase {
  final CoursesRepository repository;

  GetCourseByIdUseCase(this.repository);

  Future<CourseEntity> call(String courseId) {
    return repository.getCourseById(courseId);
  }
}

class GetCourseWithContentUseCase {
  final CoursesRepository repository;

  GetCourseWithContentUseCase(this.repository);

  Future<CourseEntity> call(String courseId) {
    return repository.getCourseWithContent(courseId);
  }
}

class GetMyCoursesUseCase {
  final CoursesRepository repository;

  GetMyCoursesUseCase(this.repository);

  Future<List<CourseEntity>> call() {
    return repository.getMyCourses();
  }
}

class GetAvailableCoursesUseCase {
  final CoursesRepository repository;

  GetAvailableCoursesUseCase(this.repository);

  Future<List<CourseEntity>> call(String studentId) {
    return repository.getAvailableCourses(studentId);
  }
}

class GetCoursesByYearUseCase {
  final CoursesRepository repository;

  GetCoursesByYearUseCase(this.repository);

  Future<List<CourseEntity>> call({
    required int year,
    required int semester,
    required int departmentId,
  }) {
    return repository.getCoursesByYear(
      year: year,
      semester: semester,
      departmentId: departmentId,
    );
  }
}

class GetCourseContentUseCase {
  final CoursesRepository repository;

  GetCourseContentUseCase(this.repository);

  Future<CourseEntity> call({
    required String studentId,
    required String courseId,
  }) {
    return repository.getCourseContent(
      studentId: studentId,
      courseId: courseId,
    );
  }
}

class RegisterCoursesUseCase {
  final CoursesRepository repository;

  RegisterCoursesUseCase(this.repository);

  Future<Map<String, dynamic>> call(List<int> courseIds) {
    return repository.registerCourses(courseIds);
  }
}

class GetRegisterSuccessUseCase {
  final CoursesRepository repository;

  GetRegisterSuccessUseCase(this.repository);

  Future<Map<String, dynamic>> call(String sessionId) {
    return repository.getRegisterSuccess(sessionId);
  }
}

class DropCourseUseCase {
  final CoursesRepository repository;

  DropCourseUseCase(this.repository);

  Future<void> call({required String studentId, required String courseId}) {
    return repository.dropCourse(studentId: studentId, courseId: courseId);
  }
}

class ConfirmCoursesUseCase {
  final CoursesRepository repository;

  ConfirmCoursesUseCase(this.repository);

  Future<void> call(String studentId) {
    return repository.confirmCourses(studentId);
  }
}

class CheckCourseExistsUseCase {
  final CoursesRepository repository;

  CheckCourseExistsUseCase(this.repository);

  Future<bool> call(String courseId) {
    return repository.checkCourseExists(courseId);
  }
}
