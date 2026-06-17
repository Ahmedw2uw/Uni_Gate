import 'package:nuigate/features/payment/domain/entities/checkout_result.dart';
import 'package:nuigate/features/payment/domain/entities/payment_entity.dart';

abstract class PaymentRepository {
  Future<List<PaymentEntity>> getMyPayments();

  Future<CheckoutResult> checkout(Map<String, dynamic> data);

  Future<bool> refundRequest({
    required int paymentId,
    required String reason,
    String? filePath,
  });

  Future<Map<String, dynamic>> getPaymentSuccess(String sessionId);
}
