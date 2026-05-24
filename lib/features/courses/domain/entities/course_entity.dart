import 'package:equatable/equatable.dart';

class CourseEntity extends Equatable {
  final String id;
  final String name;
  final String instructor;
  final String code;
  final int creditHours;
  final double price;
  final dynamic content;
  final String? title;
  final String? description;

  const CourseEntity({
    required this.id,
    required this.name,
    required this.instructor,
    required this.code,
    required this.creditHours,
    required this.price,
    this.content,
    this.title,
    this.description,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    instructor,
    code,
    creditHours,
    price,
    content,
    title,
    description,
  ];
}
