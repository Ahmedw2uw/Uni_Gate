import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:nuigate/core/constants/api_endpoints.dart';
import 'package:nuigate/features/payment/data/models/payment_model.dart';
import 'package:nuigate/features/payment/domain/entities/checkout_result.dart';
import 'package:nuigate/network/api_services.dart';

abstract class PaymentRemoteDataSource {
  Future<List<PaymentModel>> getMyPayments();
  Future<CheckoutResult> checkout(Map<String, dynamic> data);
  Future<bool> refundRequest({
    required int paymentId,
    required String reason,
    String? filePath,
  });
  Future<Map<String, dynamic>> getPaymentSuccess(String sessionId);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final ApiServices apiServices;

  PaymentRemoteDataSourceImpl(this.apiServices);

  @override
  Future<List<PaymentModel>> getMyPayments() async {
    final response = await apiServices.get(ApiEndpoints.myPayments);
    if (kDebugMode) {
      debugPrint('💳 my-payments response: ${response.statusCode} | ${response.data}');
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => PaymentModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
      if (data is Map) {
        // Some APIs wrap list in an object
        final items = data['data'] ?? data['payments'] ?? data['items'];
        if (items is List) {
          return items
              .map((e) => PaymentModel.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList();
        }
        // Single payment wrapped in an object
        final dataMap = data as Map<String, dynamic>;
        return [PaymentModel.fromJson(dataMap)];
      }
    }
    return [];
  }

  @override
  Future<CheckoutResult> checkout(Map<String, dynamic> data) async {
    final response = await apiServices.post(
      ApiEndpoints.checkout,
      data: data,
    );
    if (kDebugMode) {
      debugPrint('💳 checkout response: ${response.statusCode} | ${response.data}');
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      final resData = response.data;
      if (resData is Map) {
        return CheckoutResult(
          sessionId: resData['sessionId']?.toString(),
          redirectUrl:
              resData['url']?.toString() ??
              resData['redirectUrl']?.toString() ??
              resData['checkoutUrl']?.toString(),
          success: true,
          message: resData['message']?.toString(),
        );
      }
      if (resData is String && resData.startsWith('http')) {
        return CheckoutResult(redirectUrl: resData, success: true);
      }
      return const CheckoutResult(success: true, message: 'تمت عملية الدفع بنجاح');
    }
    final errMsg = response.data is Map
        ? (response.data['message'] ?? response.data['error'] ?? 'فشل في الدفع').toString()
        : 'فشل في الدفع (${response.statusCode})';
    throw errMsg;
  }

  @override
  Future<bool> refundRequest({
    required int paymentId,
    required String reason,
    String? filePath,
  }) async {
    final formData = FormData.fromMap({
      'PaymentId': paymentId,
      'Reason': reason,
      if (filePath != null)
        'SupportingFile': await MultipartFile.fromFile(filePath),
    });
    final response = await apiServices.post(
      ApiEndpoints.refundRequest,
      data: formData,
      headers: {'Content-Type': 'multipart/form-data'},
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  @override
  Future<Map<String, dynamic>> getPaymentSuccess(String sessionId) async {
    final response = await apiServices.get(
      ApiEndpoints.paymentSuccess(sessionId),
    );
    if (response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }
    return {'status': 'success'};
  }
}
