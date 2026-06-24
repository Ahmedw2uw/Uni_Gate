import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/auth/domain/entities/user_entity.dart';
import 'package:nuigate/features/auth/domain/usecases/auth_usecases.dart';
import 'package:nuigate/utils/jwt_helper.dart';
import 'package:nuigate/utils/pref_helpers.dart';
import 'auth_state.dart';

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

  Future<void> checkAuthStatus() async {
    try {
      emit(const AuthLoading());
      final isLoggedIn = await checkAuthStatusUseCase();
      final token = PrefHelpers.getToken();

      if (!isLoggedIn || token == null || !JwtHelper.isTokenValid(token)) {
        await PrefHelpers.clearAuthData();
        emit(const Unauthenticated());
        return;
      }

      final role = PrefHelpers.getUserRole() ?? JwtHelper.extractRole(token);
      if (_isDoctorRole(role)) {
        await _persistJwtUserData(token, role);
        emit(Authenticated(user: _userFromToken(token, role)));
        return;
      }

      final user = await getCurrentUserUseCase();
      emit(
        Authenticated(
          user: user.copyWith(token: token, role: role),
        ),
      );
    } catch (e) {
      debugPrint('AuthCubit checkAuthStatus error: $e');
      emit(const Unauthenticated());
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required String nationalId,
  }) async {
    emit(const AuthLoading());

    try {
      final userFromLogin = await loginUseCase(
        email: email,
        password: password,
        nationalId: nationalId,
      );

      final token = userFromLogin.token;
      if (token == null || token.isEmpty) {
        throw Exception('Token missing in login response');
      }

      final role = JwtHelper.extractRole(token) ?? 'Student';
      await PrefHelpers.saveToken(token);
      await _persistJwtUserData(token, role);

      if (_isDoctorRole(role)) {
        emit(Authenticated(user: _userFromToken(token, role)));
        debugPrint(
          'Authenticated as instructor from JWT without student profile request',
        );
        return;
      }

      final fullUser = await getCurrentUserUseCase();
      await PrefHelpers.saveUserName(fullUser.name);
      await PrefHelpers.saveUserRole(role);

      emit(
        Authenticated(
          user: fullUser.copyWith(token: token, role: role),
        ),
      );

      debugPrint('Authenticated student with DeptID: ${fullUser.departmentId}');
    } catch (e) {
      debugPrint('AuthCubit Login Error: $e');
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> logout() async {
    emit(const AuthLoading());

    try {
      await logoutUseCase();
      await PrefHelpers.clearAuthData();
      await PrefHelpers.saveOnboardingCompleted(false);
      emit(const AuthLoggedOut());
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

  bool isDoctor(AuthState state) {
    if (state is! Authenticated) return false;
    return _isDoctorRole(state.user.role);
  }

  bool _isDoctorRole(String? role) {
    final value = role?.toLowerCase() ?? '';
    return value.contains('doctor') || value.contains('instructor');
  }

  Future<void> _persistJwtUserData(String token, String? role) async {
    final email = _jwtEmail(token) ?? '';
    final name = _jwtName(token) ?? email;
    final id = _jwtUserId(token) ?? '';

    if (email.isNotEmpty) await PrefHelpers.saveEmail(email);
    if (name.isNotEmpty) await PrefHelpers.saveUserName(name);
    if (id.isNotEmpty) await PrefHelpers.saveUserId(id);
    if (role != null && role.isNotEmpty) await PrefHelpers.saveUserRole(role);
  }

  UserEntity _userFromToken(String token, String? role) {
    final email = _jwtEmail(token) ?? PrefHelpers.getEmail() ?? '';
    final name = PrefHelpers.getUserName() ?? _jwtName(token) ?? email;
    final id = _jwtUserId(token) ?? PrefHelpers.getUserId() ?? '';

    return UserEntity(
      id: id,
      name: name,
      email: email,
      token: token,
      role: role,
    );
  }

  String? _jwtEmail(String token) {
    return JwtHelper.getClaim(
          token,
          'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress',
        )?.toString() ??
        JwtHelper.getEmail(token);
  }

  String? _jwtName(String token) {
    return JwtHelper.getClaim(
          token,
          'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name',
        )?.toString() ??
        JwtHelper.getUsername(token);
  }

  String? _jwtUserId(String token) {
    return JwtHelper.getClaim(
      token,
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier',
    )?.toString();
  }
}
