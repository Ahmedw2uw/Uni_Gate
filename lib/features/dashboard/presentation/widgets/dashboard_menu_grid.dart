import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      label: 'الطلبات',
      icon: Icons.request_page,
      route: '/requests',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 700 ? 3 : 2;
        return GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            childAspectRatio: constraints.maxWidth < 340 ? 1 : 1.1,
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
          user.studentId ?? int.tryParse(user.studentCode ?? '') ?? 0;
      debugPrint(
        'Opening results with studentId=$resultStudentId, profileStudentId=${user.studentId}, studentCode=${user.studentCode}, userId=${user.id}',
      );

      Navigator.pushNamed(
        context,
        '/results',
        arguments: {
          'studentId': resultStudentId,
          'year': user.academicYear ?? 1,
        },
      );
      return;
    }

    Navigator.pushNamed(context, item.route);
  }
}
