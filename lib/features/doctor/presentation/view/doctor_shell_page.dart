import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_navigation_cubit.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_navigation_state.dart';
import 'package:nuigate/features/doctor/presentation/view/doctor_dashboard_page.dart';
import 'package:nuigate/features/doctor/presentation/view/doctor_lectures_page.dart';
import 'package:nuigate/features/doctor/presentation/widgets/doctor_drawer.dart';
import 'package:nuigate/features/doctor/presentation/widgets/doctor_placeholder_tab.dart';

class DoctorShellPage extends StatelessWidget {
  const DoctorShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocBuilder<DoctorNavigationCubit, DoctorNavigationState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(state.selectedTab.title),
              centerTitle: true,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            endDrawer: const DoctorDrawer(),
            body: _DoctorTabBody(state: state),
          );
        },
      ),
    );
  }
}

class _DoctorTabBody extends StatelessWidget {
  final DoctorNavigationState state;

  const _DoctorTabBody({required this.state});

  @override
  Widget build(BuildContext context) {
    return switch (state.selectedTab) {
      DoctorTab.dashboard => const DoctorDashboardPage(),
      DoctorTab.assignments => const DoctorPlaceholderTab(
        title: 'الواجبات',
        icon: Icons.assignment_outlined,
      ),
      DoctorTab.lectures => DoctorLecturesPage(course: state.selectedCourse),
      DoctorTab.exams => const DoctorPlaceholderTab(
        title: 'الامتحانات',
        icon: Icons.quiz_outlined,
      ),
    };
  }
}
