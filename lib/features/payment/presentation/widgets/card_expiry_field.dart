import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/payment/presentation/widgets/card_formatters.dart';
import 'package:nuigate/features/payment/presentation/widgets/labeled_text_field.dart';

class CardExpiryField extends StatelessWidget {
  final TextEditingController controller;

  const CardExpiryField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return LabeledTextField(
      label: 'تاريخ الانتهاء',
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.end,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          ExpiryDateFormatter(),
        ],
        decoration: paymentInputDecoration(
          hint: 'MM/YY',
          prefixIcon: const Icon(Icons.calendar_month, color: AppColors.accent),
        ),
        validator: (v) {
          if (v == null || v.length < 5) {
            return 'تاريخ غير صحيح';
          }
          return null;
        },
      ),
    );
  }
}
