import 'package:equatable/equatable.dart';

class DoctorSubmissionEntity extends Equatable {
  final int submissionId;
  final int assignmentId;
  final String assignmentTitle;
  final int courseId;
  final String courseName;
  final int studentId;
  final String studentName;
  final String studentCode;
  final String fileUrl;
  final double? grade;
  final double? maxGrade;
  final String? feedback;
  final String status;
  final bool isGraded;
  final DateTime submittedAt;

  const DoctorSubmissionEntity({
    required this.submissionId,
    required this.assignmentId,
    required this.assignmentTitle,
    required this.courseId,
    required this.courseName,
    required this.studentId,
    required this.studentName,
    required this.studentCode,
    required this.fileUrl,
    required this.grade,
    required this.maxGrade,
    required this.feedback,
    required this.status,
    required this.isGraded,
    required this.submittedAt,
  });

  @override
  List<Object?> get props => [
    submissionId,
    assignmentId,
    assignmentTitle,
    courseId,
    courseName,
    studentId,
    studentName,
    studentCode,
    fileUrl,
    grade,
    maxGrade,
    feedback,
    status,
    isGraded,
    submittedAt,
  ];
}
