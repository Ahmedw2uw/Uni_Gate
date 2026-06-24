import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/payment/presentation/widgets/amount_field.dart';
import 'package:nuigate/features/payment/presentation/widgets/card_cvv_field.dart';
import 'package:nuigate/features/payment/presentation/widgets/card_expiry_field.dart';
import 'package:nuigate/features/payment/presentation/widgets/card_number_field.dart';
import 'package:nuigate/features/payment/presentation/widgets/payment_method_selector.dart';

class PaymentForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController cardController;
  final TextEditingController expiryController;
  final TextEditingController cvvController;
  final String selectedMethod;
  final ValueChanged<String?> onMethodChanged;
  final double amount;
  final bool isLoading;
  final VoidCallback onSubmit;

  const PaymentForm({
    super.key,
    required this.formKey,
    required this.cardController,
    required this.expiryController,
    required this.cvvController,
    required this.selectedMethod,
    required this.onMethodChanged,
    required this.amount,
    required this.isLoading,
    required this.onSubmit,
  });

  String _formatAmount(double amount) {
    if (amount == amount.truncateToDouble()) {
      return amount.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]},',
      );
    }
    return amount.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'بيانات الدفع',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              PaymentMethodSelector(
                selectedMethod: selectedMethod,
                onChanged: onMethodChanged,
              ),
              SizedBox(height: 16.h),
              AmountField(formattedAmount: _formatAmount(amount)),
              SizedBox(height: 16.h),
              CardNumberField(controller: cardController),
              SizedBox(height: 16.h),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 300) {
                    return Column(
                      children: [
                        CardExpiryField(controller: expiryController),
                        SizedBox(height: 16.h),
                        CardCvvField(controller: cvvController),
                      ],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(
                        child: CardExpiryField(controller: expiryController),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(child: CardCvvField(controller: cvvController)),
                    ],
                  );
                },
              ),
              SizedBox(height: 28.h),
              _SubmitButton(isLoading: isLoading, onSubmit: onSubmit),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSubmit;

  const _SubmitButton({required this.isLoading, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: isLoading
            ? []
            : [
                BoxShadow(
                  color: AppColors.primary.withAlpha(60),
                  blurRadius: 12.r,
                  offset: Offset(0, 4.h),
                ),
              ],
      ),
      child: SizedBox(
        height: 56.h,
        child: ElevatedButton(
          onPressed: isLoading ? null : onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
            elevation: 0,
          ),
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20.r,
                      height: 20.r,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'جاري المعالجة...',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: Colors.white),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, color: Colors.white, size: 18.r),
                    SizedBox(width: 8.w),
                    Text(
                      'إتمام الدفع',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
