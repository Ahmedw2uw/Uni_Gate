class CourseAssignmentModel {
  final int id;
  final String title;
  final String? dueDate;
  final int? maxGrade;
  final String? description;
  final String? attachmentUrl;

  const CourseAssignmentModel({
    required this.id,
    required this.title,
    this.dueDate,
    this.maxGrade,
    this.description,
    this.attachmentUrl,
  });

  factory CourseAssignmentModel.fromJson(Map<String, dynamic> json) {
    return CourseAssignmentModel(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? '',
      dueDate: json['dueDate']?.toString(),
      maxGrade: json['maxGrade'] is int ? json['maxGrade'] : null,
      description: json['description']?.toString(),
      attachmentUrl: json['attachmentUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'dueDate': dueDate,
    'maxGrade': maxGrade,
    'description': description,
    'attachmentUrl': attachmentUrl,
  };
}
