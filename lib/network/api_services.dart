import 'dart:async';

import 'package:dio/dio.dart';
import 'dart:io' show SocketException;
import 'package:nuigate/utils/pref_helpers.dart';

/// API Configuration
class ApiConfig {
  /// عنوان API الأساسي - تأكد أنه مطابق لما هو في Swagger (مثلاً: https://your-api-domain.com/api)
  static const String baseUrl = "http://uni-gate.runasp.net/api";

  /// المهلة الزمنية للطلبات
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

/// ApiServices - خدمة الاتصال بـ API
/// توفر methods للـ GET, POST, PUT, DELETE مع معالجة الأخطاء
class ApiServices {
  late final Dio _dio;

  ApiServices({Dio? dio}) {
    _dio = dio ?? _initDio();
    // ✅ Add auth interceptor
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  Dio _initDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        contentType: Headers.jsonContentType,
        validateStatus: (status) => true,
      ),
    );
    return dio;
  }

  // ✅ Helper to add token to headers
  Map<String, dynamic> _getHeaders({Map<String, dynamic>? headers}) {
    final token = PrefHelpers.getToken();
    final baseHeaders = {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return {...baseHeaders, ...?headers};
  }

  // ✅ Update all methods
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: _getHeaders(headers: headers)),
      );
      return response;
    } on SocketException {
      throw 'No Internet connection';
    } on DioException catch (e) {
      throw 'API Error: ${e.message}';
    }
  }

  // ✅ Same for post, put, delete...
  //?  post
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: _getHeaders(headers: headers)),
      );
      return response;
    } on SocketException {
      throw 'No Internet connection';
    } on DioException catch (e) {
      throw 'API Error: ${e.message}';
    }
  }

  //put
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: _getHeaders(headers: headers)),
      );
      return response;
    } on SocketException {
      throw 'No Internet connection';
    } on DioException catch (e) {
      throw 'API Error: ${e.message}';
    }
  }

  //delete
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: _getHeaders(headers: headers)),
      );
      return response;
    } on SocketException {
      throw 'No Internet connection';
    } on DioException catch (e) {
      throw 'API Error: ${e.message}';
    }
  }
}

// ✅ AuthInterceptor to handle 401
class AuthInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 401) {
      // Token expired
      print('❌ 401 Unauthorized - Token expired');
      PrefHelpers.clearAuthData();
      // Trigger logout in your app
      // ServiceLocator.authCubit.logout();
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      PrefHelpers.clearAuthData();
      print('❌ Auth error: ${err.message}');
    }
    super.onError(err, handler);
  }
}
