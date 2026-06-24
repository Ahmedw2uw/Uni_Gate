import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_course_entity.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_exam_entity.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_exams_cubit.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_exams_state.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorExamsPage extends StatefulWidget {
  final DoctorCourseEntity? course;

  const DoctorExamsPage({super.key, this.course});

  @override
  State<DoctorExamsPage> createState() => _DoctorExamsPageState();
}

class _DoctorExamsPageState extends State<DoctorExamsPage> {
  final _titleController = TextEditingController();
  PlatformFile? _selectedFile;
  DateTime _startTime = DateTime.now();
  int _examType = 0;
  int _duration = 60;
  int? _loadedCourseId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void didUpdateWidget(covariant DoctorExamsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.course?.courseId != widget.course?.courseId) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _load() {
    final courseId = widget.course?.courseId;
    if (courseId == null || courseId <= 0 || _loadedCourseId == courseId) {
      return;
    }
    _loadedCourseId = courseId;
    context.read<DoctorExamsCubit>().loadCourseExams(courseId);
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    if (course == null) return const _NoCourseSelected();

    return BlocConsumer<DoctorExamsCubit, DoctorExamsState>(
      listenWhen: (p, c) =>
          p.errorMessage != c.errorMessage ||
          p.successMessage != c.successMessage,
      listener: (context, state) {
        final msg = state.errorMessage ?? state.successMessage;
        if (msg == null) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: state.errorMessage == null ? null : Colors.red,
          ),
        );
      },
      builder: (context, state) => SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomText(
              course.courseName,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 6.h),
            const CustomText(
              'إدارة الامتحانات',
              color: Colors.black54,
              fontSize: 14,
            ),
            SizedBox(height: 16.h),
            _buildForm(context, state),
            SizedBox(height: 20.h),
            const CustomText(
              'الامتحانات المرفوعة',
              fontWeight: FontWeight.w800,
            ),
            SizedBox(height: 10.h),
            if (state.exams.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30.h),
                child: const CustomText(
                  'لا توجد امتحانات',
                  color: Colors.black54,
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...state.exams.map(
                (exam) => _buildExamTile(context, exam, state),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, DoctorExamsState state) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.r,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            textDirection: TextDirection.rtl,
            enabled: !state.isUploading,
            decoration: InputDecoration(
              hintText: 'عنوان الامتحان',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 12.h,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          DropdownButtonFormField<int>(
            initialValue: _examType,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 10.h,
              ),
            ),
            items: const [
              DropdownMenuItem(value: 0, child: Text('اختبار عملي')),
              DropdownMenuItem(value: 1, child: Text('اختبار نظري')),
              DropdownMenuItem(value: 2, child: Text('اختبار شامل')),
            ],
            onChanged: state.isUploading
                ? null
                : (value) => setState(() => _examType = value ?? 0),
          ),
          SizedBox(height: 12.h),
          TextField(
            keyboardType: TextInputType.number,
            enabled: !state.isUploading,
            decoration: InputDecoration(
              hintText: 'المدة (دقائق)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 12.h,
              ),
            ),
            onChanged: (value) => _duration = int.tryParse(value) ?? 60,
          ),
          SizedBox(height: 12.h),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _startTime,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) setState(() => _startTime = picked);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'تاريخ البدء: ${_formatDate(_startTime)}',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          InkWell(
            onTap: () async {
              final result = await FilePicker.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf'],
                withData: false,
              );
              if (result != null && result.files.isNotEmpty) {
                setState(() => _selectedFile = result.files.single);
              }
            },
            child: Container(
              constraints: BoxConstraints(minHeight: 50.h),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: CustomText(
                _selectedFile?.name ?? 'اختر ملف PDF',
                textAlign: TextAlign.center,
                color: _selectedFile == null
                    ? Colors.black54
                    : AppColors.primary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 44.h,
            child: FilledButton(
              onPressed: state.isUploading ? null : () => _upload(context),
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              child: state.isUploading
                  ? SizedBox(
                      width: 18.r,
                      height: 18.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('رفع'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamTile(
    BuildContext context,
    DoctorExamEntity exam,
    DoctorExamsState state,
  ) {
    const examTypes = ['عملي', 'نظري', 'شامل'];
    final type = exam.examType >= 0 && exam.examType < examTypes.length
        ? examTypes[exam.examType]
        : 'امتحان';

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            _ActionIcon(
              icon: Icons.delete_outline,
              color: Colors.red,
              onPressed: state.isDeleting
                  ? null
                  : () => _delete(context, exam.examId),
            ),
            _ActionIcon(
              icon: Icons.download_outlined,
              color: AppColors.primary,
              onPressed: () => _download(exam),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    exam.title,
                    fontWeight: FontWeight.w700,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3.h),
                  CustomText(
                    '$type - ${exam.durationMinutes} دقيقة',
                    fontSize: 11,
                    color: Colors.black45,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _upload(BuildContext context) async {
    if (_titleController.text.trim().isEmpty) {
      _showMsg('اكتب العنوان', isError: true);
      return;
    }
    if (_selectedFile?.path == null) {
      _showMsg('اختر ملفاً', isError: true);
      return;
    }
    await context.read<DoctorExamsCubit>().uploadExam(
      courseId: widget.course!.courseId,
      title: _titleController.text,
      filePath: _selectedFile!.path!,
      fileName: _selectedFile!.name,
      examType: _examType,
      durationMinutes: _duration,
      startTime: _startTime,
    );
    _titleController.clear();
    setState(() => _selectedFile = null);
  }

  Future<void> _delete(BuildContext context, int id) async {
    await context.read<DoctorExamsCubit>().deleteExam(
      courseId: widget.course!.courseId,
      examId: id,
    );
  }

  Future<void> _download(DoctorExamEntity exam) async {
    final url = await context.read<DoctorExamsCubit>().getExamDownloadUrl(
      courseId: widget.course!.courseId,
      examId: exam.examId,
    );
    if (!mounted) return;
    if (url == null || url.isEmpty) {
      _showMsg('لم يتم العثور على الرابط', isError: true);
      return;
    }
    final uri = _buildFileUri(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showMsg('تعذر فتح الملف', isError: true);
    }
  }

  Uri? _buildFileUri(String url) {
    final value = url.trim();
    if (value.isEmpty) return null;
    return Uri.tryParse(
      value.startsWith('http') ? value : 'http://uni-gate.runasp.net$value',
    );
  }

  void _showMsg(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const _ActionIcon({required this.icon, required this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.r,
      height: 40.r,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: color, size: 22.r),
        onPressed: onPressed,
      ),
    );
  }
}

class _NoCourseSelected extends StatelessWidget {
  const _NoCourseSelected();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: const CustomText(
          'اختر كورساً أولاً',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
