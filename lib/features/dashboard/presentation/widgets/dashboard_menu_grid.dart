import 'package:flutter/material.dart';
import 'package:nuigate/features/auth/data/models/user_model.dart';
import 'package:nuigate/features/dashboard/presentation/widgets/dashboard_menu_item.dart';
import 'package:nuigate/features/dashboard/presentation/widgets/dashboard_menu_tile.dart';
import 'package:nuigate/features/profile/presentation/view/profile_page.dart';

class DashboardMenuGrid extends StatelessWidget {
  final UserModel user;

  const DashboardMenuGrid({super.key, required this.user});

  static const List<DashboardMenuItem> _items = [
    DashboardMenuItem(
      label: 'الدورات',
      icon: Icons.menu_book,
      route: '/courses',
    ),
    DashboardMenuItem(
      label: 'الجدول',
      icon: Icons.schedule,
      route: '/schedule',
    ),
    DashboardMenuItem(
      label: 'الملف الشخصي',
      icon: Icons.person,
      route: '/profile',
    ),
    DashboardMenuItem(label: 'الامتحانات', icon: Icons.quiz, route: '/exams'),
    DashboardMenuItem(
      label: 'الواجبات',
      icon: Icons.assignment,
      route: '/submission',
    ),
    DashboardMenuItem(
      label: 'النتائج',
      icon: Icons.bar_chart,
      route: '/results',
    ),
    DashboardMenuItem(label: 'الدفع', icon: Icons.payment, route: '/payment'),
    DashboardMenuItem(
      label: 'طلبات',
      icon: Icons.request_page,
      route: '/requests',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return DashboardMenuTile(
          item: item,
          onTap: () => _handleNavigation(context, item),
        );
      },
    );
  }

  void _handleNavigation(BuildContext context, DashboardMenuItem item) {
    if (item.route == '/profile') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage(userData: user)),
      );
      return;
    }

    if (item.route == '/results') {
      final resultStudentId =
          int.tryParse(user.studentCode ?? '') ?? user.studentId ?? 0;
      debugPrint(
        'Opening results with studentId=$resultStudentId, profileStudentId=${user.studentId}, studentCode=${user.studentCode}, userId=${user.id}',
      );

      Navigator.pushNamed(
        context,
        '/results',
        arguments: {
          'studentId': resultStudentId,
          'semester': user.semester ?? 1,
        },
      );
      return;
    }

    Navigator.pushNamed(context, item.route);
  }
}
