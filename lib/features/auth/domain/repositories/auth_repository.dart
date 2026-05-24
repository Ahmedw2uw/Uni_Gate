import 'package:nuigate/features/auth/domain/entities/user_entity.dart';

/// Auth Repository - عقد Domain Layer
/// يحدد العمليات التي يمكن تنفيذها على المصادقة
abstract class AuthRepository {
  /// محاولة تسجيل الدخول
  /// يرجع UserEntity في حالة النجاح
  /// أو يرمي استثناء في حالة الفشل
  Future<UserEntity> login({required String email, required String password});

  /// الحصول على المستخدم الحالي
  Future<UserEntity?> getCurrentUser();

  /// تسجيل الخروج
  Future<void> logout();

  /// التحقق من وجود token محفوظ
  Future<bool> isLoggedIn();
}
