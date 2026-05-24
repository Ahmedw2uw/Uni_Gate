import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/auth/domain/entities/user_entity.dart';
import 'package:nuigate/features/auth/domain/usecases/auth_usecases.dart';
import 'package:nuigate/utils/jwt_helper.dart';
import 'package:nuigate/utils/pref_helpers.dart';
import 'auth_state.dart';

/// AuthCubit - مسؤول عن منطق المصادقة
/// يتعامل مع تسجيل الدخول والخروج وفحص حالة المصادقة
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LogoutUseCase logoutUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.getCurrentUserUseCase,
    required this.logoutUseCase,
    required this.checkAuthStatusUseCase,
  }) : super(const AuthInitial());

  /// التحقق من حالة المصادقة عند بدء التطبيق
Future<void> checkAuthStatus() async {
    try {
      emit(const AuthLoading());
      final isLoggedIn = await checkAuthStatusUseCase();

      if (isLoggedIn) {
        // بدلاً من القراءة من Prefs، ننادي الـ UseCase الذي يجلب البيانات الكاملة (1654)
        final user = await getCurrentUserUseCase();
        emit(Authenticated(user: user));
      } else {
        emit(const Unauthenticated());
      }
    } catch (e) {
      // لو فشل الـ API (أوفلاين) نستخدم البيانات القديمة كخطة بديلة
      final email = PrefHelpers.getEmail();
      if (email != null) {
         // (اختياري) يمكنك بناء UserEntity من الـ Prefs هنا إذا أردت دعم الأوفلاين التام
      }
      emit(const Unauthenticated());
    }
  }
/// محاولة تسجيل الدخول - النسخة المحدثة (حل جذري)
Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    try {
      // الخطوة أ: تسجيل الدخول لجلب الـ Token
      final userFromLogin = await loginUseCase(email: email, password: password);

      // الخطوة ب: حفظ التوكن فوراً لتمكين الطلبات التالية
      await PrefHelpers.saveToken(userFromLogin.token.toString());

      // الخطوة ج: جلب البروفايل الكامل (الآن سيحتوي على departmentId: 1654)
      final fullUser = await getCurrentUserUseCase();

      // الخطوة د: استخراج الصلاحيات وحفظ البيانات الكاملة
      final role = JwtHelper.extractRole(userFromLogin.token.toString()) ?? 'Student';
      await PrefHelpers.saveUserName(fullUser.name);
      await PrefHelpers.saveUserRole(role);

      // الخطوة هـ: إرسال الحالة "المكتملة" للـ UI
      emit(
        Authenticated(
          user: fullUser.copyWith(
            token: userFromLogin.token,
            role: role,
          ),
        ),
      );
      
      print("✅ Authenticated with DeptID: ${fullUser.departmentId}");
      
    } catch (e) {
      print("❌ AuthCubit Login Error: $e");
      emit(AuthFailure(message: e.toString()));
    }
  }
  /// تسجيل الخروج
  Future<void> logout() async {
    emit(const AuthLoading());

    try {
      await logoutUseCase();
      // حذف جميع البيانات المحفوظة
      await PrefHelpers.clearAuthData();
      emit(const AuthLoggedOut());
      emit(const Unauthenticated());
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }
  bool isAdmin(AuthState state) {
  if (state is Authenticated) {
    return state.user.role?.toLowerCase() == 'admin';
  }
  return false;
}
}
