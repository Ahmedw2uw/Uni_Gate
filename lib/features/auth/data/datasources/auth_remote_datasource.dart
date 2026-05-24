import 'package:nuigate/core/constants/api_endpoints.dart';
import 'package:nuigate/features/auth/data/models/user_model.dart';
import 'package:nuigate/features/courses/data/models/course_model.dart';
import 'package:nuigate/network/api_services.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });
  // أضف هذه الدالة داخل abstract class AuthRemoteDataSource
Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiServices apiServices;

  AuthRemoteDataSourceImpl(this.apiServices);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiServices.post(
        '/Authentication/login',
        data: {"email": email, "password": password},
      );

      print("📥 Login Response: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;

        if (data == null || data is! Map<String, dynamic>) {
          throw Exception("Invalid response format");
        }

        // ✅ هنا مفيش data wrapper
        if (!data.containsKey('token')) {
          throw Exception("Token missing in response");
        }

        return UserModel.fromJson(data);
      }

      final errorMessage = response.data is Map<String, dynamic>
          ? response.data['detail'] ?? response.data['message']
          : "Unknown error";

      throw Exception("Login failed: $errorMessage");
    } catch (e) {
      print("❌ Login Error: $e");
      throw Exception("Login failed: $e");
    }
  }


// أضف هذا الـ Implementation داخل class AuthRemoteDataSourceImpl
// داخل abstract class AuthRemoteDataSource
 // لا نحتاج تمرير التوكن هنا لأن ApiServices غالباً تضيفه تلقائياً من الـ Interceptors

// داخل class AuthRemoteDataSourceImpl
@override
Future<UserModel>   getCurrentUser() async {
  try {
    final response = await apiServices.get(
      '/Students/me/profile', 
    );
    
    print("📥 Profile Response: ${response.data}"); // مهم جداً للتأكد من وصول departmentId

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    }
    throw Exception("Failed to load profile from server");
  } catch (e) {
    print("❌ Profile Error: $e");
    throw Exception("Profile Error: $e");
  }
}
Future<CourseModel> fetchFullContent(String courseId) async {
  try {
    final response = await apiServices.get(ApiEndpoints.getCourseWithContent(courseId));
    if (response.statusCode == 200) {
      // هنا نقوم بتحويل الـ JSON الذي يحتوي على المحتوى
      return CourseModel.fromJson(response.data);
    }
    throw Exception("فشل تحميل المحتوى");
  } catch (e) {
    throw Exception("خطأ: $e");
  }
}
  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiServices.post(
        '/Authentication/register',
        data: {"userName": name, "email": email, "password": password},
      );

      print("📥 Register Response: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data is! Map<String, dynamic>) {
          throw Exception("Invalid register response");
        }

        return UserModel.fromJson(data);
      }

      throw Exception(
        "Register failed: ${response.data?['detail'] ?? response.statusMessage}",
      );
    } catch (e) {
      print("❌ Register Error: $e");
      throw Exception("Register failed: $e");
    }
  }
}
