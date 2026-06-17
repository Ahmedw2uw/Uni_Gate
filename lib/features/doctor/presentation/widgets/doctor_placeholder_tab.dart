import 'package:flutter/material.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class DoctorPlaceholderTab extends StatelessWidget {
  final String title;
  final IconData icon;

  const DoctorPlaceholderTab({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 54, color: AppColors.primary),
            const SizedBox(height: 14),
            CustomText(
              title,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const CustomText(
              'سيتم بناء هذه الشاشة في المرحلة التالية حسب الصورة التفصيلية الخاصة بها.',
              color: Colors.black54,
              fontSize: 14,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
