import 'package:nuigate/features/doctor/domain/entities/doctor_submission_entity.dart';

class DoctorSubmissionModel extends DoctorSubmissionEntity {
  const DoctorSubmissionModel({
    required super.submissionId,
    required super.assignmentId,
    required super.assignmentTitle,
    required super.courseId,
    required super.courseName,
    required super.studentId,
    required super.studentName,
    required super.studentCode,
    required super.fileUrl,
    required super.grade,
    required super.maxGrade,
    required super.feedback,
    required super.status,
    required super.isGraded,
    required super.submittedAt,
  });

  factory DoctorSubmissionModel.fromJson(Map<String, dynamic> json) {
    return DoctorSubmissionModel(
      submissionId: _toInt(json['submissionId']),
      assignmentId: _toInt(json['assignmentId']),
      assignmentTitle: _toString(json['assignmentTitle'], fallback: 'واجب'),
      courseId: _toInt(json['courseId']),
      courseName: _toString(json['courseName']),
      studentId: _toInt(json['studentId']),
      studentName: _toString(json['studentName'], fallback: 'طالب'),
      studentCode: _toString(json['studentCode']),
      fileUrl: _toString(json['fileUrl']),
      grade: _toDouble(json['grade']),
      maxGrade: _toDouble(json['maxGrade']),
      feedback: json['feedback']?.toString(),
      status: _toString(json['status']),
      isGraded: _toBool(json['isGraded']) || json['grade'] != null,
      submittedAt: _toDate(json['submittedAt']) ?? DateTime.now(),
    );
  }

  static String _toString(dynamic value, {String fallback = ''}) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? fallback : text;
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }

  static DateTime? _toDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
