import 'package:nuigate/features/payment/data/datasources/payment_remote_datasource.dart';
import 'package:nuigate/features/payment/domain/entities/checkout_result.dart';
import 'package:nuigate/features/payment/domain/entities/payment_entity.dart';
import 'package:nuigate/features/payment/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<PaymentEntity>> getMyPayments() =>
      remoteDataSource.getMyPayments();

  @override
  Future<CheckoutResult> checkout(Map<String, dynamic> data) =>
      remoteDataSource.checkout(data);

  @override
  Future<bool> refundRequest({
    required int paymentId,
    required String reason,
    String? filePath,
  }) =>
      remoteDataSource.refundRequest(
        paymentId: paymentId,
        reason: reason,
        filePath: filePath,
      );

  @override
  Future<Map<String, dynamic>> getPaymentSuccess(String sessionId) =>
      remoteDataSource.getPaymentSuccess(sessionId);
}
