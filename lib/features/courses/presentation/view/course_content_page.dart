import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/courses/logic/cubit/courses_cubit.dart';
import 'package:nuigate/features/courses/logic/cubit/courses_state.dart';
import 'package:nuigate/features/courses/presentation/widgets/course_content_error_view.dart';
import 'package:nuigate/features/courses/presentation/widgets/course_content_view.dart';
import 'package:nuigate/shared/widgets/app_scaffold.dart';

class CourseContentPage extends StatefulWidget {
  final String courseId;
  final String courseName;

  const CourseContentPage({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  State<CourseContentPage> createState() => _CourseContentPageState();
}

class _CourseContentPageState extends State<CourseContentPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CoursesCubit>().fetchCourseContent(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: widget.courseName,
      child: BlocBuilder<CoursesCubit, CoursesState>(
        builder: (context, state) {
          if (state is CourseContentLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (state is CourseContentSuccess) {
            return CourseContentView(
              course: state.course,
              courseContent: state.courseContent,
            );
          }

          if (state is CourseContentFailure) {
            return CourseContentErrorView(
              message: state.message,
              onRetry: () {
                context.read<CoursesCubit>().fetchCourseContent(
                  widget.courseId,
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
