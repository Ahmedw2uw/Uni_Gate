import 'package:flutter/material.dart';
import 'package:nuigate/features/payment/presentation/widgets/payment_method_tile.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String?> onChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'اختر طريقة الدفع',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 10),
        PaymentMethodTile(
          value: 'VISA',
          groupValue: selectedMethod,
          onChanged: onChanged,
          logo: _buildVisaLogo(),
        ),
        const SizedBox(height: 8),
        PaymentMethodTile(
          value: 'MasterCard',
          groupValue: selectedMethod,
          onChanged: onChanged,
          logo: _buildMastercardLogo(),
        ),
      ],
    );
  }

  Widget _buildVisaLogo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F71),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'VISA',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 14,
          letterSpacing: 1.5,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildMastercardLogo() {
    return SizedBox(
      width: 40,
      height: 24,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEB001B),
              ),
            ),
          ),
          Positioned(
            left: 16,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF79E1B).withAlpha(200),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
