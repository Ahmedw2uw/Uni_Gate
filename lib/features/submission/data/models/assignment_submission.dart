class AssignmentSubmission {
  final int id;
  final String course;
  final String lecturer;
  final String assignmentName;
  final String uploadDate;
  final String fileName;
  final String grade;

  const AssignmentSubmission({
    required this.id,
    required this.course,
    required this.lecturer,
    required this.assignmentName,
    required this.uploadDate,
    required this.fileName,
    required this.grade,
  });
}
class AssignmentModel {
  final int id;
  final String title;
  final String courseName;
  final String instructorName;
  final String dueDate;
  final double maxGrade;
  final String description;
  final int submissionStatus;
  final double? myGrade;
  final String? myFileUrl;
  final String? mySubmittedAt;

  AssignmentModel({
    required this.id,
    required this.title,
    required this.courseName,
    required this.instructorName,
    required this.dueDate,
    required this.maxGrade,
    required this.description,
    required this.submissionStatus,
    this.myGrade,
    this.myFileUrl,
    this.mySubmittedAt,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      courseName: json['courseName'] ?? '',
      instructorName: json['instructorName'] ?? '',
      dueDate: json['dueDate'] ?? '',
      maxGrade: (json['maxGrade'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      submissionStatus: json['submissionStatus'] ?? 0,
      myGrade: (json['myGrade'] as num?)?.toDouble(),
      myFileUrl: json['myFileUrl'],
      mySubmittedAt: json['mySubmittedAt'],
    );
  }
}