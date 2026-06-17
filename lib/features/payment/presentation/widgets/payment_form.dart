import 'package:flutter/material.dart';
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

  String _formatAmount(double a) {
    if (a == a.truncateToDouble()) {
      return a.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );
    }
    return a.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
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
              const SizedBox(height: 24),


              PaymentMethodSelector(
                selectedMethod: selectedMethod,
                onChanged: onMethodChanged,
              ),
              const SizedBox(height: 16),

              AmountField(formattedAmount: _formatAmount(amount)),
              const SizedBox(height: 16),

              CardNumberField(controller: cardController),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: CardExpiryField(controller: expiryController),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CardCvvField(controller: cvvController),
                  ),
                ],
              ),
              const SizedBox(height: 28),

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
        borderRadius: BorderRadius.circular(14),
        boxShadow: isLoading
            ? []
            : [
                BoxShadow(
                  color: AppColors.primary.withAlpha(60),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: SizedBox(
        height: 56,
        child: ElevatedButton(
          onPressed: isLoading ? null : onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'جاري المعالجة...',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'إتمام الدفع',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
