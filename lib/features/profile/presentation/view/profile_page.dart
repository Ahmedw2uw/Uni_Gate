import 'package:flutter/material.dart';
import 'package:nuigate/features/auth/data/models/user_model.dart';
import 'package:nuigate/features/profile/presentation/widgets/info_section.dart';
import '../../../../core/app_colors.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../../../../shared/widgets/app_scaffold.dart';

class ProfilePage extends StatefulWidget {
  final UserModel userData;

  const ProfilePage({super.key, required this.userData});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // تم زيادة طول القائمة لتشمل الأقسام الجديدة إذا أردت فصلها
  final List<bool> _expanded = [true, false];

  @override
  Widget build(BuildContext context) {
    final user = widget.userData;

    return AppScaffold(
      title: 'الملف الشخصي',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 1. بطاقة الرأس (تستخدم الـ studentCode كما في الصورة)
            _buildHeaderCard(user),
            const SizedBox(height: 20),

            // 2. حاوية أقسام البيانات
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.accent.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // قسم البيانات الشخصية (محدث بالحقول الجديدة)
                  ProfileInfoSection(
                    title: 'البيانات الشخصية',
                    isExpanded: _expanded[0],
                    onTap: () => setState(() => _expanded[0] = !_expanded[0]),
                    details: [
                      {'label': 'الاسم بالكامل', 'value': user.name},
                      {'label': 'البريد الإلكتروني', 'value': user.email},
                      {
                        'label': 'رقم الهاتف',
                        'value': user.phone ?? 'غير متوفر',
                      }, // مضاف
                      {
                        'label': 'الرقم القومي',
                        'value': user.nationalId ?? 'غير متوفر',
                      }, // مضاف
                      {
                        'label': 'الجنس',
                        'value': user.gender ?? 'غير محدد',
                      }, // مضاف
                      {'label': 'الدور', 'value': user.role ?? 'طالب'},
                    ],
                  ),

                  // قسم البيانات الأكاديمية (محدث بالحقول الجديدة)
                  ProfileInfoSection(
                    title: 'البيانات الأكاديمية',
                    isExpanded: _expanded[1],
                    onTap: () => setState(() => _expanded[1] = !_expanded[1]),
                    details: [
                      {
                        'label': 'كود الطالب',
                        'value': user.studentCode ?? '---',
                      },
                      {
                        'label': 'السنة الدراسية',
                        'value': user.academicYear?.toString() ?? '---',
                      },
                      {
                        'label': 'الفصل الدراسي',
                        'value': user.semester != null
                            ? 'الترم ${user.semester}'
                            : '---',
                      }, // مضاف
                      {
                        'label': 'الكلية',
                        'value': user.facultyName ?? 'كلية الحاسبات والمعلومات',
                      }, // مضاف
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(UserModel user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage: user.profileImage != null
                ? NetworkImage(user.profileImage!)
                : null,
            child: user.profileImage == null
                ? const Icon(Icons.person, size: 50, color: AppColors.primary)
                : null,
          ),
          const SizedBox(height: 15),
          CustomText(
            user.name,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          const SizedBox(height: 5),
          // عرض كود الطالب STU002 تحت الاسم مباشرة كما في image_58525a.png
          CustomText(user.studentCode ?? '', color: Colors.grey, fontSize: 14),
        ],
      ),
    );
  }
}
