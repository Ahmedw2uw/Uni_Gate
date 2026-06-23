import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class RegistrationBottomBar extends StatelessWidget {
  final int selectedCount;
  final int totalCreditHours;
  final bool isLoading;
  final VoidCallback onRegister;

  const RegistrationBottomBar({
    super.key,
    required this.selectedCount,
    required this.totalCreditHours,
    required this.isLoading,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12.r,
            offset: Offset(0, -4.h),
          ),
        ],
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 340;
            final info = _SelectionInfo(
              selectedCount: selectedCount,
              totalCreditHours: totalCreditHours,
            );
            final button = _RegisterButton(
              selectedCount: selectedCount,
              isLoading: isLoading,
              onRegister: onRegister,
            );

            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  info,
                  SizedBox(height: 10.h),
                  button,
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: info),
                SizedBox(width: 12.w),
                button,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SelectionInfo extends StatelessWidget {
  final int selectedCount;
  final int totalCreditHours;

  const _SelectionInfo({
    required this.selectedCount,
    required this.totalCreditHours,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'المقررات المختارة: $selectedCount',
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 2.h),
        CustomText(
          'إجمالي الساعات: $totalCreditHours',
          fontSize: 12,
          color: Colors.black54,
        ),
      ],
    );
  }
}

class _RegisterButton extends StatelessWidget {
  final int selectedCount;
  final bool isLoading;
  final VoidCallback onRegister;

  const _RegisterButton({
    required this.selectedCount,
    required this.isLoading,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          elevation: 2,
        ),
        onPressed: isLoading || selectedCount == 0 ? null : onRegister,
        child: isLoading
            ? SizedBox(
                width: 18.r,
                height: 18.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const CustomText(
                'تسجيل المقررات المختارة',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
