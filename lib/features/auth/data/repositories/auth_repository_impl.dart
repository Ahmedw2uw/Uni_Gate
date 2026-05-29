import 'package:nuigate/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:nuigate/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:nuigate/features/auth/domain/entities/user_entity.dart';
import 'package:nuigate/features/auth/domain/repositories/auth_repository.dart';
import 'package:nuigate/utils/jwt_helper.dart';
import 'package:nuigate/utils/pref_helpers.dart';

/// AuthRepositoryImpl - تنفيذ Auth Repository
/// يتعامل مع logic التطبيق والتوازن بين البيانات المحلية والبعيدة
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      // استدعاء API للتحقق من بيانات تسجيل الدخول
      var userModel = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // حفظ التوكن والبيانات الأساسية
      if (userModel.token != null) {
        // حفظ التوكن
        await PrefHelpers.saveToken(userModel.token!);

        // استخراج الـ role من JWT token
        final role = JwtHelper.extractRole(userModel.token!);

        // حفظ بيانات المستخدم
        await PrefHelpers.saveEmail(userModel.email);
        await PrefHelpers.saveUserName(userModel.name);
        await PrefHelpers.saveUserId(userModel.id);

        // حفظ الـ role إذا تم استخراجه
        if (role != null) {
          await PrefHelpers.saveUserRole(role);

          // تحديث userModel مع الـ role المستخرج
          userModel = userModel.copyWith(role: role);
        }

        // حفظ صورة الملف الشخصي إذا وجدت
        if (userModel.profileImage != null) {
          await PrefHelpers.saveProfileImage(userModel.profileImage!);
        }
      }

      // حفظ المستخدم محلياً أيضاً
      await localDataSource.saveUser(userModel);

      // حفظ التوكن في localDataSource
      if (userModel.token != null) {
        await localDataSource.saveToken(userModel.token!);
      }

      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    try {
      // نلغي تمرير التوكن يدوياً لأن الـ DataSource والـ API يتكفلان بذلك
      final userModel = await remoteDataSource.getCurrentUser();

      await localDataSource.saveUser(userModel);
      return userModel;
    } catch (e) {
      final localUser = await localDataSource.getUser();
      if (localUser != null) return localUser;
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      // حذف البيانات المحفوظة محلياً
      await localDataSource.clearUser();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await localDataSource.hasToken();
    } catch (e) {
      return false;
    }
  }
}
