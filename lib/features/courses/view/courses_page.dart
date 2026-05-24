import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/courses/presentation/cubit/courses_cubit.dart';
import 'package:nuigate/features/courses/widgets/courses_view.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CoursesCubit>().fetchCourses();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CoursesView();
  }
}
