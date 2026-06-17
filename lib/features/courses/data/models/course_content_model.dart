class CourseContentModel {
  final int id;
  final String lectureName;
  final String? contentType;
  final String? fileUrl;
  final String? availableFrom;
  final String? availableTo;
  final int? orderIndex;
  final int? semester;

  const CourseContentModel({
    required this.id,
    required this.lectureName,
    this.contentType,
    this.fileUrl,
    this.availableFrom,
    this.availableTo,
    this.orderIndex,
    this.semester,
  });

  factory CourseContentModel.fromJson(Map<String, dynamic> json) {
    return CourseContentModel(
      id: json['id'] ?? 0,
      lectureName: json['lectureName']?.toString() ?? '',
      contentType: json['contentType']?.toString(),
      fileUrl: json['fileUrl']?.toString(),
      availableFrom: json['availableFrom']?.toString(),
      availableTo: json['availableTo']?.toString(),
      orderIndex: json['orderIndex'] is int ? json['orderIndex'] : null,
      semester: json['semester'] is int ? json['semester'] : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'lectureName': lectureName,
    'contentType': contentType,
    'fileUrl': fileUrl,
    'availableFrom': availableFrom,
    'availableTo': availableTo,
    'orderIndex': orderIndex,
    'semester': semester,
  };
}
