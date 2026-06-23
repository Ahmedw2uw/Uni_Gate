import 'package:equatable/equatable.dart';

class DoctorAssignmentEntity extends Equatable {
  final int assignmentId;
  final String title;
  final String description;
  final DateTime? dueDate;
  final double maxGrade;
  final String fileUrl;
  final DateTime? createdAt;

  const DoctorAssignmentEntity({
    required this.assignmentId,
    required this.title,
    required this.description,
    this.dueDate,
    required this.maxGrade,
    required this.fileUrl,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    assignmentId,
    title,
    description,
    dueDate,
    maxGrade,
    fileUrl,
    createdAt,
  ];
}
