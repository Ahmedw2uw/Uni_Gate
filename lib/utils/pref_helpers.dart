import 'package:shared_preferences/shared_preferences.dart';

/// PrefHelpers - مساعد للتعامل مع SharedPreferences
/// يوفر واجهة نظيفة وسهلة الاستخدام للتخزين المحلي
class PrefHelpers {
  static late SharedPreferences _prefs;

  /// تهيئة PrefHelpers
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ===== Keys =====
  static const String _tokenKey = 'auth_token';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userRoleKey = 'user_role';
  static const String _userIdKey = 'user_id';
  static const String _profileImageKey = 'profile_image';
  static const String _onboardingCompletedKey = 'onboarding_completed';

  // ===== Token Management =====

  /// حفظ التوكن
  static Future<bool> saveToken(String token) async {
    return await _prefs.setString(_tokenKey, token);
  }

  /// الحصول على التوكن
  static String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  /// حذف التوكن
  static Future<bool> removeToken() async {
    return await _prefs.remove(_tokenKey);
  }

  /// التحقق من وجود التوكن
  static bool hasToken() {
    return _prefs.containsKey(_tokenKey);
  }

  // ===== User Data Management =====

  /// حفظ اسم المستخدم
  static Future<bool> saveUserName(String name) async {
    return await _prefs.setString(_userNameKey, name);
  }

  /// الحصول على اسم المستخدم
  static String? getUserName() {
    return _prefs.getString(_userNameKey);
  }

  /// حفظ بريد المستخدم
  static Future<bool> saveEmail(String email) async {
    return await _prefs.setString(_userEmailKey, email);
  }

  /// الحصول على بريد المستخدم
  static String? getEmail() {
    return _prefs.getString(_userEmailKey);
  }

  /// حفظ دور المستخدم
  static Future<bool> saveUserRole(String role) async {
    return await _prefs.setString(_userRoleKey, role);
  }

  /// الحصول على دور المستخدم
  static String? getUserRole() {
    return _prefs.getString(_userRoleKey);
  }

  /// حفظ معرف المستخدم
  static Future<bool> saveUserId(String id) async {
    return await _prefs.setString(_userIdKey, id);
  }

  /// الحصول على معرف المستخدم
  static String? getUserId() {
    return _prefs.getString(_userIdKey);
  }

  /// حفظ صورة الملف الشخصي
  static Future<bool> saveProfileImage(String imageUrl) async {
    return await _prefs.setString(_profileImageKey, imageUrl);
  }

  /// الحصول على صورة الملف الشخصي
  static String? getProfileImage() {
    return _prefs.getString(_profileImageKey);
  }

  // ===== General Utilities =====

  /// حفظ أي مفتاح-قيمة (String)
  static Future<bool> saveString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  /// الحصول على قيمة String
  static String? getString(String key) {
    return _prefs.getString(key);
  }

  /// حفظ قيمة Boolean
  static Future<bool> saveBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  /// الحصول على قيمة Boolean
  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  /// حفظ قيمة Integer
  static Future<bool> saveInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  /// الحصول على قيمة Integer
  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  /// حفظ قيمة Double
  static Future<bool> saveDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  /// الحصول على قيمة Double
  static double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  /// حذف مفتاح معين
  static Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  /// حذف جميع البيانات
  static Future<bool> clear() async {
    return await _prefs.clear();
  }

  /// الحصول على جميع المفاتيح
  static Set<String> getKeys() {
    return _prefs.getKeys();
  }

  // ===== Logout/Clear User Data =====

  /// حذف جميع بيانات المستخدم والتوكن
  static Future<bool> clearAuthData() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_userNameKey);
    await _prefs.remove(_userEmailKey);
    await _prefs.remove(_userRoleKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_profileImageKey);
    return true;
  }

  /// التحقق من تسجيل دخول المستخدم
  static bool isLoggedIn() {
    return hasToken();
  }

  /// حفظ حالة إكمال onboarding
  static Future<bool> saveOnboardingCompleted(bool completed) async {
    return await _prefs.setBool(_onboardingCompletedKey, completed);
  }

  /// التحقق من أن المستخدم أنهى onboarding
  static bool isOnboardingCompleted() {
    return _prefs.getBool(_onboardingCompletedKey) ?? false;
  }
}
