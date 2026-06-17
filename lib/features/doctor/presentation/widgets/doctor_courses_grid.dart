import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_course_entity.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_navigation_cubit.dart';
import 'package:nuigate/features/doctor/presentation/widgets/doctor_course_card.dart';

class DoctorCoursesGrid extends StatelessWidget {
  final List<DoctorCourseEntity> courses;

  const DoctorCoursesGrid({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final course = courses[index];
        return DoctorCourseCard(
          course: course,
          onTap: () {
            context.read<DoctorNavigationCubit>().openCourseLectures(course);
          },
        );
      },
    );
  }
}
