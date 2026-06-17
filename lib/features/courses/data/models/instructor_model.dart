class InstructorModel {
  final int id;
  final String fullName;
  final String? title;
  final String? email;
  final int? departmentId;

  const InstructorModel({
    required this.id,
    required this.fullName,
    this.title,
    this.email,
    this.departmentId,
  });

  factory InstructorModel.fromJson(Map<String, dynamic> json) {
    return InstructorModel(
      id: json['id'] ?? 0,
      fullName: json['fullName']?.toString() ?? '',
      title: json['title']?.toString(),
      email: json['email']?.toString(),
      departmentId: json['departmentId'] is int ? json['departmentId'] : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'title': title,
    'email': email,
    'departmentId': departmentId,
  };
}
