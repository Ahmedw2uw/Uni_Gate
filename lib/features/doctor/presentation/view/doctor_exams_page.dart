import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    if (widget.course == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CustomText('اختر كورسا أولاً', textAlign: TextAlign.center),
        ),
      );
    }

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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomText(
              widget.course!.courseName,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
            const SizedBox(height: 6),
            const CustomText(
              'إدارة الامتحانات',
              color: Colors.black54,
              fontSize: 14,
            ),
            const SizedBox(height: 16),
            _buildForm(context, state),
            const SizedBox(height: 20),
            const CustomText(
              'الامتحانات المرفوعة',
              fontWeight: FontWeight.w800,
            ),
            const SizedBox(height: 10),
            if (state.exams.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: CustomText(
                  'لا توجد امتحانات',
                  color: Colors.black54,
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...state.exams.map((e) => _buildExamTile(context, e, state)),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, DoctorExamsState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
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
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: _examType,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 0, child: Text('اختبار عملي')),
              DropdownMenuItem(value: 1, child: Text('اختبار نظري')),
              DropdownMenuItem(value: 2, child: Text('اختبار شامل')),
            ],
            onChanged: state.isUploading
                ? null
                : (v) => setState(() => _examType = v ?? 0),
          ),
          const SizedBox(height: 12),
          TextField(
            keyboardType: TextInputType.number,
            enabled: !state.isUploading,
            decoration: InputDecoration(
              hintText: 'المدة (دقائق)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            onChanged: (v) => _duration = int.tryParse(v) ?? 60,
          ),
          const SizedBox(height: 12),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'تاريخ البدء: ${_startTime.year}-${_startTime.month}-${_startTime.day}',
                textAlign: TextAlign.right,
              ),
            ),
          ),
          const SizedBox(height: 12),
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
              constraints: const BoxConstraints(minHeight: 50),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _selectedFile?.name ?? 'اختر ملف PDF',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _selectedFile == null
                      ? Colors.black54
                      : AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: state.isUploading ? null : () => _upload(context),
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            child: state.isUploading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('رفع'),
          ),
        ],
      ),
    );
  }

  Widget _buildExamTile(
    BuildContext context,
    DoctorExamEntity e,
    DoctorExamsState state,
  ) {
    const examTypes = ['عملي', 'نظري', 'شامل'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: state.isDeleting
                  ? null
                  : () => _delete(context, e.examId),
            ),
            IconButton(
              icon: const Icon(
                Icons.download_outlined,
                color: AppColors.primary,
              ),
              onPressed: () => _download(e),
            ),
            const Spacer(),
            Flexible(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    e.title,
                    fontWeight: FontWeight.w700,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  CustomText(
                    '${examTypes[e.examType]} - ${e.durationMinutes} دقيقة',
                    fontSize: 11,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _upload(BuildContext context) async {
    if (_titleController.text.isEmpty) {
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

  void _delete(BuildContext context, int id) async {
    await context.read<DoctorExamsCubit>().deleteExam(
      courseId: widget.course!.courseId,
      examId: id,
    );
  }

  void _download(DoctorExamEntity e) async {
    final url = await context.read<DoctorExamsCubit>().getExamDownloadUrl(
      courseId: widget.course!.courseId,
      examId: e.examId,
    );
    if (!mounted) return;
    if (url == null || url.isEmpty) {
      _showMsg('لم يتم العثور على الرابط', isError: true);
      return;
    }
    final uri = Uri.tryParse(
      url.startsWith('http') ? url : 'http://uni-gate.runasp.net$url',
    );
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showMsg('تعذر فتح الملف', isError: true);
    }
  }

  void _showMsg(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }
}
