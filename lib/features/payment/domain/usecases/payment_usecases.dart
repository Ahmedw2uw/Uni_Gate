import 'package:nuigate/features/payment/domain/entities/checkout_result.dart';
import 'package:nuigate/features/payment/domain/entities/payment_entity.dart';
import 'package:nuigate/features/payment/domain/repositories/payment_repository.dart';

class GetMyPaymentsUseCase {
  final PaymentRepository repository;
  GetMyPaymentsUseCase(this.repository);

  Future<List<PaymentEntity>> call() => repository.getMyPayments();
}

class CheckoutUseCase {
  final PaymentRepository repository;
  CheckoutUseCase(this.repository);

  Future<CheckoutResult> call(Map<String, dynamic> data) =>
      repository.checkout(data);
}

class RefundRequestUseCase {
  final PaymentRepository repository;
  RefundRequestUseCase(this.repository);

  Future<bool> call({
    required int paymentId,
    required String reason,
    String? filePath,
  }) =>
      repository.refundRequest(
        paymentId: paymentId,
        reason: reason,
        filePath: filePath,
      );
}

class GetPaymentSuccessUseCase {
  final PaymentRepository repository;
  GetPaymentSuccessUseCase(this.repository);

  Future<Map<String, dynamic>> call(String sessionId) =>
      repository.getPaymentSuccess(sessionId);
}
