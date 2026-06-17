import 'package:equatable/equatable.dart';

class DoctorCourseEntity extends Equatable {
  final int courseId;
  final String courseName;
  final String courseCode;
  final String sectionName;
  final String departmentName;
  final int studentCount;
  final int submissionCount;
  final int upcomingExamCount;

  const DoctorCourseEntity({
    required this.courseId,
    required this.courseName,
    required this.courseCode,
    required this.sectionName,
    required this.departmentName,
    required this.studentCount,
    required this.submissionCount,
    required this.upcomingExamCount,
  });

  @override
  List<Object?> get props => [
    courseId,
    courseName,
    courseCode,
    sectionName,
    departmentName,
    studentCount,
    submissionCount,
    upcomingExamCount,
  ];
}
