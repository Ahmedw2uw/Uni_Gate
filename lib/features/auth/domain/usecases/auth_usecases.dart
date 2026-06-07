import 'package:flutter/foundation.dart';
import 'package:nuigate/features/auth/domain/entities/user_entity.dart';
import 'package:nuigate/features/auth/domain/repositories/auth_repository.dart';

/// LoginUseCase - عملية تسجيل الدخول
/// مسؤول عن تنفيذ منطق تسجيل الدخول
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  /// تنفيذ عملية تسجيل الدخول
  Future<UserEntity> call({
    required String email,
    required String password,
    required String nationalId,
  }) {
    debugPrint('Executing LoginUseCase with email: $email');
    return repository.login(
      email: email,
      password: password,
      nationalId: nationalId,
    );
  }
}

/// GetCurrentUserUseCase - الحصول على بيانات المستخدم الحالي
class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  // ✅ جعلنا الـ return غير nullable ليتناسب مع منطق الـ login المعتمد على البيانات الكاملة
  Future<UserEntity> call() async {
    final user = await repository.getCurrentUser();
    if (user == null) {
      throw Exception("لا يمكن جلب بيانات المستخدم، يرجى التحقق من الاتصال.");
    }
    return user;
  }
}

/// LogoutUseCase - تسجيل الخروج
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}

/// CheckAuthStatusUseCase - التحقق من حالة المصادقة
class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  Future<bool> call() {
    return repository.isLoggedIn();
  }
}
