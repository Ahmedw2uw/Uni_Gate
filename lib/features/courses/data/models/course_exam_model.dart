class CourseExamModel {
  final int id;
  final String title;
  final String? examType;
  final int? durationMinutes;
  final String? startTime;
  final String? examPaperUrl;

  const CourseExamModel({
    required this.id,
    required this.title,
    this.examType,
    this.durationMinutes,
    this.startTime,
    this.examPaperUrl,
  });

  factory CourseExamModel.fromJson(Map<String, dynamic> json) {
    return CourseExamModel(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? '',
      examType: json['examType']?.toString(),
      durationMinutes: json['durationMinutes'] is int ? json['durationMinutes'] : null,
      startTime: json['startTime']?.toString(),
      examPaperUrl: json['examPaperUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'examType': examType,
    'durationMinutes': durationMinutes,
    'startTime': startTime,
    'examPaperUrl': examPaperUrl,
  };
}
