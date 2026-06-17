class StudentCourseEnrollmentModel {
  final int id;
  final int? studentId;
  final int? courseId;
  final int? semester;
  final int? academicYear;
  final String? status;
  final double? finalGrade;
  final String? gradeLevel;

  const StudentCourseEnrollmentModel({
    required this.id,
    this.studentId,
    this.courseId,
    this.semester,
    this.academicYear,
    this.status,
    this.finalGrade,
    this.gradeLevel,
  });

  factory StudentCourseEnrollmentModel.fromJson(Map<String, dynamic> json) {
    return StudentCourseEnrollmentModel(
      id: json['id'] ?? 0,
      studentId: json['studentId'] is int ? json['studentId'] : null,
      courseId: json['courseId'] is int ? json['courseId'] : null,
      semester: json['semester'] is int ? json['semester'] : null,
      academicYear: json['academicYear'] is int ? json['academicYear'] : null,
      status: json['status']?.toString(),
      finalGrade: json['finalGrade'] is num ? (json['finalGrade'] as num).toDouble() : null,
      gradeLevel: json['gradeLevel']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'studentId': studentId,
    'courseId': courseId,
    'semester': semester,
    'academicYear': academicYear,
    'status': status,
    'finalGrade': finalGrade,
    'gradeLevel': gradeLevel,
  };
}
