import 'package:nuigate/features/courses/data/datasources/courses_remote_datasource.dart';
import 'package:nuigate/features/courses/domain/entities/course_entity.dart';
import 'package:nuigate/features/courses/domain/repositories/courses_repository.dart';

class CoursesRepositoryImpl implements CoursesRepository {
  final CoursesRemoteDataSource remoteDataSource;

  CoursesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CourseEntity>> getCourses({
    required int year,
    required int semester,
    required int departmentId,
  }) async {
    try {
      return await remoteDataSource.getCourses(
        year: year,
        semester: semester,
        departmentId: departmentId,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CourseEntity> getCourseById(String courseId) async {
    try {
      return await remoteDataSource.getCourseById(courseId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CourseEntity> getCourseWithContent(String courseId) async {
    try {
      return await remoteDataSource.getCourseWithContent(courseId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CourseEntity>> searchCourses(String query) async {
    try {
      return await remoteDataSource.searchCourses(query);
    } catch (e) {
      rethrow;
    }
  }
}
