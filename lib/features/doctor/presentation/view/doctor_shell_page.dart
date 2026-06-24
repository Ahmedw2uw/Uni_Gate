import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_navigation_cubit.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_navigation_state.dart';
import 'package:nuigate/features/doctor/presentation/view/doctor_assignments_page.dart';
import 'package:nuigate/features/doctor/presentation/view/doctor_dashboard_page.dart';
import 'package:nuigate/features/doctor/presentation/view/doctor_exams_page.dart';
import 'package:nuigate/features/doctor/presentation/view/doctor_lectures_page.dart';
import 'package:nuigate/features/doctor/presentation/view/doctor_submissions_page.dart';
import 'package:nuigate/features/doctor/presentation/widgets/doctor_drawer.dart';

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
              title: Text(
                state.selectedTab.title,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
              ),
              toolbarHeight: 56.h,
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
      DoctorTab.assignments => DoctorAssignmentsPage(
        course: state.selectedCourse,
      ),
      DoctorTab.lectures => DoctorLecturesPage(course: state.selectedCourse),
      DoctorTab.exams => DoctorExamsPage(course: state.selectedCourse),
      DoctorTab.submissions => DoctorSubmissionsPage(
        course: state.selectedCourse,
      ),
    };
  }
}
