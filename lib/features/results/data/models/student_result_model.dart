class StudentResultResponse {
  final String? studentName;
  final String? studentId;
  final int? semester;
  final List<CourseResult> courseResults;

  StudentResultResponse({
    this.studentName,
    this.studentId,
    this.semester,
    required this.courseResults,
  });

  factory StudentResultResponse.fromJson(Map<String, dynamic> json) {
    return StudentResultResponse(
      studentName: json['studentName'],
      studentId: json['studentId']?.toString(),
      semester: json['semester'],
      courseResults: json['courseResults'] != null
          ? (json['courseResults'] as List)
                .map((e) => CourseResult.fromJson(e))
                .toList()
          : [],
    );
  }
}

class CourseResult {
  final String? courseName;
  final String? courseCode;
  final int? creditHours;
  final double? finalGrade; // الدرجة النهائية (مثلاً أعمال السنة + الفاينال)
  final String? gradeLevel; // الرمز مثل A, B+, C
  final String? instructorName;

  CourseResult({
    this.courseName,
    this.courseCode,
    this.creditHours,
    this.finalGrade,
    this.gradeLevel,
    this.instructorName,
  });

  factory CourseResult.fromJson(Map<String, dynamic> json) {
    return CourseResult(
      courseName: json['courseName'],
      courseCode: json['courseCode'],
      creditHours: json['creditHours'],
      finalGrade: json['finalGrade'] != null
          ? (json['finalGrade'] as num).toDouble()
          : null,
      gradeLevel: json['gradeLevel'],
      instructorName: json['instructorName'],
    );
  }
}
