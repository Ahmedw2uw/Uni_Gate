import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/doctor/domain/entities/doctor_submission_entity.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class DoctorSubmissionsTable extends StatefulWidget {
  final List<DoctorSubmissionEntity> submissions;
  final bool isGrading;
  final ValueChanged<DoctorSubmissionEntity> onOpenFile;
  final void Function(DoctorSubmissionEntity submission, double grade)
  onSaveGrade;

  const DoctorSubmissionsTable({
    super.key,
    required this.submissions,
    required this.isGrading,
    required this.onOpenFile,
    required this.onSaveGrade,
  });

  @override
  State<DoctorSubmissionsTable> createState() => _DoctorSubmissionsTableState();
}

class _DoctorSubmissionsTableState extends State<DoctorSubmissionsTable> {
  final Map<int, TextEditingController> _gradeControllers = {};

  @override
  void didUpdateWidget(covariant DoctorSubmissionsTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    final visibleIds = widget.submissions.map((s) => s.submissionId).toSet();
    _gradeControllers.removeWhere((id, controller) {
      final remove = !visibleIds.contains(id);
      if (remove) controller.dispose();
      return remove;
    });
  }

  @override
  void dispose() {
    for (final controller in _gradeControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE2E6EF)),
      ),
      child: Column(
        children: [
          const _TableHeader(),
          for (final submission in widget.submissions)
            _SubmissionRow(
              submission: submission,
              gradeController: _controllerFor(submission),
              isGrading: widget.isGrading,
              onOpenFile: () => widget.onOpenFile(submission),
              onSaveGrade: () => _saveGrade(submission),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                'عدد التقديمات: ${widget.submissions.length}',
                color: Colors.black54,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextEditingController _controllerFor(DoctorSubmissionEntity submission) {
    return _gradeControllers.putIfAbsent(
      submission.submissionId,
      () => TextEditingController(text: _formatGrade(submission.grade)),
    );
  }

  void _saveGrade(DoctorSubmissionEntity submission) {
    final value = double.tryParse(
      _controllerFor(submission).text.trim().replaceAll(',', '.'),
    );
    if (value == null) return;
    widget.onSaveGrade(submission, value);
  }

  String _formatGrade(double? grade) {
    if (grade == null) return '';
    return grade % 1 == 0 ? grade.toInt().toString() : grade.toString();
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
      ),
      child: Row(
        children: [
          SizedBox(width: 78.w, child: const _HeaderText('الإجراءات')),
          SizedBox(width: 82.w, child: const _HeaderText('الدرجة')),
          Expanded(child: const _HeaderText('الملف')),
          SizedBox(width: 100.w, child: const _HeaderText('تاريخ التسليم')),
          Expanded(child: const _HeaderText('اسم الواجب')),
          Expanded(child: const _HeaderText('اسم الطالب')),
        ],
      ),
    );
  }
}

class _SubmissionRow extends StatelessWidget {
  final DoctorSubmissionEntity submission;
  final TextEditingController gradeController;
  final bool isGrading;
  final VoidCallback onOpenFile;
  final VoidCallback onSaveGrade;

  const _SubmissionRow({
    required this.submission,
    required this.gradeController,
    required this.isGrading,
    required this.onOpenFile,
    required this.onSaveGrade,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE9EDF5))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 78.w,
            child: Row(
              children: [
                SizedBox(
                  width: 36.r,
                  height: 36.r,
                  child: IconButton(
                    tooltip: 'حفظ الدرجة',
                    padding: EdgeInsets.zero,
                    onPressed: isGrading ? null : onSaveGrade,
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 18.r,
                      color: isGrading ? Colors.black26 : AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(
                  width: 36.r,
                  height: 36.r,
                  child: IconButton(
                    tooltip: 'عرض ملف الطالب',
                    padding: EdgeInsets.zero,
                    onPressed: onOpenFile,
                    icon: Icon(
                      Icons.visibility_outlined,
                      size: 18.r,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 82.w,
            child: TextField(
              controller: gradeController,
              enabled: !isGrading,
              textAlign: TextAlign.center,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: TextStyle(fontSize: 12.sp),
              decoration: InputDecoration(
                isDense: true,
                suffixText: submission.maxGrade == null
                    ? null
                    : '/${_formatGrade(submission.maxGrade)}',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: 8.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              onPressed: onOpenFile,
              icon: Icon(Icons.attach_file, size: 15.r),
              label: CustomText(
                submission.fileUrl.isEmpty ? 'ملف التسليم' : _fileName,
                color: AppColors.primary,
                fontSize: 11,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(
            width: 100.w,
            child: _CellText(_formatDate(submission.submittedAt)),
          ),
          Expanded(child: _CellText(submission.assignmentTitle)),
          Expanded(child: _CellText(submission.studentName)),
        ],
      ),
    );
  }

  String get _fileName {
    final uri = Uri.tryParse(submission.fileUrl);
    final segment = uri?.pathSegments.isNotEmpty == true
        ? uri!.pathSegments.last
        : submission.fileUrl.split('/').last;
    return segment.isEmpty ? 'ملف التسليم' : segment;
  }

  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static String _formatGrade(double? grade) {
    if (grade == null) return '';
    return grade % 1 == 0 ? grade.toInt().toString() : grade.toString();
  }
}

class _HeaderText extends StatelessWidget {
  final String text;

  const _HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      color: Colors.black54,
      fontSize: 11,
      fontWeight: FontWeight.w700,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _CellText extends StatelessWidget {
  final String text;

  const _CellText(this.text);

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      fontSize: 11,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
