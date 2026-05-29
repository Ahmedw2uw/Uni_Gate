import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/courses/logic/cubit/courses_state.dart';
import 'package:nuigate/shared/widgets/app_scaffold.dart';

import 'package:nuigate/features/courses/logic/cubit/courses_cubit.dart';
import 'course_card.dart';
import 'courses_status_widgets.dart';

class CoursesView extends StatelessWidget {
  const CoursesView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'مواد المقررات',
      child: BlocBuilder<CoursesCubit, CoursesState>(
        builder: (context, state) {
          if (state is CoursesLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (state is CoursesUserNotAssigned) {
            return const CoursesEmptyState(
              icon: Icons.hourglass_empty,
              title: 'عذراً، لم يتم تسكينك في قسم أكاديمي بعد',
              subtitle: 'يرجى الانتظار حتى مراجعة طلبك أو مراجعة شؤون الطلاب.',
              showRetry: true,
            );
          }

          if (state is CoursesFailure) {
            return CoursesEmptyState(
              icon: Icons.error_outline,
              title: 'حدث خطأ في تحميل المقررات',
              subtitle: state.message,
              isError: true,
            );
          }

          if (state is CoursesSuccess) {
            if (state.courses.isEmpty) {
              return const CoursesEmptyState(
                icon: Icons.library_books,
                title: 'لا توجد مقررات مسجلة',
                subtitle: 'يبدو أنه لا توجد مقررات مسجلة لك حالياً.',
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<CoursesCubit>().fetchCourses(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.courses.length,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (context, index) =>
                    CourseCard(course: state.courses[index]),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
