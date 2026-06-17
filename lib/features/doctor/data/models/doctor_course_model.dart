import 'package:nuigate/features/doctor/domain/entities/doctor_course_entity.dart';

class DoctorCourseModel extends DoctorCourseEntity {
  const DoctorCourseModel({
    required super.courseId,
    required super.courseName,
    required super.courseCode,
    required super.sectionName,
    required super.departmentName,
    required super.studentCount,
    required super.submissionCount,
    required super.upcomingExamCount,
  });

  factory DoctorCourseModel.fromJson(Map<String, dynamic> json) {
    return DoctorCourseModel(
      courseId: _toInt(json['courseId']),
      courseName: json['courseName']?.toString() ?? '',
      courseCode: json['courseCode']?.toString() ?? '',
      sectionName: json['sectionName']?.toString() ?? '',
      departmentName: json['departmentName']?.toString() ?? '',
      studentCount: _toInt(json['studentCount']),
      submissionCount: _toInt(json['submissionCount']),
      upcomingExamCount: _toInt(json['upcomingExamCount']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
