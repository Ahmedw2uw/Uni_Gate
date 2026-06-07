import 'package:flutter/material.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/auth/presentation/widgets/login_header.dart';
import 'package:nuigate/shared/widgets/app_text_field.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';
import 'package:nuigate/shared/widgets/primary_button.dart';

class LoginFormCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nationalIdController;
  final bool obscurePassword;
  final bool isLoading;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;

  const LoginFormCard({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.nationalIdController,
    required this.obscurePassword,
    required this.isLoading,
    required this.onTogglePassword,
    required this.onSubmit,
    required this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width > 600 ? 420 : width),
      child: Card(
        color: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LoginHeader(),
              const SizedBox(height: 20),
              AppTextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: !isLoading,
                prefixIcon: const Icon(Icons.email_outlined),
                hintText: 'example@email.com',
                labelText: 'البريد الإلكتروني',
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: nationalIdController,
                keyboardType: TextInputType.number,
                enabled: !isLoading,
                prefixIcon: const Icon(Icons.badge_outlined),
                labelText: 'الرقم القومي',
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: passwordController,
                obscureText: obscurePassword,
                enabled: !isLoading,
                prefixIcon: const Icon(Icons.lock_outline),
                labelText: 'كلمة المرور',
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: isLoading ? null : onTogglePassword,
                ),
              ),
              const SizedBox(height: 18),
              PrimaryButton(
                onPressed: onSubmit,
                isLoading: isLoading,
                child: const CustomText(
                  'تسجيل الدخول',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: isLoading ? null : onForgotPassword,
                  child: const CustomText(
                    'هل نسيت كلمة المرور؟',
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
