import 'package:flutter/foundation.dart';
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

  Future<List<CourseModel>> getMyCourses();

  Future<List<CourseModel>> getAvailableCourses(String studentId);

  Future<List<CourseModel>> getCoursesByYear({
    required int year,
    required int semester,
    required int departmentId,
  });

  Future<CourseModel> getCourseContent({
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
      final endpoint = ApiEndpoints.getCourseWithContent(courseId);
      if (kDebugMode) {
        debugPrint(
          'DEBUG CoursesRemoteDataSource.getCourseWithContent -> $endpoint',
        );
      }
      final response = await apiServices.get(endpoint);
      if (kDebugMode) {
        debugPrint('DEBUG getCourseWithContent status=${response.statusCode}');
      }

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
  Future<List<CourseModel>> getMyCourses() async {
    try {
      final response = await apiServices.get(ApiEndpoints.getMyCourses);

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
      throw Exception('خطأ في جلب مقرراتي: $e');
    }
  }

  @override
  Future<List<CourseModel>> getAvailableCourses(String studentId) async {
    try {
      final endpoint = ApiEndpoints.getAvailableCourses(studentId);
      if (kDebugMode) {
        debugPrint(
          'DEBUG CoursesRemoteDataSource.getAvailableCourses -> $endpoint',
        );
      }
      final response = await apiServices.get(endpoint);
      if (kDebugMode) {
        debugPrint('DEBUG getAvailableCourses status=${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List
            ? response.data
            : response.data['courses'] ?? response.data['data'] ?? [];

        if (kDebugMode) {
          debugPrint('DEBUG getAvailableCourses count=${data.length}');
        }

        return (data)
            .map(
              (course) => CourseModel.fromJson(course as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception(
          'فشل جلب المقررات المتاحة: ${response.statusMessage} (${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('خطأ في جلب المقررات المتاحة: $e');
    }
  }

  @override
  Future<List<CourseModel>> getCoursesByYear({
    required int year,
    required int semester,
    required int departmentId,
  }) async {
    return getCourses(
      year: year,
      semester: semester,
      departmentId: departmentId,
    );
  }

  @override
  Future<CourseModel> getCourseContent({
    required String studentId,
    required String courseId,
  }) async {
    try {
      final endpoint = ApiEndpoints.getCourseContent(studentId, courseId);
      if (kDebugMode) {
        debugPrint(
          'DEBUG CoursesRemoteDataSource.getCourseContent -> $endpoint',
        );
      }
      final response = await apiServices.get(endpoint);
      if (kDebugMode) {
        debugPrint('DEBUG getCourseContent status=${response.statusCode}');
      }

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
  Future<Map<String, dynamic>> registerCourses(List<int> courseIds) async {
    try {
      final response = await apiServices.post(
        ApiEndpoints.registerCourses,
        data: {'courseIds': courseIds},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : {'success': true};
      } else {
        throw Exception('فشل تسجيل المقررات: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('خطأ في تسجيل المقررات: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getRegisterSuccess(String sessionId) async {
    try {
      final response = await apiServices.get(
        ApiEndpoints.registerSuccess(sessionId),
      );

      if (response.statusCode == 200) {
        return response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : {'success': true};
      } else {
        throw Exception('فشل التحقق من التسجيل: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('خطأ في التحقق من التسجيل: $e');
    }
  }

  @override
  Future<void> dropCourse({
    required String studentId,
    required String courseId,
  }) async {
    try {
      final response = await apiServices.delete(
        ApiEndpoints.dropCourse(studentId, courseId),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('فشل حذف المقرر: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('خطأ في حذف المقرر: $e');
    }
  }

  @override
  Future<void> confirmCourses(String studentId) async {
    try {
      final response = await apiServices.post(
        ApiEndpoints.confirmCourses(studentId),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('فشل تأكيد المقررات: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('خطأ في تأكيد المقررات: $e');
    }
  }

  @override
  Future<bool> checkCourseExists(String courseId) async {
    try {
      final response = await apiServices.get(
        ApiEndpoints.checkCourseExists(courseId),
      );

      if (response.statusCode == 200) {
        if (response.data is bool) return response.data as bool;
        if (response.data is Map) {
          return response.data['exists'] == true ||
              response.data['exists'] == 'true';
        }
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) debugPrint('checkCourseExists error: $e');
      return false;
    }
  }
}
