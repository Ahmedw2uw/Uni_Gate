import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import '../../../../shared/widgets/custom_text.dart';

class ProfileInfoSection extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onTap;
  final List<Map<String, String>> details;

  const ProfileInfoSection({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.onTap,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomText(title, fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: details.map((item) => _buildRow(item['label']!, item['value']!)).toList(),
            ),
          ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(flex: 3, child: CustomText(label, fontSize: 14, color: Colors.black54)),
          Expanded(flex: 4, child: CustomText(value, fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}