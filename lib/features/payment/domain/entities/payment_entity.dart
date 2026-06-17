import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final int? id;
  final int? studentId;
  final String? studentName;
  final String? studentCode;
  final double? amount;
  final String? status;
  final String? paymentDate;
  final String? description;
  final String? sessionId;

  const PaymentEntity({
    this.id,
    this.studentId,
    this.studentName,
    this.studentCode,
    this.amount,
    this.status,
    this.paymentDate,
    this.description,
    this.sessionId,
  });

  @override
  List<Object?> get props => [
    id,
    studentId,
    studentName,
    studentCode,
    amount,
    status,
    paymentDate,
    description,
    sessionId,
  ];
}
