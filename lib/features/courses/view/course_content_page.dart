import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/features/courses/presentation/cubit/courses_cubit.dart';
import 'package:nuigate/features/courses/presentation/cubit/courses_state.dart';
import '../../../core/app_colors.dart';
import '../../../shared/widgets/custom_text.dart';
import '../../../shared/widgets/app_scaffold.dart';

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
    Future.microtask(
      () => context.read<CoursesCubit>().fetchCourseContent(widget.courseId),
    );
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
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCourseInfoCard(state.course),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          'محتوى المقرر',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 16),
                        _buildContentSection(state.courseContent),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is CourseContentFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  CustomText(
                    'فشل تحميل المحتوى',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 8),
                  CustomText(
                    state.message,
                    fontSize: 14,
                    color: Colors.grey[700],
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<CoursesCubit>().fetchCourseContent(
                        widget.courseId,
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCourseInfoCard(dynamic course) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            course.name ?? 'اسم المقرر',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(Icons.person, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              CustomText(
                course.instructor ?? 'دكتور المقرر',
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.code, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              CustomText(
                'الكود: ${course.code ?? 'N/A'}',
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ],
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.book, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                CustomText(
                  '${course.creditHours ?? 0} ساعات معتمدة',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          // if (course.description != null && course.description.isNotEmpty) ...[
          //   const SizedBox(height: 16),
          //   const CustomText(
          //     'وصف المقرر:',
          //     fontSize: 14,
          //     fontWeight: FontWeight.w600,
          //     color: Colors.black87,
          //   ),
          //   const SizedBox(height: 8),
          //   CustomText(
          //     course.description,
          //     fontSize: 13,
          //     color: Colors.grey[700],
          //   ),
          // ],
        ],
      ),
    );
  }

  /// بناء قسم المحتوى (الفيديوهات والدروس)
  /// يمكن توسيع هذا الجزء لاحقاً مع بيانات فعلية من API
  Widget _buildContentSection(dynamic courseContent) {
    return Column(
      children: [
        // قسم الفيديوهات (placeholder)
        _buildContentItem(
          icon: Icons.video_library,
          title: 'محاضرات الفيديو',
          subtitle: 'المحاضرات المسجلة للمقرر',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('سيتم إضافة الفيديوهات قريباً')),
            );
          },
        ),
        const SizedBox(height: 12),

        // قسم المواد والملفات
        _buildContentItem(
          icon: Icons.file_present,
          title: 'المواد والملفات',
          subtitle: 'الملاحظات والملفات الدراسية',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('سيتم إضافة الملفات قريباً')),
            );
          },
        ),
        const SizedBox(height: 12),

        // قسم الواجبات
        _buildContentItem(
          icon: Icons.assignment,
          title: 'الواجبات والمشاريع',
          subtitle: 'الواجبات والتكاليف الدراسية',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('سيتم إضافة الواجبات قريباً')),
            );
          },
        ),
        const SizedBox(height: 12),

        // قسم الامتحانات والاختبارات
        _buildContentItem(
          icon: Icons.quiz,
          title: 'الاختبارات',
          subtitle: 'الامتحانات والاختبارات القصيرة',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('سيتم إضافة الاختبارات قريباً')),
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  /// بناء عنصر محتوى واحد
  Widget _buildContentItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  const SizedBox(height: 4),
                  CustomText(subtitle, fontSize: 13, color: Colors.grey[600]),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
