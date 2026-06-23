import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/courses/logic/cubit/courses_cubit.dart';
import 'package:nuigate/features/courses/logic/cubit/courses_state.dart';
import 'package:nuigate/features/submission/data/models/assignment_submission.dart';
import 'package:nuigate/features/submission/logic/cubit/assignment_cubit.dart';
import 'package:nuigate/features/submission/logic/cubit/assignment_state.dart';
import 'package:nuigate/shared/widgets/app_scaffold.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class SubmissionPage extends StatefulWidget {
  const SubmissionPage({super.key});

  @override
  State<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  dynamic _selectedCourse;
  AssignmentModel? _selectedAssignment;
  String? _selectedFilePath;
  String? _selectedFileName;

  void _fetchAssignments() {
    final course = _selectedCourse;
    if (course == null) return;

    final courseId = int.tryParse(course.id.toString());
    if (courseId == null) {
      _showSnackBar('تعذر تحديد المادة المختارة');
      return;
    }

    debugPrint('SUBMISSION_PAGE: loading assignments for courseId=$courseId');
    context.read<AssignmentCubit>().fetchCourseAssignments(courseId);

    _selectedAssignment = null;
    _selectedFilePath = null;
    _selectedFileName = null;
  }

  Future<void> _chooseFile() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'zip'],
      );

      if (!mounted || result == null || result.files.isEmpty) return;

      final file = result.files.first;
      debugPrint(
        'SUBMISSION_PAGE: selected file=${file.name}, path=${file.path}',
      );

      setState(() {
        _selectedFileName = file.name;
        _selectedFilePath = file.path;
      });
    } catch (error) {
      debugPrint('SUBMISSION_PAGE: file picker error=$error');
      _showSnackBar('حدث خطأ أثناء اختيار الملف');
    }
  }

  void _submitFile() {
    if (_selectedAssignment == null) {
      _showSnackBar('الرجاء اختيار التكليف أولاً');
      return;
    }
    if (_selectedFilePath == null) {
      _showSnackBar('الرجاء اختيار ملف قبل الإرسال');
      return;
    }

    context.read<AssignmentCubit>().submitAssignment(
      assignmentId: _selectedAssignment!.id,
      filePath: _selectedFilePath!,
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'تسليم الواجبات',
      child: BlocBuilder<CoursesCubit, CoursesState>(
        builder: (context, courseState) {
          if (courseState is CoursesLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (courseState is CoursesFailure) {
            return _MessageState(
              icon: Icons.error_outline,
              title: 'فشل تحميل المواد',
              subtitle: courseState.message,
              isError: true,
            );
          }

          if (courseState is CoursesSuccess) {
            final courses = courseState.courses;
            if (courses.isEmpty) {
              return const _MessageState(
                icon: Icons.menu_book_outlined,
                title: 'لا توجد مواد مسجلة',
                subtitle: 'أنت غير مسجل في أي مادة حالياً.',
              );
            }

            if (_selectedCourse == null) {
              _selectedCourse = courses.first;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) _fetchAssignments();
              });
            }

            return BlocListener<AssignmentCubit, AssignmentState>(
              listener: (context, state) {
                if (state is AssignmentUploadSuccess) {
                  _showSnackBar(state.message);
                  setState(() {
                    _selectedFilePath = null;
                    _selectedFileName = null;
                  });
                  _fetchAssignments();
                } else if (state is AssignmentUploadFailure) {
                  _showSnackBar(state.errorMessage);
                }
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SubmissionForm(
                      courses: courses,
                      selectedCourse: _selectedCourse,
                      selectedAssignment: _selectedAssignment,
                      selectedFileName: _selectedFileName,
                      onCourseChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _selectedCourse = value;
                          _fetchAssignments();
                        });
                      },
                      onAssignmentChanged: (value) {
                        setState(() => _selectedAssignment = value);
                      },
                      onChooseFile: _chooseFile,
                      onSubmit: _submitFile,
                    ),
                    SizedBox(height: 24.h),
                    const _AssignmentsStatusSection(),
                  ],
                ),
              ),
            );
          }

          return const _MessageState(
            icon: Icons.hourglass_empty,
            title: 'جاري تهيئة البيانات',
            subtitle: 'يرجى الانتظار قليلاً.',
          );
        },
      ),
    );
  }
}

class _SubmissionForm extends StatelessWidget {
  final List<dynamic> courses;
  final dynamic selectedCourse;
  final AssignmentModel? selectedAssignment;
  final String? selectedFileName;
  final ValueChanged<dynamic> onCourseChanged;
  final ValueChanged<AssignmentModel?> onAssignmentChanged;
  final VoidCallback onChooseFile;
  final VoidCallback onSubmit;

  const _SubmissionForm({
    required this.courses,
    required this.selectedCourse,
    required this.selectedAssignment,
    required this.selectedFileName,
    required this.onCourseChanged,
    required this.onAssignmentChanged,
    required this.onChooseFile,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _FieldTitle('المادة'),
          SizedBox(height: 8.h),
          DropdownButtonFormField<dynamic>(
            initialValue: selectedCourse,
            isExpanded: true,
            decoration: _inputDecoration(),
            items: courses
                .map(
                  (course) => DropdownMenuItem(
                    value: course,
                    child: Text(
                      course.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: onCourseChanged,
          ),
          SizedBox(height: 16.h),
          const _FieldTitle('اسم التكليف'),
          SizedBox(height: 8.h),
          BlocBuilder<AssignmentCubit, AssignmentState>(
            buildWhen: (previous, current) =>
                current is AssignmentLoading ||
                current is AssignmentSuccess ||
                current is AssignmentFailure,
            builder: (context, state) {
              final assignments = state is AssignmentSuccess
                  ? state.assignments
                  : <AssignmentModel>[];

              return DropdownButtonFormField<AssignmentModel>(
                isExpanded: true,
                initialValue: assignments.contains(selectedAssignment)
                    ? selectedAssignment
                    : null,
                hint: Text(
                  state is AssignmentLoading
                      ? 'جاري تحميل التكليفات...'
                      : 'اختر التكليف',
                ),
                decoration: _inputDecoration(),
                items: assignments
                    .map(
                      (assignment) => DropdownMenuItem(
                        value: assignment,
                        child: Text(
                          assignment.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onAssignmentChanged,
              );
            },
          ),
          SizedBox(height: 16.h),
          const _FieldTitle('اختيار الملف'),
          SizedBox(height: 8.h),
          _FilePickerBox(
            fileName: selectedFileName,
            onChooseFile: onChooseFile,
          ),
          SizedBox(height: 16.h),
          BlocBuilder<AssignmentCubit, AssignmentState>(
            builder: (context, state) {
              final isLoading = state is AssignmentUploadLoading;
              return SizedBox(
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onPressed: isLoading ? null : onSubmit,
                  child: isLoading
                      ? SizedBox(
                          width: 22.r,
                          height: 22.r,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const CustomText(
                          'إرسال الملف',
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          textAlign: TextAlign.center,
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AssignmentsStatusSection extends StatelessWidget {
  const _AssignmentsStatusSection();

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CustomText(
            'التكليفات وحالة التسليم',
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 16.h),
          BlocBuilder<AssignmentCubit, AssignmentState>(
            buildWhen: (previous, current) =>
                current is AssignmentLoading ||
                current is AssignmentSuccess ||
                current is AssignmentFailure,
            builder: (context, state) {
              if (state is AssignmentLoading) {
                return Padding(
                  padding: EdgeInsets.all(20.r),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              if (state is AssignmentFailure) {
                return _InlineMessage(message: state.errorMessage);
              }
              if (state is AssignmentSuccess) {
                if (state.assignments.isEmpty) {
                  return const _InlineMessage(
                    message: 'لا توجد تكليفات لهذه المادة',
                  );
                }
                return Column(
                  children: [
                    for (var i = 0; i < state.assignments.length; i++)
                      _AssignmentStatusCard(
                        assignment: state.assignments[i],
                        index: i + 1,
                      ),
                  ],
                );
              }
              return const _InlineMessage(message: 'اختر مادة لعرض التكليفات');
            },
          ),
        ],
      ),
    );
  }
}

class _AssignmentStatusCard extends StatelessWidget {
  final AssignmentModel assignment;
  final int index;

  const _AssignmentStatusCard({required this.assignment, required this.index});

  @override
  Widget build(BuildContext context) {
    final submitted = assignment.submissionStatus != 0;
    final gradeDisplay = submitted
        ? assignment.myGrade != null
              ? '${assignment.myGrade}/${assignment.maxGrade}'
              : 'قيد التصحيح'
        : 'لم تسلم';

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 14.r,
                backgroundColor: AppColors.primary,
                child: CustomText(
                  '$index',
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: CustomText(
                  assignment.title,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          _MetaLine(label: 'المحاضر', value: assignment.instructorName),
          _MetaLine(
            label: 'تاريخ الانتهاء',
            value: _formatDate(assignment.dueDate),
          ),
          _MetaLine(
            label: 'الدرجة',
            value: gradeDisplay,
            valueColor: assignment.myGrade != null
                ? Colors.green.shade700
                : Colors.orange.shade700,
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    if (date.isEmpty) return 'غير محدد';
    return date.split('T').first;
  }
}

class _FilePickerBox extends StatelessWidget {
  final String? fileName;
  final VoidCallback onChooseFile;

  const _FilePickerBox({required this.fileName, required this.onChooseFile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 320;
          final fileText = CustomText(
            fileName ?? 'لم يتم اختيار ملف بعد',
            fontSize: 13,
            color: fileName == null ? Colors.black45 : Colors.black87,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          );
          final button = ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            ),
            onPressed: onChooseFile,
            child: const Text('اختيار ملف'),
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                fileText,
                SizedBox(height: 10.h),
                button,
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: fileText),
              SizedBox(width: 12.w),
              button,
            ],
          );
        },
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _MetaLine({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 94.w,
            child: CustomText(label, fontSize: 12, color: Colors.black54),
          ),
          Expanded(
            child: CustomText(
              value,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: valueColor,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  final Widget child;

  const _SurfaceCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FieldTitle extends StatelessWidget {
  final String title;

  const _FieldTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return CustomText(title, fontSize: 16, fontWeight: FontWeight.w700);
  }
}

class _InlineMessage extends StatelessWidget {
  final String message;

  const _InlineMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: CustomText(
        message,
        fontSize: 14,
        color: Colors.black54,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isError;

  const _MessageState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 56.r,
              color: isError ? Colors.red : AppColors.primary,
            ),
            SizedBox(height: 16.h),
            CustomText(
              title,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            CustomText(
              subtitle,
              fontSize: 13,
              color: Colors.black54,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration() {
  return InputDecoration(
    filled: true,
    fillColor: AppColors.background,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide.none,
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
  );
}
