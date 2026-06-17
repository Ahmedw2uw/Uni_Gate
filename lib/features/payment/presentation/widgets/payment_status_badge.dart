import 'package:flutter/material.dart';

class PaymentStatusBadge extends StatelessWidget {
  final bool isPaid;

  const PaymentStatusBadge({super.key, required this.isPaid});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isPaid
            ? const Color(0xFFDCFCE7)
            : const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isPaid ? 'مدفوعة' : 'غير مدفوعة',
        style: TextStyle(
          color: isPaid ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
