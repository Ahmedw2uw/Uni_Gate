import 'dart:convert';

/// JWT Helper - يساعد في فك التشفير واستخراج البيانات من JWT token
class JwtHelper {
  /// استخراج Payload من JWT Token
  /// JWT مكون من 3 أجزاء: header.payload.signature
  static Map<String, dynamic> decodeToken(String token) {
    try {
      // إزالة البادئة "Bearer " إن وجدت
      final cleanToken = token.replaceFirst('Bearer ', '');

      // تقسيم الـ token إلى أجزاء
      final parts = cleanToken.split('.');

      if (parts.length != 3) {
        throw Exception('Invalid token format');
      }

      // فك تشفير الـ payload (الجزء الثاني)
      final payload = parts[1];

      // إضافة padding إذا لزم الحال
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));

      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to decode token: $e');
    }
  }

  /// استخراج الـ Role من JWT token
  /// Role يكون في الـ claim: "http://schemas.microsoft.com/ws/2008/06/identity/claims/role"
  static String? extractRole(String token) {
    try {
      final payload = decodeToken(token);

      // البحث عن الـ role claim
      const roleClaim =
          "http://schemas.microsoft.com/ws/2008/06/identity/claims/role";

      if (payload.containsKey(roleClaim)) {
        return payload[roleClaim] as String?;
      }

      // محاولة بديلة بحثاً عن "role" مباشرة
      return payload['role'] as String?;
    } catch (e) {
      return null;
    }
  }

  /// استخراج أي claim من JWT token
  static dynamic getClaim(String token, String claimName) {
    try {
      final payload = decodeToken(token);
      return payload[claimName];
    } catch (e) {
      return null;
    }
  }

  /// التحقق من صحة الـ token
  static bool isTokenValid(String token) {
    try {
      final payload = decodeToken(token);

      // التحقق من وجود exp claim (expiration)
      if (payload.containsKey('exp')) {
        final exp = payload['exp'] as int;
        final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

        // إذا كان الـ token منتهي الصلاحية
        if (currentTime >= exp) {
          return false;
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// الحصول على اسم المستخدم من الـ token
  static String? getUsername(String token) {
    try {
      final payload = decodeToken(token);

      // البحث عن username أو name
      return payload['name'] as String? ??
          payload['username'] as String? ??
          payload['email'] as String?;
    } catch (e) {
      return null;
    }
  }

  /// الحصول على البريد الإلكتروني من الـ token
  static String? getEmail(String token) {
    try {
      final payload = decodeToken(token);
      return payload['email'] as String?;
    } catch (e) {
      return null;
    }
  }
}
