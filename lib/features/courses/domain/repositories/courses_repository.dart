import 'package:nuigate/features/courses/domain/entities/course_entity.dart';

abstract class CoursesRepository {
  Future<List<CourseEntity>> getCourses({
    required int year,
    required int semester,
    required int departmentId,
  });

  Future<CourseEntity> getCourseById(String courseId);

  Future<CourseEntity> getCourseWithContent(String courseId);

  Future<List<CourseEntity>> searchCourses(String query);
}
