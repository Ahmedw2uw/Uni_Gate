import 'package:nuigate/features/courses/domain/entities/course_entity.dart';

class CourseModel extends CourseEntity {
  const CourseModel({
    required super.id,
    required super.name,
    required super.instructor,
    required super.code,
    required super.creditHours,
    required super.price,
    super.content,
    super.title,
    super.description,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      instructor:
          "${json['instructorTitle'] ?? ''} ${json['instructorName'] ?? ''}"
              .trim(),
      code: json['code']?.toString() ?? '',
      creditHours: json['creditHours'] is int
          ? json['creditHours']
          : int.tryParse(json['creditHours'].toString()) ?? 0,
      price: json['price'] is num ? (json['price'] as num).toDouble() : 0.0,
      content: json['content'],
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'instructorName': instructor,
      'code': code,
      'creditHours': creditHours,
      'price': price,
      'title': title,
      'description': description,
      'content': content,
    };
  }
}
