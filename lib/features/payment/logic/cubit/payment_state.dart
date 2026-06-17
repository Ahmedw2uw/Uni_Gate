import 'package:equatable/equatable.dart';
import 'package:nuigate/features/payment/domain/entities/checkout_result.dart';
import 'package:nuigate/features/payment/domain/entities/payment_entity.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

class PaymentLoading extends PaymentState {
  const PaymentLoading();
}

class PaymentsLoaded extends PaymentState {
  final List<PaymentEntity> payments;

  const PaymentsLoaded({required this.payments});

  @override
  List<Object?> get props => [payments];
}

class PaymentFailure extends PaymentState {
  final String message;

  const PaymentFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class CheckoutLoading extends PaymentState {
  const CheckoutLoading();
}

class CheckoutSuccess extends PaymentState {
  final CheckoutResult result;

  const CheckoutSuccess({required this.result});

  @override
  List<Object?> get props => [result];
}

class CheckoutFailure extends PaymentState {
  final String message;

  const CheckoutFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class RefundLoading extends PaymentState {
  const RefundLoading();
}

class RefundSuccess extends PaymentState {
  const RefundSuccess();
}

class RefundFailure extends PaymentState {
  final String message;

  const RefundFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
