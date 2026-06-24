import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';

class PaymentMethodTile extends StatelessWidget {
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;
  final Widget logo;

  const PaymentMethodTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.logo,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFD1D5DB),
            width: selected ? 2.w : 1.w,
          ),
          borderRadius: BorderRadius.circular(12.r),
          color: selected ? AppColors.primary.withAlpha(15) : Colors.white,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20.r,
              height: 20.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.primary : Colors.grey,
                  width: 2.w,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10.r,
                        height: 10.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            const Spacer(),
            logo,
            if (selected) ...[
              SizedBox(width: 8.w),
              Icon(Icons.check_circle, color: AppColors.primary, size: 18.r),
            ],
          ],
        ),
      ),
    );
  }
}
