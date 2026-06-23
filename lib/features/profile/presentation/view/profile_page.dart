import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/features/auth/data/models/user_model.dart';
import 'package:nuigate/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:nuigate/features/profile/presentation/widgets/profile_sections_card.dart';
import 'package:nuigate/shared/widgets/app_scaffold.dart';

class ProfilePage extends StatefulWidget {
  final UserModel userData;

  const ProfilePage({super.key, required this.userData});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _personalExpanded = true;
  bool _academicExpanded = false;

  @override
  Widget build(BuildContext context) {
    final user = widget.userData;

    return AppScaffold(
      title: 'الملف الشخصي',
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            ProfileHeaderCard(user: user),
            SizedBox(height: 20.h),
            ProfileSectionsCard(
              personalExpanded: _personalExpanded,
              academicExpanded: _academicExpanded,
              onTogglePersonal: () {
                setState(() => _personalExpanded = !_personalExpanded);
              },
              onToggleAcademic: () {
                setState(() => _academicExpanded = !_academicExpanded);
              },
              personalDetails: _buildPersonalDetails(user),
              academicDetails: _buildAcademicDetails(user),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _buildPersonalDetails(UserModel user) {
    return [
      {'label': 'الاسم بالكامل', 'value': user.name},
      {'label': 'البريد الإلكتروني', 'value': user.email},
      {'label': 'رقم الهاتف', 'value': user.phone ?? 'غير متوفر'},
      {'label': 'الرقم القومي', 'value': user.nationalId ?? 'غير متوفر'},
      {'label': 'الجنس', 'value': user.gender ?? 'غير محدد'},
      {'label': 'الدور', 'value': user.role ?? 'طالب'},
    ];
  }

  List<Map<String, String>> _buildAcademicDetails(UserModel user) {
    return [
      {'label': 'كود الطالب', 'value': user.studentCode ?? '---'},
      {
        'label': 'السنة الدراسية',
        'value': user.academicYear?.toString() ?? '---',
      },
      {
        'label': 'الفصل الدراسي',
        'value': user.semester != null ? 'الترم ${user.semester}' : '---',
      },
      {
        'label': 'الكلية',
        'value': user.facultyName ?? 'كلية الحاسبات والمعلومات',
      },
    ];
  }
}
