import 'package:equatable/equatable.dart';

class DoctorExamEntity extends Equatable {
  final int examId;
  final String title;
  final int examType;
  final int durationMinutes;
  final DateTime? startTime;
  final String fileUrl;
  final DateTime? createdAt;

  const DoctorExamEntity({
    required this.examId,
    required this.title,
    required this.examType,
    required this.durationMinutes,
    this.startTime,
    required this.fileUrl,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    examId,
    title,
    examType,
    durationMinutes,
    startTime,
    fileUrl,
    createdAt,
  ];
}
