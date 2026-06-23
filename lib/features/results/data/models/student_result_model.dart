class StudentResultResponse {
  final int? studentId;
  final String? studentName;
  final String? studentCode;
  final List<ResultYear> years;

  const StudentResultResponse({
    this.studentId,
    this.studentName,
    this.studentCode,
    required this.years,
  });

  List<CourseResult> get courseResults =>
      years.expand((yearResult) => yearResult.results).toList(growable: false);

  factory StudentResultResponse.fromJson(Map<String, dynamic> json) {
    return StudentResultResponse(
      studentId: _tryParseInt(json['studentId']),
      studentName: json['studentName']?.toString(),
      studentCode: json['studentCode']?.toString(),
      years: (json['years'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ResultYear.fromJson)
          .toList(),
    );
  }
}

class ResultYear {
  final int? year;
  final List<CourseResult> results;

  const ResultYear({this.year, required this.results});

  factory ResultYear.fromJson(Map<String, dynamic> json) {
    return ResultYear(
      year: _tryParseInt(json['year']),
      results: (json['results'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(CourseResult.fromJson)
          .toList(),
    );
  }
}

class CourseResult {
  final int? id;
  final int? studentId;
  final int? year;
  final String? courseName;
  final String? courseCode;
  final double? grade;

  const CourseResult({
    this.id,
    this.studentId,
    this.year,
    this.courseName,
    this.courseCode,
    this.grade,
  });

  factory CourseResult.fromJson(Map<String, dynamic> json) {
    return CourseResult(
      id: _tryParseInt(json['id']),
      studentId: _tryParseInt(json['studentId']),
      year: _tryParseInt(json['year']),
      courseName: json['courseName']?.toString(),
      courseCode: json['courseCode']?.toString(),
      grade: _tryParseDouble(json['grade']),
    );
  }
}

int? _tryParseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

double? _tryParseDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}
