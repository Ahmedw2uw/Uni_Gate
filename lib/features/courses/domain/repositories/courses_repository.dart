import 'package:nuigate/features/courses/domain/entities/course_entity.dart';

abstract class CoursesRepository {
  Future<List<CourseEntity>> getCourses({
    required int year,
    required int semester,
    required int departmentId,
  });

  Future<CourseEntity> getCourseById(String courseId);

  Future<CourseEntity> getCourseWithContent(String courseId);

  Future<List<CourseEntity>> getMyCourses();

  Future<List<CourseEntity>> getAvailableCourses(String studentId);

  Future<List<CourseEntity>> getCoursesByYear({
    required int year,
    required int semester,
    required int departmentId,
  });

  Future<CourseEntity> getCourseContent({
    required String studentId,
    required String courseId,
  });

  Future<Map<String, dynamic>> registerCourses(List<int> courseIds);

  Future<Map<String, dynamic>> getRegisterSuccess(String sessionId);

  Future<void> dropCourse({
    required String studentId,
    required String courseId,
  });

  Future<void> confirmCourses(String studentId);

  Future<bool> checkCourseExists(String courseId);
}
