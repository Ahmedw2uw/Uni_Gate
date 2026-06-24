import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentStatusBadge extends StatelessWidget {
  final bool isPaid;

  const PaymentStatusBadge({super.key, required this.isPaid});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isPaid ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        isPaid ? 'مدفوعة' : 'غير مدفوعة',
        style: TextStyle(
          color: isPaid ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
