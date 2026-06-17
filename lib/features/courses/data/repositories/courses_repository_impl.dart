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
  Future<List<CourseEntity>> getMyCourses() async {
    try {
      return await remoteDataSource.getMyCourses();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CourseEntity>> getAvailableCourses(String studentId) async {
    try {
      return await remoteDataSource.getAvailableCourses(studentId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CourseEntity>> getCoursesByYear({
    required int year,
    required int semester,
    required int departmentId,
  }) async {
    try {
      return await remoteDataSource.getCoursesByYear(
        year: year,
        semester: semester,
        departmentId: departmentId,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CourseEntity> getCourseContent({
    required String studentId,
    required String courseId,
  }) async {
    try {
      return await remoteDataSource.getCourseContent(
        studentId: studentId,
        courseId: courseId,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> registerCourses(List<int> courseIds) async {
    try {
      return await remoteDataSource.registerCourses(courseIds);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getRegisterSuccess(String sessionId) async {
    try {
      return await remoteDataSource.getRegisterSuccess(sessionId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> dropCourse({
    required String studentId,
    required String courseId,
  }) async {
    try {
      return await remoteDataSource.dropCourse(
        studentId: studentId,
        courseId: courseId,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> confirmCourses(String studentId) async {
    try {
      return await remoteDataSource.confirmCourses(studentId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> checkCourseExists(String courseId) async {
    try {
      return await remoteDataSource.checkCourseExists(courseId);
    } catch (e) {
      rethrow;
    }
  }
}
