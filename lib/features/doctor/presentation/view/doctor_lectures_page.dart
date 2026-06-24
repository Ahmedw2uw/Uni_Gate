import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_course_entity.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_lecture_entity.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_lectures_cubit.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_lectures_state.dart';
import 'package:nuigate/features/doctor/presentation/widgets/doctor_empty_lectures.dart';
import 'package:nuigate/features/doctor/presentation/widgets/doctor_lecture_form.dart';
import 'package:nuigate/features/doctor/presentation/widgets/doctor_lecture_tile.dart';
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
    final course = widget.course;
    if (course == null) {
      return const _NoCourseSelected();
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
                'إدارة المحاضرات',
                color: Colors.black54,
                fontSize: 14,
              ),
              SizedBox(height: 16.h),
              DoctorLectureForm(
                titleController: _titleController,
                selectedFile: _selectedFile,
                isUploading: state.isUploading,
                onPickFile: _pickFile,
                onUpload: _uploadLecture,
              ),
              SizedBox(height: 20.h),
              const CustomText(
                'المحاضرات المرفوعة',
                fontWeight: FontWeight.w800,
              ),
              SizedBox(height: 10.h),
              if (state.lectures.isEmpty)
                const DoctorEmptyLectures()
              else
                ...state.lectures.map(
                  (lecture) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: DoctorLectureTile(
                      lecture: lecture,
                      isDeleting: state.isDeleting,
                      onDownload: () => _openLecture(lecture),
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
      _showMessage('اكتب عنوان المحاضرة أولاً', isError: true);
      return;
    }
    if (file?.path == null) {
      _showMessage('اختر ملف PDF أو فيديو أولاً', isError: true);
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
    debugPrint('DEBUG DoctorLecturesPage.openLecture -> url=$url');

    if (!mounted) return;
    if (url == null || url.isEmpty) {
      _showMessage('تعذر الحصول على رابط تحميل الملف', isError: true);
      return;
    }

    final uri = _buildFileUri(url);
    if (uri == null) {
      _showMessage('الرابط المرسل غير صالح', isError: true);
      return;
    }

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!mounted) return;
      if (!opened) {
        _showMessage('تعذر فتح رابط التحميل على الجهاز', isError: true);
      }
    } catch (error) {
      debugPrint('DEBUG DoctorLecturesPage.openLecture exception: $error');
      if (!mounted) return;
      _showMessage('حدث خطأ أثناء محاولة فتح الملف', isError: true);
    }
  }

  Uri? _buildFileUri(String url) {
    final value = url.trim();
    if (value.isEmpty) return null;
    final normalized = value.startsWith('http')
        ? value
        : Uri.parse(
            'http://uni-gate.runasp.net',
          ).resolve(value.startsWith('/') ? value : '/$value').toString();
    return Uri.tryParse(normalized);
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

class _NoCourseSelected extends StatelessWidget {
  const _NoCourseSelected();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: const CustomText(
          'اختر كورساً من لوحة التحكم أولاً لإدارة محاضراته.',
          textAlign: TextAlign.center,
          color: Colors.black54,
          fontSize: 15,
        ),
      ),
    );
  }
}
