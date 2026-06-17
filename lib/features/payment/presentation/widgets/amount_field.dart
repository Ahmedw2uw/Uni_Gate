import 'package:flutter/material.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/payment/presentation/widgets/labeled_text_field.dart';

class AmountField extends StatelessWidget {
  final String formattedAmount;

  const AmountField({super.key, required this.formattedAmount});

  @override
  Widget build(BuildContext context) {
    return LabeledTextField(
      label: 'المبلغ',
      child: TextFormField(
        initialValue: formattedAmount,
        readOnly: true,
        textAlign: TextAlign.end,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1E293B),
        ),
        decoration: paymentInputDecoration(
          prefixIcon: const Icon(
            Icons.payments_outlined,
            color: AppColors.accent,
          ),
        ),
      ),
    );
  }
}
