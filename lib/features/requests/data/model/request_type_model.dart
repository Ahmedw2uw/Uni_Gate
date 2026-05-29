class RequestTypeModel {
  final int id;
  final String name;

  RequestTypeModel({required this.id, required this.name});

  factory RequestTypeModel.fromJson(Map<String, dynamic> json) {
    return RequestTypeModel(
      // 1. نقرأ الـ 'value' بدلاً من الـ 'id'
      id: json['value'] ?? 0,
      // 2. نقرأ الـ 'nameAr' عشان نعرض الاسم بالعربي للمستخدم
      name:
          json['nameAr']?.toString() ??
          json['nameEn']?.toString() ??
          'غير معروف',
    );
  }
}
