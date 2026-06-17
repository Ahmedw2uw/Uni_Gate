import 'package:nuigate/features/payment/domain/entities/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    super.id,
    super.studentId,
    super.studentName,
    super.studentCode,
    super.amount,
    super.status,
    super.paymentDate,
    super.description,
    super.sessionId,
  });

  static double? _tryParseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static int? _tryParseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: _tryParseInt(json['id']),
      studentId: _tryParseInt(json['studentId']),
      studentName:
          json['studentName']?.toString() ??
          json['student']?['fullName']?.toString(),
      studentCode:
          json['studentCode']?.toString() ??
          json['student']?['studentCode']?.toString(),
      amount:
          _tryParseDouble(json['amount']) ??
          _tryParseDouble(json['totalAmount']) ??
          _tryParseDouble(json['fees']),
      status: json['status']?.toString() ?? json['paymentStatus']?.toString(),
      paymentDate:
          json['paymentDate']?.toString() ?? json['createdAt']?.toString(),
      description: json['description']?.toString() ?? json['notes']?.toString(),
      sessionId: json['sessionId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'studentCode': studentCode,
      'amount': amount,
      'status': status,
      'paymentDate': paymentDate,
      'description': description,
      'sessionId': sessionId,
    };
  }
}
