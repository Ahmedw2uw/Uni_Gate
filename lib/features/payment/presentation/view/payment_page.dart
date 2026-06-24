import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/core/service_locator.dart';
import 'package:nuigate/features/auth/data/models/user_model.dart';
import 'package:nuigate/features/auth/domain/entities/user_entity.dart';
import 'package:nuigate/features/auth/logic/cubit/auth_cubit.dart';
import 'package:nuigate/features/auth/logic/cubit/auth_state.dart';
import 'package:nuigate/features/payment/domain/entities/payment_entity.dart';
import 'package:nuigate/features/payment/logic/cubit/payment_cubit.dart';
import 'package:nuigate/features/payment/logic/cubit/payment_state.dart';
import 'package:nuigate/features/payment/presentation/widgets/payment_form.dart';
import 'package:nuigate/features/payment/presentation/widgets/payment_success_dialog.dart';
import 'package:nuigate/features/payment/presentation/widgets/student_info_card.dart';
import 'package:nuigate/shared/widgets/app_scaffold.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: ServiceLocator.paymentCubit..fetchMyPayments(),
      child: const _PaymentView(),
    );
  }
}

class _PaymentView extends StatefulWidget {
  const _PaymentView();

  @override
  State<_PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<_PaymentView> {
  final _formKey = GlobalKey<FormState>();
  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  String _selectedMethod = 'VISA';

  @override
  void dispose() {
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  String _academicYearLabel(int? year) {
    switch (year) {
      case 1:
        return 'الأولى';
      case 2:
        return 'الثانية';
      case 3:
        return 'الثالثة';
      case 4:
        return 'الرابعة';
      default:
        return 'غير محدد';
    }
  }

  bool _isPaid(String? status) {
    if (status == null) return false;
    final value = status.toLowerCase();
    return value == 'paid' ||
        value == 'مدفوعة' ||
        value == 'completed' ||
        value == 'success';
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'دفع المصاريف',
      child: BlocConsumer<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is CheckoutSuccess) {
            if (state.result.redirectUrl != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('جاري التحويل لبوابة الدفع'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
            showPaymentSuccessDialog(context);
          } else if (state is CheckoutFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          final authState = context.read<AuthCubit>().state;
          UserEntity? userEntity;
          if (authState is Authenticated) userEntity = authState.user;
          if (authState is AuthSuccess) userEntity = authState.user;
          final user = userEntity is UserModel ? userEntity : null;

          double totalAmount = 15000;
          bool isPaid = false;
          List<PaymentEntity> payments = [];

          if (state is PaymentsLoaded) {
            payments = state.payments;
            if (payments.isNotEmpty) {
              totalAmount = payments.first.amount ?? 15000;
              isPaid = _isPaid(payments.first.status);
            }
          }

          final studentCard = StudentInfoCard(
            user: user,
            totalAmount: totalAmount,
            isPaid: isPaid,
            academicYearLabel: _academicYearLabel(user?.academicYear),
          );

          final paymentForm = PaymentForm(
            formKey: _formKey,
            cardController: _cardController,
            expiryController: _expiryController,
            cvvController: _cvvController,
            selectedMethod: _selectedMethod,
            onMethodChanged: (val) {
              if (val != null) setState(() => _selectedMethod = val);
            },
            amount: totalAmount,
            isLoading: state is CheckoutLoading,
            onSubmit: () {
              if (_formKey.currentState!.validate()) {
                context.read<PaymentCubit>().checkout({
                  'amount': totalAmount,
                  'paymentMethod': _selectedMethod,
                });
              }
            },
          );

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.r),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 35, child: studentCard),
                          SizedBox(width: 16.w),
                          Expanded(flex: 65, child: paymentForm),
                        ],
                      )
                    : Column(
                        children: [
                          studentCard,
                          SizedBox(height: 16.h),
                          paymentForm,
                        ],
                      ),
              );
            },
          );
        },
      ),
    );
  }
}
