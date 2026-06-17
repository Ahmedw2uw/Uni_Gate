import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_course_entity.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_lecture_entity.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_lectures_cubit.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_lectures_state.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorLecturesPage extends StatefulWidget {
  final DoctorCourseEntity? course;

  const DoctorLecturesPage({super.key, this.course});

  @override
  State<DoctorLecturesPage> createState() => _DoctorLecturesPageState();
}

class _DoctorLecturesPageState extends State<DoctorLecturesPage> {
  final TextEditingController _titleController = TextEditingController();
  PlatformFile? _selectedFile;
  int? _loadedCourseId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadLectures());
  }

  @override
  void didUpdateWidget(covariant DoctorLecturesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.course?.courseId != widget.course?.courseId) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadLectures());
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _loadLectures() {
    final courseId = widget.course?.courseId;
    if (courseId == null || courseId <= 0 || _loadedCourseId == courseId) {
      return;
    }
    _loadedCourseId = courseId;
    context.read<DoctorLecturesCubit>().loadCourseLectures(courseId);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.course == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CustomText(
            'اختر كورسا من لوحة التحكم أولا لإدارة محاضراته.',
            textAlign: TextAlign.center,
            color: Colors.black54,
            fontSize: 15,
          ),
        ),
      );
    }

    return BlocConsumer<DoctorLecturesCubit, DoctorLecturesState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.successMessage != current.successMessage,
      listener: (context, state) {
        final message = state.errorMessage ?? state.successMessage;
        if (message == null) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: state.errorMessage == null ? null : Colors.red,
          ),
        );
      },
      builder: (context, state) {
        return SingleChildScrollView(
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
                'إدارة المحاضرات',
                color: Colors.black54,
                fontSize: 14,
              ),
              const SizedBox(height: 16),
              _LectureForm(
                titleController: _titleController,
                selectedFile: _selectedFile,
                isUploading: state.isUploading,
                onPickFile: _pickFile,
                onUpload: _uploadLecture,
              ),
              const SizedBox(height: 20),
              const CustomText(
                'المحاضرات المرفوعة',
                fontWeight: FontWeight.w800,
              ),
              const SizedBox(height: 10),
              if (state.lectures.isEmpty)
                const _EmptyLectures()
              else
                ...state.lectures.map(
                  (lecture) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _LectureTile(
                      lecture: lecture,
                      isDeleting: state.isDeleting,
                      onOpen: () => _openLecture(lecture),
                      onDelete: () => _deleteLecture(lecture),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'mp4', 'mov', 'avi', 'mkv'],
      withData: false,
    );
    if (!mounted || result == null || result.files.isEmpty) return;
    setState(() => _selectedFile = result.files.single);
  }

  Future<void> _uploadLecture() async {
    final course = widget.course;
    final file = _selectedFile;
    final title = _titleController.text.trim();

    if (course == null) return;
    if (title.isEmpty) {
      _showMessage('اكتب عنوان المحاضرة أولا', isError: true);
      return;
    }
    if (file?.path == null) {
      _showMessage('اختر ملف PDF أو فيديو أولا', isError: true);
      return;
    }

    final extension = (file!.extension ?? '').toLowerCase();
    final contentType = extension == 'pdf' ? 0 : 1;

    await context.read<DoctorLecturesCubit>().uploadLecture(
      courseId: course.courseId,
      lectureName: title,
      filePath: file.path!,
      fileName: file.name,
      contentType: contentType,
    );

    if (!mounted) return;
    _titleController.clear();
    setState(() => _selectedFile = null);
  }

  Future<void> _openLecture(DoctorLectureEntity lecture) async {
    final course = widget.course;
    if (course == null) return;

    final url = await context.read<DoctorLecturesCubit>().getLectureDownloadUrl(
      courseId: course.courseId,
      lecture: lecture,
    );
    if (!mounted) return;
    if (url == null || url.isEmpty) {
      _showMessage('?? ???? ???? ???? ???? ?????', isError: true);
      return;
    }

    final normalizedUrl = url.startsWith('http')
        ? url
        : 'http://uni-gate.runasp.net';
    final uri = Uri.tryParse(normalizedUrl);
    if (uri == null) {
      _showMessage('???? ????? ??? ????', isError: true);
      return;
    }

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!mounted) return;
      if (!opened) {
        _showMessage('???? ??? ????? ??? ??????', isError: true);
      }
    } catch (_) {
      if (!mounted) return;
      _showMessage(
        '???? ??? ?????. ??? ????? ??????? ?????? ????? ?? ??? ??? ????.',
        isError: true,
      );
    }
  }

  Future<void> _deleteLecture(DoctorLectureEntity lecture) async {
    final course = widget.course;
    if (course == null) return;
    await context.read<DoctorLecturesCubit>().deleteLecture(
      courseId: course.courseId,
      lectureId: lecture.lectureId,
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }
}

class _LectureForm extends StatelessWidget {
  final TextEditingController titleController;
  final PlatformFile? selectedFile;
  final bool isUploading;
  final VoidCallback onPickFile;
  final VoidCallback onUpload;

  const _LectureForm({
    required this.titleController,
    required this.selectedFile,
    required this.isUploading,
    required this.onPickFile,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CustomText('عنوان المحاضرة', fontWeight: FontWeight.w700),
          const SizedBox(height: 8),
          TextField(
            controller: titleController,
            textDirection: TextDirection.rtl,
            enabled: !isUploading,
            decoration: InputDecoration(
              hintText: 'أدخل عنوان المحاضرة',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const CustomText(
            'رفع الملف (PDF أو Video)',
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 8),
          _LectureUploadBox(
            selectedFileName: selectedFile?.name,
            onTap: isUploading ? null : onPickFile,
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 96,
              height: 42,
              child: FilledButton(
                onPressed: isUploading ? null : onUpload,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isUploading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const CustomText(
                        'رفع',
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LectureUploadBox extends StatelessWidget {
  final String? selectedFileName;
  final VoidCallback? onTap;

  const _LectureUploadBox({this.selectedFileName, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        constraints: const BoxConstraints(minHeight: 58),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black26),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.upload_file_outlined, color: Colors.black54),
            const SizedBox(width: 8),
            Flexible(
              child: CustomText(
                selectedFileName ?? 'اختر ملف PDF أو Video',
                color: selectedFileName == null
                    ? Colors.black54
                    : AppColors.primary,
                fontSize: 13,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyLectures extends StatelessWidget {
  const _EmptyLectures();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: CustomText(
        'لا توجد محاضرات مرفوعة لهذا الكورس بعد.',
        color: Colors.black54,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _LectureTile extends StatelessWidget {
  final DoctorLectureEntity lecture;
  final bool isDeleting;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  const _LectureTile({
    required this.lecture,
    required this.isDeleting,
    required this.onOpen,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isVideo =
        lecture.contentType.toLowerCase().contains('video') ||
        lecture.fileUrl.toLowerCase().contains('.mp4');

    return InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(8),
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
              onPressed: isDeleting ? null : onDelete,
              icon: const Icon(Icons.delete_outline, color: Colors.red),
            ),
            const Spacer(),
            Flexible(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    lecture.lectureName,
                    fontWeight: FontWeight.w700,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  CustomText(
                    _formatMeta(lecture),
                    fontSize: 11,
                    color: Colors.black45,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isVideo
                  ? Icons.video_camera_back_outlined
                  : Icons.picture_as_pdf_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _formatMeta(DoctorLectureEntity lecture) {
    final date = lecture.availableFrom;
    if (date == null) return lecture.contentType;
    return '${lecture.contentType} - ${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
