class StudentRequestModel {
  final int id;
  final String typeName;
  final String date;
  final String status;

  StudentRequestModel({
    required this.id,
    required this.typeName,
    required this.date,
    required this.status,
  });

  factory StudentRequestModel.fromJson(Map<String, dynamic> json) {
    return StudentRequestModel(
      id: json['id'] ?? 0,
      // السيرفر بيبعتها باسم requestType
      typeName: json['requestType']?.toString() ?? '',
      // السيرفر بيبعتها باسم createdAt، هناخد أول جزء بس (التاريخ بدون الوقت)
      date: json['createdAt'] != null
          ? json['createdAt'].toString().split('T')[0]
          : '',
      // ترجمة الحالة عشان تظهر عربي للمستخدم
      status: _translateStatus(json['status']?.toString() ?? 'Pending'),
    );
  }

  // دالة صغيرة لترجمة حالة الطلب
  static String _translateStatus(String status) {
    switch (status) {
      case 'Pending':
        return 'قيد المراجعة';
      case 'Approved':
        return 'تمت الموافقة';
      case 'Rejected':
        return 'مرفوض';
      default:
        return 'قيد المراجعة';
    }
  }
}
