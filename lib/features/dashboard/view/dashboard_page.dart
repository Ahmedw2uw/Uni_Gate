import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_strings.dart';
import '../../../shared/widgets/app_scaffold.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppStrings.homeTitle,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _DashboardTile(
              label: 'الدورات',
              icon: Icons.menu_book,
              onTap: () => Navigator.pushNamed(context, '/courses'),
            ),
            _DashboardTile(
              label: 'الجدول',
              icon: Icons.schedule,
              onTap: () => Navigator.pushNamed(context, '/schedule'),
            ),
            _DashboardTile(
              label: 'الملف الشخصي',
              icon: Icons.person,
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            _DashboardTile(
              label: 'الامتحانات',
              icon: Icons.quiz,
              onTap: () => Navigator.pushNamed(context, '/exams'),
            ),
            _DashboardTile(
              label: 'عرض المحتوى',
              icon: Icons.folder_open,
              onTap: () => Navigator.pushNamed(context, '/content'),
            ),
            _DashboardTile(
              label: 'النتائج',
              icon: Icons.bar_chart,
              onTap: () => Navigator.pushNamed(context, '/results'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _DashboardTile({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: AppColors.primary),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
