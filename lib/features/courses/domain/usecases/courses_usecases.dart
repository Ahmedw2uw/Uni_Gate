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

class SearchCoursesUseCase {
  final CoursesRepository repository;

  SearchCoursesUseCase(this.repository);

  Future<List<CourseEntity>> call(String query) {
    return repository.searchCourses(query);
  }
}
