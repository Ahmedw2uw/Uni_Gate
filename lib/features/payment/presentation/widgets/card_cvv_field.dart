import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/payment/presentation/widgets/labeled_text_field.dart';

class CardCvvField extends StatelessWidget {
  final TextEditingController controller;

  const CardCvvField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return LabeledTextField(
      label: 'رمز التحقق',
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.end,
        keyboardType: TextInputType.number,
        obscureText: true,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(3),
        ],
        decoration: paymentInputDecoration(
          hint: '123',
          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.accent),
        ),
        validator: (v) {
          if (v == null || v.length < 3) {
            return 'CVV غير صحيح';
          }
          return null;
        },
      ),
    );
  }
}
