import 'package:flutter/material.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class OnboardingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String assetPath;

  const OnboardingCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        _buildIllustration(assetPath),
        const SizedBox(height: 28),
        CustomText(
          title,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 14),
        CustomText(
          subtitle,
          fontSize: 16,
          color: Colors.black87,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w400,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildIllustration(String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AspectRatio(
        aspectRatio: 1.05,
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          semanticLabel: 'Onboarding illustration',
        ),
      ),
    );
  }
}
