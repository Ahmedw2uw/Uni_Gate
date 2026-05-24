import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:nuigate/features/auth/data/models/user_model.dart';

/// AuthLocalDataSource - مصدر البيانات المحلي
/// مسؤول عن حفظ واسترجاع البيانات من الجهاز
abstract class AuthLocalDataSource {
  /// حفظ بيانات المستخدم محلياً
  Future<void> saveUser(UserModel user);

  /// حفظ التوكن
  Future<void> saveToken(String token);

  /// الحصول على بيانات المستخدم المحفوظة
  Future<UserModel?> getUser();

  /// الحصول على التوكن المحفوظ
  Future<String?> getToken();

  /// حذف بيانات المستخدم والتوكن
  Future<void> clearUser();

  /// التحقق من وجود توكن محفوظ
  Future<bool> hasToken();
}

/// تنفيذ AuthLocalDataSource باستخدام SharedPreferences
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';

  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await sharedPreferences.setString(_userKey, userJson);
  }

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(_tokenKey, token);
  }

  @override
  Future<UserModel?> getUser() async {
    final userJson = sharedPreferences.getString(_userKey);
    if (userJson == null) return null;

    try {
      final userData = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(_tokenKey);
  }

  @override
  Future<void> clearUser() async {
    await sharedPreferences.remove(_userKey);
    await sharedPreferences.remove(_tokenKey);
  }

  @override
  Future<bool> hasToken() async {
    return sharedPreferences.containsKey(_tokenKey);
  }
}
