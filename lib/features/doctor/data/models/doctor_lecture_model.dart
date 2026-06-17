import 'package:nuigate/features/doctor/domain/entities/doctor_lecture_entity.dart';

class DoctorLectureModel extends DoctorLectureEntity {
  const DoctorLectureModel({
    required super.lectureId,
    required super.lectureName,
    required super.contentType,
    required super.fileUrl,
    super.availableFrom,
    super.availableTo,
  });

  factory DoctorLectureModel.fromJson(Map<String, dynamic> json) {
    return DoctorLectureModel(
      lectureId: _toInt(json['lectureId']),
      lectureName: json['lectureName']?.toString() ?? '',
      contentType: json['contentType']?.toString() ?? '',
      fileUrl: json['fileUrl']?.toString() ?? '',
      availableFrom: _toDate(json['availableFrom']),
      availableTo: _toDate(json['availableTo']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
