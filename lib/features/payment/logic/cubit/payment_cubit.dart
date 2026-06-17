import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/payment/domain/entities/payment_entity.dart';
import 'package:nuigate/features/payment/domain/usecases/payment_usecases.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final GetMyPaymentsUseCase getMyPaymentsUseCase;
  final CheckoutUseCase checkoutUseCase;
  final RefundRequestUseCase refundRequestUseCase;
  final GetPaymentSuccessUseCase getPaymentSuccessUseCase;

  List<PaymentEntity> _cachedPayments = [];
  List<PaymentEntity> get cachedPayments => List.unmodifiable(_cachedPayments);

  PaymentCubit({
    required this.getMyPaymentsUseCase,
    required this.checkoutUseCase,
    required this.refundRequestUseCase,
    required this.getPaymentSuccessUseCase,
  }) : super(const PaymentInitial());

  Future<void> fetchMyPayments() async {
    if (state is PaymentLoading) return;
    emit(const PaymentLoading());
    try {
      final payments = await getMyPaymentsUseCase();
      _cachedPayments = payments;
      emit(PaymentsLoaded(payments: payments));
    } catch (e) {
      if (kDebugMode) debugPrint('PaymentCubit.fetchMyPayments error: $e');
      emit(PaymentFailure(message: e.toString()));
    }
  }

  Future<void> checkout(Map<String, dynamic> data) async {
    emit(const CheckoutLoading());
    try {
      final result = await checkoutUseCase(data);
      if (kDebugMode) {
        debugPrint(
          '💳 CheckoutResult: success=${result.success}, url=${result.redirectUrl}, sessionId=${result.sessionId}',
        );
      }
      if (result.redirectUrl != null) {
        debugPrint('🌐 جاري التحويل لبوابة الدفع: ${result.redirectUrl}');
      }
      emit(CheckoutSuccess(result: result));
    } catch (e) {
      if (kDebugMode) debugPrint('PaymentCubit.checkout error: $e');
      emit(CheckoutFailure(message: e.toString()));
    }
  }

  Future<void> refundRequest({
    required int paymentId,
    required String reason,
    String? filePath,
  }) async {
    emit(const RefundLoading());
    try {
      final success = await refundRequestUseCase(
        paymentId: paymentId,
        reason: reason,
        filePath: filePath,
      );
      if (success) {
        emit(const RefundSuccess());
      } else {
        emit(const RefundFailure(message: 'فشل في إرسال طلب الاسترداد'));
      }
    } catch (e) {
      emit(RefundFailure(message: e.toString()));
    }
  }

  Future<void> confirmPaymentSuccess(String sessionId) async {
    try {
      final data = await getPaymentSuccessUseCase(sessionId);
      if (kDebugMode) debugPrint('💳 Payment success confirmed: $data');
      await fetchMyPayments();
    } catch (e) {
      if (kDebugMode) debugPrint('PaymentCubit.confirmPaymentSuccess error: $e');
    }
  }
}
