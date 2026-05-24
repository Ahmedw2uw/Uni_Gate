import 'package:nuigate/core/constants/api_endpoints.dart';
import 'package:nuigate/features/courses/data/models/course_model.dart';
import 'package:nuigate/network/api_services.dart';

abstract class CoursesRemoteDataSource {
  Future<List<CourseModel>> getCourses({
    required int year,
    required int semester,
    required int departmentId,
  });

  Future<CourseModel> getCourseById(String courseId);

  Future<CourseModel> getCourseWithContent(String courseId);

  Future<List<CourseModel>> searchCourses(String query);
}

class CoursesRemoteDataSourceImpl implements CoursesRemoteDataSource {
  final ApiServices apiServices;

  CoursesRemoteDataSourceImpl(this.apiServices);

  @override
  Future<List<CourseModel>> getCourses({
    required int year,
    required int semester,
    required int departmentId,
  }) async {
    try {
      if (departmentId <= 0) {
        throw Exception('قيمة departmentId غير صحيحة');
      }

      final response = await apiServices.get(
        ApiEndpoints.getCoursesByYear,
        queryParameters: {
          'Year': year,
          'Semester': semester,
          'DepartmentId': departmentId,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List
            ? response.data
            : response.data['courses'] ?? response.data['data'] ?? [];

        return (data)
            .map(
              (course) => CourseModel.fromJson(course as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception(
          'فشل جلب المقررات: ${response.statusMessage} (${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('خطأ في جلب المقررات: $e');
    }
  }

  @override
  Future<CourseModel> getCourseById(String courseId) async {
    try {
      final response = await apiServices.get(
        ApiEndpoints.getCourseDetails(courseId),
      );

      if (response.statusCode == 200) {
        return CourseModel.fromJson(response.data);
      } else {
        throw Exception('فشل جلب المقرر: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('خطأ في جلب المقرر: $e');
    }
  }

  @override
  Future<CourseModel> getCourseWithContent(String courseId) async {
    try {
      final response = await apiServices.get(
        ApiEndpoints.getCourseWithContent(courseId),
      );

      if (response.statusCode == 200) {
        return CourseModel.fromJson(response.data);
      } else {
        throw Exception('فشل جلب محتوى المقرر: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('خطأ في جلب محتوى المقرر: $e');
    }
  }

  @override
  Future<List<CourseModel>> searchCourses(String query) async {
    try {
      final response = await apiServices.get(
        '/courses/search',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['courses'] ?? response.data;
        return (data)
            .map(
              (course) => CourseModel.fromJson(course as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception('فشل البحث: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('خطأ في البحث: $e');
    }
  }
}
