import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_course_entity.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_assignment_entity.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_assignments_cubit.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_assignments_state.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorAssignmentsPage extends StatefulWidget {
  final DoctorCourseEntity? course;

  const DoctorAssignmentsPage({super.key, this.course});

  @override
  State<DoctorAssignmentsPage> createState() => _DoctorAssignmentsPageState();
}

class _DoctorAssignmentsPageState extends State<DoctorAssignmentsPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _maxGradeController = TextEditingController();
  PlatformFile? _selectedFile;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  int? _loadedCourseId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void didUpdateWidget(covariant DoctorAssignmentsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.course?.courseId != widget.course?.courseId) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _maxGradeController.dispose();
    super.dispose();
  }

  void _load() {
    final courseId = widget.course?.courseId;
    if (courseId == null || courseId <= 0 || _loadedCourseId == courseId) return;
    _loadedCourseId = courseId;
    context.read<DoctorAssignmentsCubit>().loadCourseAssignments(courseId);
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

    return BlocConsumer<DoctorAssignmentsCubit, DoctorAssignmentsState>(
      listenWhen: (p, c) => p.errorMessage != c.errorMessage || p.successMessage != c.successMessage,
      listener: (context, state) {
        final msg = state.errorMessage ?? state.successMessage;
        if (msg == null) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: state.errorMessage == null ? null : Colors.red),
        );
      },
      builder: (context, state) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomText(widget.course!.courseName, fontSize: 20, fontWeight: FontWeight.w800),
            const SizedBox(height: 6),
            const CustomText('إدارة الواجبات', color: Colors.black54, fontSize: 14),
            const SizedBox(height: 16),
            _buildForm(context, state),
            const SizedBox(height: 20),
            const CustomText('الواجبات المرفوعة', fontWeight: FontWeight.w800),
            const SizedBox(height: 10),
            if (state.assignments.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: CustomText('لا توجد واجبات', color: Colors.black54, textAlign: TextAlign.center),
              )
            else
              ...state.assignments.map((a) => _buildAssignmentTile(context, a, state)),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, DoctorAssignmentsState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            textDirection: TextDirection.rtl,
            enabled: !state.isUploading,
            decoration: InputDecoration(
              hintText: 'عنوان الواجب',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            textDirection: TextDirection.rtl,
            maxLines: 3,
            enabled: !state.isUploading,
            decoration: InputDecoration(
              hintText: 'الوصف (اختياري)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _maxGradeController,
            textDirection: TextDirection.rtl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            enabled: !state.isUploading,
            decoration: InputDecoration(
              hintText: 'أقصى درجة',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _dueDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) setState(() => _dueDate = picked);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(8)),
              child: Text('آخر موعد: ${_dueDate.year}-${_dueDate.month}-${_dueDate.day}', textAlign: TextAlign.right),
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () async {
              final result = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx'], withData: false);
              if (result != null && result.files.isNotEmpty) setState(() => _selectedFile = result.files.single);
            },
            child: Container(
              constraints: const BoxConstraints(minHeight: 50),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(8)),
              child: Text(
                _selectedFile?.name ?? 'اختر ملف',
                textAlign: TextAlign.center,
                style: TextStyle(color: _selectedFile == null ? Colors.black54 : AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: state.isUploading ? null : () => _upload(context),
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            child: state.isUploading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('رفع'),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentTile(BuildContext context, DoctorAssignmentEntity a, DoctorAssignmentsState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black12)),
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: state.isDeleting ? null : () => _delete(context, a.assignmentId)),
            IconButton(icon: const Icon(Icons.download_outlined, color: AppColors.primary), onPressed: () => _download(a)),
            const Spacer(),
            Flexible(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(a.title, fontWeight: FontWeight.w700, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  CustomText('الدرجة: ${a.maxGrade}', fontSize: 11, color: Colors.black45),
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
    final maxGrade = double.tryParse(_maxGradeController.text) ?? 0.0;
    await context.read<DoctorAssignmentsCubit>().uploadAssignment(
      courseId: widget.course!.courseId,
      title: _titleController.text,
      filePath: _selectedFile!.path!,
      fileName: _selectedFile!.name,
      dueDate: _dueDate,
      maxGrade: maxGrade,
      description: _descriptionController.text,
    );
    _titleController.clear();
    _descriptionController.clear();
    _maxGradeController.clear();
    setState(() => _selectedFile = null);
  }

  void _delete(BuildContext context, int id) async {
    await context.read<DoctorAssignmentsCubit>().deleteAssignment(courseId: widget.course!.courseId, assignmentId: id);
  }

  void _download(DoctorAssignmentEntity a) async {
    final url = await context.read<DoctorAssignmentsCubit>().getAssignmentDownloadUrl(courseId: widget.course!.courseId, assignmentId: a.assignmentId);
    if (!mounted) return;
    if (url == null || url.isEmpty) {
      _showMsg('لم يتم العثور على الرابط', isError: true);
      return;
    }
    final uri = Uri.tryParse(url.startsWith('http') ? url : 'http://uni-gate.runasp.net$url');
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showMsg('تعذر فتح الملف', isError: true);
    }
  }

  void _showMsg(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: isError ? Colors.red : null),
    );
  }
}
