import 'package:flutter/foundation.dart';
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
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: false,
          requestHeader: false,
          requestBody: false,
          responseHeader: false,
          responseBody: false,
          error: true,
        ),
      );
    }
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

    if (kDebugMode) {
      debugPrint(
        'DEBUG ApiServices._getHeaders -> token=${token != null ? 'present (len=${token.length})' : 'missing'} '
        'additionalHeaders=${headers ?? {}}',
      );
    }

    return {...baseHeaders, ...?headers};
  }

  // ✅ Update all methods
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final requestHeaders = _getHeaders(headers: headers);
      if (kDebugMode) {
        final sanitizedHeaders = Map<String, dynamic>.from(requestHeaders);
        if (sanitizedHeaders['Authorization'] != null) {
          sanitizedHeaders['Authorization'] = 'Bearer <hidden>';
        }
        debugPrint(
          'DEBUG ApiServices.GET -> path=$path query=$queryParameters headers=$sanitizedHeaders',
        );
      }

      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: requestHeaders),
      );

      if (kDebugMode) {
        debugPrint(
          'DEBUG ApiServices.GET response -> path=$path status=${response.statusCode} dataType=${response.data.runtimeType}',
        );
      }

      return response;
    } on SocketException {
      throw 'No Internet connection';
    } on DioException catch (e) {
      // ⬇️ التعديل هنا: لو السيرفر باعت رد (حتى لو خطأ 400 أو 500)، مرر الإكسبشن للكيوبيت عشان يقرأ التفاصيل
      if (e.response != null) {
        rethrow;
      }
      // لو الخطأ من الموبايل نفسه (مثلا TimeOut)، ارمي النص العادي
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
      final requestHeaders = _getHeaders(headers: headers);
      if (kDebugMode) {
        final sanitizedHeaders = Map<String, dynamic>.from(requestHeaders);
        if (sanitizedHeaders['Authorization'] != null) {
          sanitizedHeaders['Authorization'] = 'Bearer <hidden>';
        }
        debugPrint(
          'DEBUG ApiServices.POST -> path=$path query=$queryParameters headers=$sanitizedHeaders data=$data',
        );
      }

      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: requestHeaders),
      );

      if (kDebugMode) {
        debugPrint(
          'DEBUG ApiServices.POST response -> path=$path status=${response.statusCode} data=${response.data}',
        );
      }
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
      final requestHeaders = _getHeaders(headers: headers);
      if (kDebugMode) {
        final sanitizedHeaders = Map<String, dynamic>.from(requestHeaders);
        if (sanitizedHeaders['Authorization'] != null) {
          sanitizedHeaders['Authorization'] = 'Bearer <hidden>';
        }
        debugPrint(
          'DEBUG ApiServices.PUT -> path=$path query=$queryParameters headers=$sanitizedHeaders data=$data',
        );
      }

      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: requestHeaders),
      );

      if (kDebugMode) {
        debugPrint(
          'DEBUG ApiServices.PUT response -> path=$path status=${response.statusCode} data=${response.data}',
        );
      }
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
      final requestHeaders = _getHeaders(headers: headers);
      if (kDebugMode) {
        final sanitizedHeaders = Map<String, dynamic>.from(requestHeaders);
        if (sanitizedHeaders['Authorization'] != null) {
          sanitizedHeaders['Authorization'] = 'Bearer <hidden>';
        }
        debugPrint(
          'DEBUG ApiServices.DELETE -> path=$path query=$queryParameters headers=$sanitizedHeaders data=$data',
        );
      }

      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: requestHeaders),
      );

      if (kDebugMode) {
        debugPrint(
          'DEBUG ApiServices.DELETE response -> path=$path status=${response.statusCode} data=${response.data}',
        );
      }
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
      debugPrint('❌ 401 Unauthorized - Token expired');
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
      debugPrint('❌ Auth error: ${err.message}');
    }
    super.onError(err, handler);
  }
}
