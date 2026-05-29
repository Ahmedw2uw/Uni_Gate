import 'package:equatable/equatable.dart';
import 'package:nuigate/features/auth/domain/entities/user_entity.dart';

/// الحالات الممكنة للمصادقة
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// الحالة الأولية
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// حالة التحميل - جاري تنفيذ عملية
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// حالة النجاح - تم تسجيل الدخول بنجاح
class AuthSuccess extends AuthState {
  final UserEntity user;

  const AuthSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

/// حالة الفشل - حدث خطأ ما
class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

/// حالة تسجيل الخروج
class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
}

/// حالة المصادقة - المستخدم مصرح
class Authenticated extends AuthState {
  final UserEntity user;

  const Authenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// حالة عدم المصادقة - المستخدم غير مصرح
class Unauthenticated extends AuthState {
  const Unauthenticated();
}
