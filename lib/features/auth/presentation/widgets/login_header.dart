import 'package:flutter/material.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                ),
              ],
            ),
            child: const ImageIcon(
              AssetImage('assets/p_icon.png'),
              size: 48,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          const CustomText(
            'بوابة الطالب',
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 4),
          const CustomText('تسجيل الدخول', fontSize: 14, color: Colors.black54),
        ],
      ),
    );
  }
}
