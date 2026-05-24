import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/courses/presentation/cubit/courses_cubit.dart';
import 'package:nuigate/features/courses/presentation/cubit/courses_state.dart';
import 'package:nuigate/features/submission/data/models/assignment_submission.dart';
import 'package:nuigate/features/submission/presentation/cubit/assignment_cubit.dart';
import 'package:nuigate/features/submission/presentation/cubit/assignment_state.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';
// 🔥 تأكد من استيراد الكوبيت الخاص بالكورسات والموديل الخاص به هنا
// import 'package:nuigate/features/courses/presentation/cubit/course_cubit.dart';
// import 'package:nuigate/features/courses/data/models/course_model.dart';

class SubmissionPage extends StatefulWidget {
  const SubmissionPage({super.key}); // لا نطلب أي List عبر الـ Constructor 🎯

  @override
  State<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  dynamic _selectedCourse; // سيحمل كائن الكورس القادم من الـ API ديناميكياً
  AssignmentModel? _selectedAssignment;
  String? _selectedFilePath;
  String? _selectedFileName;

  // دالة جلب التكليفات بناءً على الآيدي الديناميكي الحقيقي
  void _fetchAssignments() {
    if (_selectedCourse != null) {
      int parsedCourseId;

      // التحقق من نوع الـ ID وتحويله بشكل آمن ديناميكياً 🧠
      if (_selectedCourse.id is int) {
        parsedCourseId = _selectedCourse.id;
      } else {
        // إذا كان القادم String، نقوم بتحويله إلى int فوراً
        parsedCourseId = int.parse(_selectedCourse.id.toString());
      }

      print(
        "🎯 جلب التكليفات ديناميكياً للكورس ID: $parsedCourseId (Type: ${parsedCourseId.runtimeType})",
      );

      context.read<AssignmentCubit>().fetchCourseAssignments(parsedCourseId);

      // تصفير الاختيارات السابقة لمنع أي Crash في الـ Dropdown الثاني
      _selectedAssignment = null;
      _selectedFilePath = null;
      _selectedFileName = null;
    }
  }

  // اختيار ملف حقيقي وتحديث حالة الواجهة جذرياً
  Future<void> _chooseFile() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'zip'],
      );

      if (!mounted) return;

      if (result != null) {
        PlatformFile file = result.files.first;

        print("🎯 تم اختيار الملف: ${file.name}");
        print("📂 مسار الملف: ${file.path}");

        // تحديث متغيرات الشاشة لتجهيز الملف للرفع الحقيقي 🚀
        setState(() {
          _selectedFileName = file.name;
          _selectedFilePath = file.path;
        });
      } else {
        print("❌ تم إلغاء اختيار الملف");
      }
    } catch (e) {
      print("🚨 حدث خطأ أثناء اختيار الملف: $e");
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
    return Scaffold(
      // أو AppScaffold حسب كودك
      appBar: AppBar(title: const Text('إرسال إجابات التكليفات')),
      // 🟢 هنا الحل الجذري: نقرأ حالة الكورسات مباشرة من الـ Cubit العام للتطبيق
      body: BlocBuilder<CoursesCubit, CoursesState>(
        builder: (context, courseState) {
          if (courseState is CoursesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (courseState is CoursesFailure) {
            return Center(
              child: Text('خطأ في جلب المواد: ${courseState.message}'),
            );
          }

          if (courseState is CoursesSuccess) {
            final myCourses = courseState
                .courses; // قائمة الكورسات الحقيقية من السيرفر [3310, 3311] 🎉

            if (myCourses.isEmpty) {
              return const Center(
                child: Text('أنت غير مسجل في أي مادة حالياً'),
              );
            }

            // تعيين أول مادة تلقائياً وجلب تكليفاتها عند فتح الشاشة لأول مرة فقط
            if (_selectedCourse == null) {
              _selectedCourse = myCourses.first;
              // جلب التكليفات للمادة الأولى فوراً بعد انتهاء بناء الشاشة
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => _fetchAssignments(),
              );
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSubmissionForm(
                      myCourses,
                    ), // نمرر القائمة الديناميكية المستلمة من الـ API للفورم
                    const SizedBox(height: 24),
                    _buildSubmissionsTableSection(),
                  ],
                ),
              ),
            );
          }

          return const Center(child: Text('جاري تهيئة البيانات...'));
        },
      ),
    );
  }

  Widget _buildSubmissionForm(List<dynamic> availableCourses) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CustomText('المادة', fontSize: 16, fontWeight: FontWeight.w700),
          const SizedBox(height: 8),

          // Dropdown المواد أصبح ديناميكي بالكامل ويقرأ من الـ API مباشرة 🎯
          DropdownButtonFormField<dynamic>(
            value: _selectedCourse,
            decoration: _getInputDecoration(),
            items: availableCourses
                .map(
                  (course) =>
                      DropdownMenuItem(value: course, child: Text(course.name)),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedCourse = value;
                  _fetchAssignments(); // يستدعي الـ API الحقيقي فوراً بآيدي المادة الجديدة
                });
              }
            },
          ),
          const SizedBox(height: 16),
          const CustomText(
            'اسم التكليف',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 8),

          BlocBuilder<AssignmentCubit, AssignmentState>(
            buildWhen: (previous, current) =>
                current is AssignmentLoading ||
                current is AssignmentSuccess ||
                current is AssignmentFailure,
            builder: (context, state) {
              List<AssignmentModel> assignments = [];
              if (state is AssignmentSuccess) {
                assignments = state.assignments;
              }

              return DropdownButtonFormField<AssignmentModel>(
                value: _selectedAssignment,
                hint: Text(
                  state is AssignmentLoading
                      ? 'جاري تحميل التكليفات...'
                      : 'اختر التكليف',
                ),
                decoration: _getInputDecoration(),
                items: assignments
                    .map(
                      (asm) =>
                          DropdownMenuItem(value: asm, child: Text(asm.title)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAssignment = value;
                  });
                },
              );
            },
          ),
          const SizedBox(height: 16),
          const CustomText(
            'اختيار الملف',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 8),
          _buildFilePickerWidget(),
          const SizedBox(height: 16),

          BlocBuilder<AssignmentCubit, AssignmentState>(
            builder: (context, state) {
              final isLoading = state is AssignmentUploadLoading;
              return SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isLoading ? null : _submitFile,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const CustomText(
                          'إرسال الملف',
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilePickerWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _selectedFileName ?? 'لم يتم اختيار ملف بعد',
              style: TextStyle(
                color: _selectedFileName == null
                    ? Colors.black45
                    : Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            onPressed: _chooseFile,
            child: const Text('Choose File'),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissionsTableSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CustomText(
            'التكليفات وحالة التسليم',
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 16),
          _buildTableHeader(),
          const Divider(height: 24, thickness: 1),
          BlocBuilder<AssignmentCubit, AssignmentState>(
            buildWhen: (previous, current) =>
                current is AssignmentLoading ||
                current is AssignmentSuccess ||
                current is AssignmentFailure,
            builder: (context, state) {
              if (state is AssignmentLoading) {
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  // عند تحميل التكليفات نكتفي بمؤشر التحميل بداخل الجدول منعاً لإعادة بناء الصفحة بالكامل وإلغاء الـ FilePicker
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (state is AssignmentFailure) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(state.errorMessage),
                  ),
                );
              }
              if (state is AssignmentSuccess) {
                if (state.assignments.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('لا يوجد تكليفات لهذه المادة'),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.assignments.length,
                  itemBuilder: (context, index) =>
                      _buildTableRow(state.assignments[index], index + 1),
                );
              }
              return const Center(child: Text('اختر مادة لعرض التكليفات'));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    const headerStyle = TextStyle(
      fontWeight: FontWeight.w700,
      color: Colors.black87,
    );
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text('#', style: headerStyle)),
          Expanded(flex: 3, child: Text('اسم التكليف', style: headerStyle)),
          Expanded(flex: 3, child: Text('المحاضر', style: headerStyle)),
          Expanded(flex: 3, child: Text('تاريخ الانتهاء', style: headerStyle)),
          Expanded(flex: 2, child: Text('الدرجة', style: headerStyle)),
        ],
      ),
    );
  }

  Widget _buildTableRow(AssignmentModel submission, int index) {
    String gradeDisplay = 'لم تسلم';
    if (submission.submissionStatus != 0) {
      gradeDisplay = submission.myGrade != null
          ? '${submission.myGrade}/${submission.maxGrade}'
          : 'قيد التصحيح';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text('$index')),
          Expanded(flex: 3, child: Text(submission.title)),
          Expanded(flex: 3, child: Text(submission.instructorName)),
          Expanded(flex: 3, child: Text(submission.dueDate.split('T').first)),
          Expanded(
            flex: 2,
            child: Text(
              gradeDisplay,
              style: TextStyle(
                color: submission.myGrade != null
                    ? Colors.green.shade700
                    : Colors.orange.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _getInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    );
  }
}
