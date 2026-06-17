import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/payment/presentation/widgets/card_formatters.dart';
import 'package:nuigate/features/payment/presentation/widgets/labeled_text_field.dart';

class CardNumberField extends StatelessWidget {
  final TextEditingController controller;

  const CardNumberField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return LabeledTextField(
      label: 'رقم البطاقة',
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.end,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          CardNumberFormatter(),
        ],
        decoration: paymentInputDecoration(
          hint: '0000 0000 0000 0000',
          prefixIcon: const Icon(Icons.credit_card, color: AppColors.accent),
        ),
        validator: (v) {
          if (v == null || v.replaceAll(' ', '').length < 16) {
            return 'أدخل رقم بطاقة صحيح (16 رقم)';
          }
          return null;
        },
      ),
    );
  }
}
