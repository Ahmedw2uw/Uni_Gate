import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/dashboard/presentation/manager/dashboard_cubit.dart';
import 'package:nuigate/features/profile/presentation/view/profile_page.dart';
import '../../../../core/app_colors.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/custom_text.dart';
import '../../../../core/service_locator.dart';
import '../presentation/manager/dashboard_state.dart'
    show DashboardSuccess, DashboardState, DashboardLoading, DashboardError;

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceLocator.dashboardCubit..getStudentData(),
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          String welcomeMessage = "لوحة التحكم";
          if (state is DashboardSuccess) {
            welcomeMessage = "أهلاً، ${state.userData.name.split(' ')[0]}";
          }

          return AppScaffold(
            title: welcomeMessage,
            child: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, DashboardState state) {
    if (state is DashboardLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is DashboardError) {
      return _buildErrorView(context, state.message);
    }
    if (state is DashboardSuccess) {
      return Column(
        children: [
          _buildUserInfoHeader(state.userData),
          Expanded(child: _buildMenuGrid(context, state)),
        ],
      );
    }
    return const SizedBox();
  }

  Widget _buildUserInfoHeader(user) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            backgroundImage: user.profileImage != null
                ? NetworkImage(user.profileImage!)
                : null,
            child: user.profileImage == null
                ? const Icon(Icons.person, color: AppColors.primary)
                : null,
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                user.name,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              if (user.studentCode != null)
                CustomText(
                  "كود: ${user.studentCode}",
                  color: Colors.white70,
                  fontSize: 12,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context, DashboardState state) {
    final List<Map<String, dynamic>> tiles = [
      {'label': 'الدورات', 'icon': Icons.menu_book, 'route': '/courses'},
      {'label': 'الجدول', 'icon': Icons.schedule, 'route': '/schedule'},
      {'label': 'الملف الشخصي', 'icon': Icons.person, 'route': '/profile'},
      {'label': 'الامتحانات', 'icon': Icons.quiz, 'route': '/exams'},
      {'label': 'الواجبات', 'icon': Icons.assignment, 'route': '/submission'},
      {'label': 'النتائج', 'icon': Icons.bar_chart, 'route': '/results'},
      {'label': 'الدفع', 'icon': Icons.payment, 'route': '/payment'},
      {'label': 'طلبات', 'icon': Icons.payment, 'route': '/requests'},
      
    ];

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemCount: tiles.length,
      itemBuilder: (context, index) {
        final t = tiles[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // التحقق إذا كان الضغط على الملف الشخصي والبيانات محملة بنجاح
              if (t['route'] == '/profile' && state is DashboardSuccess) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(userData: state.userData),
                  ),
                );
              } else {
                // الانتقال لبقية الصفحات باستخدام الأسماء المعرفة في main.dart
                Navigator.pushNamed(context, t['route']);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(t['icon'], size: 40, color: AppColors.primary),
                const SizedBox(height: 10),
                CustomText(t['label'], fontWeight: FontWeight.bold),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    bool isAuthError = message == "401";
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 50),
          CustomText(isAuthError ? "انتهت الجلسة" : "فشل تحميل البيانات"),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            child: Text(isAuthError ? "تسجيل الدخول" : "إعادة المحاولة"),
          ),
        ],
      ),
    );
  }
}
