import 'package:equatable/equatable.dart';

class DoctorLectureEntity extends Equatable {
  final int lectureId;
  final String lectureName;
  final String contentType;
  final String fileUrl;
  final DateTime? availableFrom;
  final DateTime? availableTo;

  const DoctorLectureEntity({
    required this.lectureId,
    required this.lectureName,
    required this.contentType,
    required this.fileUrl,
    this.availableFrom,
    this.availableTo,
  });

  @override
  List<Object?> get props => [
    lectureId,
    lectureName,
    contentType,
    fileUrl,
    availableFrom,
    availableTo,
  ];
}
