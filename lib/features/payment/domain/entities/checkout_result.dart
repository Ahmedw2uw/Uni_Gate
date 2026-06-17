import 'package:equatable/equatable.dart';

class CheckoutResult extends Equatable {
  final String? sessionId;
  final String? redirectUrl;
  final bool success;
  final String? message;

  const CheckoutResult({
    this.sessionId,
    this.redirectUrl,
    this.success = false,
    this.message,
  });

  @override
  List<Object?> get props => [sessionId, redirectUrl, success, message];
}
