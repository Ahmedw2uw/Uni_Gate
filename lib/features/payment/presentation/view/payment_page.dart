import 'package:flutter/material.dart';
import 'package:nuigate/features/payment/presentation/widgets/payment_empty_state.dart';
import 'package:nuigate/shared/widgets/app_scaffold.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(title: 'الدفع', child: PaymentEmptyState());
  }
}
