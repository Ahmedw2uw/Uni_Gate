import 'package:flutter/material.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/profile/presentation/widgets/info_section.dart';

class ProfileSectionsCard extends StatelessWidget {
  final bool personalExpanded;
  final bool academicExpanded;
  final VoidCallback onTogglePersonal;
  final VoidCallback onToggleAcademic;
  final List<Map<String, String>> personalDetails;
  final List<Map<String, String>> academicDetails;

  const ProfileSectionsCard({
    super.key,
    required this.personalExpanded,
    required this.academicExpanded,
    required this.onTogglePersonal,
    required this.onToggleAcademic,
    required this.personalDetails,
    required this.academicDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ProfileInfoSection(
            title: 'البيانات الشخصية',
            isExpanded: personalExpanded,
            onTap: onTogglePersonal,
            details: personalDetails,
          ),
          ProfileInfoSection(
            title: 'البيانات الأكاديمية',
            isExpanded: academicExpanded,
            onTap: onToggleAcademic,
            details: academicDetails,
          ),
        ],
      ),
    );
  }
}
