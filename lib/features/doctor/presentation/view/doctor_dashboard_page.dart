import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_courses_cubit.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_courses_state.dart';
import 'package:nuigate/features/doctor/presentation/widgets/doctor_courses_grid.dart';
import 'package:nuigate/features/doctor/presentation/widgets/doctor_empty_courses.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class DoctorDashboardPage extends StatefulWidget {
  const DoctorDashboardPage({super.key});

  @override
  State<DoctorDashboardPage> createState() => _DoctorDashboardPageState();
}

class _DoctorDashboardPageState extends State<DoctorDashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DoctorCoursesCubit>().fetchInstructorCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorCoursesCubit, DoctorCoursesState>(
      builder: (context, state) {
        if (state is DoctorCoursesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DoctorCoursesFailure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: CustomText(
                state.message,
                color: Colors.red,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        if (state is DoctorCoursesLoaded) {
          if (state.courses.isEmpty) return const DoctorEmptyCourses();
          return DoctorCoursesGrid(courses: state.courses);
        }

        return const SizedBox.shrink();
      },
    );
  }
}
