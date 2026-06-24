import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_course_entity.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_submission_entity.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_submissions_cubit.dart';
import 'package:nuigate/features/doctor/logic/cubit/doctor_submissions_state.dart';
import 'package:nuigate/features/doctor/presentation/widgets/doctor_submissions_table.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorSubmissionsPage extends StatefulWidget {
  final DoctorCourseEntity? course;

  const DoctorSubmissionsPage({super.key, this.course});

  @override
  State<DoctorSubmissionsPage> createState() => _DoctorSubmissionsPageState();
}

class _DoctorSubmissionsPageState extends State<DoctorSubmissionsPage> {
  int? _loadedCourseId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSubmissions());
  }

  @override
  void didUpdateWidget(covariant DoctorSubmissionsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.course?.courseId != widget.course?.courseId) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadSubmissions());
    }
  }

  void _loadSubmissions() {
    final courseId = widget.course?.courseId;
    if (courseId == null || courseId <= 0 || _loadedCourseId == courseId) {
      return;
    }
    _loadedCourseId = courseId;
    context.read<DoctorSubmissionsCubit>().loadCourseSubmissions(courseId);
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    if (course == null) return const _NoCourseSelected();

    return BlocConsumer<DoctorSubmissionsCubit, DoctorSubmissionsState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.successMessage != current.successMessage,
      listener: _listenToMessages,
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
                'تقييم التقديمات',
                color: Colors.black54,
                fontSize: 14,
              ),
              SizedBox(height: 20.h),
              _SubmissionsContent(
                state: state,
                onOpenFile: _openSubmissionFile,
                onSaveGrade: _saveGrade,
              ),
            ],
          ),
        );
      },
    );
  }

  void _listenToMessages(BuildContext context, DoctorSubmissionsState state) {
    final message = state.errorMessage ?? state.successMessage;
    if (message == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: state.errorMessage == null ? null : Colors.red,
      ),
    );
  }

  Future<void> _saveGrade(
    DoctorSubmissionEntity submission,
    double grade,
  ) async {
    final courseId = widget.course?.courseId;
    if (courseId == null) return;

    final maxGrade = submission.maxGrade;
    if (maxGrade != null && grade > maxGrade) {
      _showMessage(
        'الدرجة لا يمكن أن تتجاوز ${_formatGrade(maxGrade)}',
        isError: true,
      );
      return;
    }
    if (grade < 0) {
      _showMessage('الدرجة لا يمكن أن تكون أقل من صفر', isError: true);
      return;
    }

    await context.read<DoctorSubmissionsCubit>().gradeSubmission(
      courseId: courseId,
      submissionId: submission.submissionId,
      grade: grade,
      feedback: submission.feedback ?? '',
    );
  }

  Future<void> _openSubmissionFile(DoctorSubmissionEntity submission) async {
    var fileUrl = submission.fileUrl;
    if (fileUrl.isEmpty) {
      fileUrl =
          await context.read<DoctorSubmissionsCubit>().getSubmissionFileUrl(
            submission.submissionId,
          ) ??
          '';
    }
    if (!mounted) return;

    if (fileUrl.isEmpty) {
      _debug('No fileUrl for submission ${submission.submissionId}');
      _showMessage('لا يوجد ملف مرفوع لهذا التسليم', isError: true);
      return;
    }

    final uri = _buildFileUri(fileUrl);
    if (uri == null) {
      _debug('Invalid fileUrl: $fileUrl');
      _showMessage('رابط الملف غير صالح', isError: true);
      return;
    }

    await _launchUri(uri);
  }

  Uri? _buildFileUri(String fileUrl) {
    final trimmed = fileUrl.trim();
    if (trimmed.isEmpty) return null;
    final normalized = trimmed.startsWith('http')
        ? trimmed
        : Uri.parse(
            'http://uni-gate.runasp.net',
          ).resolve(trimmed.startsWith('/') ? trimmed : '/$trimmed').toString();
    return Uri.tryParse(normalized);
  }

  Future<void> _launchUri(Uri uri) async {
    try {
      _debug('Opening submission file: $uri');
      var opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened) {
        _debug('externalApplication failed, trying platformDefault');
        opened = await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
      if (!mounted) return;
      if (!opened) {
        _showMessage('تعذر فتح ملف التسليم', isError: true);
      }
    } catch (error, stackTrace) {
      _debug('launchUrl exception: $error');
      if (kDebugMode) debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      _showMessage('تعذر فتح الملف. راجع Debug Console.', isError: true);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }

  void _debug(String message) {
    if (kDebugMode) debugPrint('DOCTOR_SUBMISSIONS_PAGE: $message');
  }

  String _formatGrade(double grade) {
    return grade % 1 == 0 ? grade.toInt().toString() : grade.toString();
  }
}

class _SubmissionsContent extends StatelessWidget {
  final DoctorSubmissionsState state;
  final ValueChanged<DoctorSubmissionEntity> onOpenFile;
  final void Function(DoctorSubmissionEntity submission, double grade)
  onSaveGrade;

  const _SubmissionsContent({
    required this.state,
    required this.onOpenFile,
    required this.onSaveGrade,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 44.h),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state.submissions.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 44.h),
        child: const CustomText(
          'لا توجد تقديمات لهذا الكورس حتى الآن.',
          color: Colors.black54,
          textAlign: TextAlign.center,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final tableWidth = constraints.maxWidth < 760.w
            ? 760.w
            : constraints.maxWidth;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: tableWidth,
            child: DoctorSubmissionsTable(
              submissions: state.submissions,
              isGrading: state.isGrading,
              onOpenFile: onOpenFile,
              onSaveGrade: onSaveGrade,
            ),
          ),
        );
      },
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
          'اختر كورساً من لوحة التحكم أولاً لعرض تسليمات الطلاب.',
          textAlign: TextAlign.center,
          color: Colors.black54,
          fontSize: 15,
        ),
      ),
    );
  }
}
