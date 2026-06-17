import 'package:equatable/equatable.dart';

class CourseEntity extends Equatable {
  final String id;
  final String name;
  final String code;
  final int creditHours;
  final double price;
  final String instructor;
  final int? instructorId;
  final int? departmentId;
  final int? academicYear;
  final int? semester;
  final dynamic content;
  final String? title;
  final String? description;

  const CourseEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.creditHours,
    required this.price,
    this.instructor = '',
    this.instructorId,
    this.departmentId,
    this.academicYear,
    this.semester,
    this.content,
    this.title,
    this.description,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    creditHours,
    price,
    instructor,
    instructorId,
    departmentId,
    academicYear,
    semester,
    content,
    title,
    description,
  ];
}
