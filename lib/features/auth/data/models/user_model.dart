import 'package:nuigate/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  final String? studentCode;
  // الحقول الجديدة المكتشفة من السيرفر
  final String? phone;
  final String? nationalId;
  final String? gender;
  final String? facultyName;
  final int? studentId; // 🌟 ضيف السطر ده هنا لحفظ الـ ID الرقمي (2626)
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.token,
    super.profileImage,
    super.role,
    super.departmentId,
    super.department,
    this.studentCode,
    super.academicYear,
    this.phone, // جديد
    this.nationalId, // جديد
    this.gender, // جديد
    super.semester, // جديد
    this.facultyName,
    this.studentId, // جديد
  });

  // ========== الـ Getters الدفاعية للتأمين الأكاديمي ==========

  /// هل المستخدم متقدم طلب (Applicant)؟
  bool get isApplicant => role?.contains('Applicant') ?? false;

  /// هل للمستخدم قسم مسكن؟
  bool get hasAssignedDepartment => departmentId != null || department != null;

  /// هل يمكن للمستخدم الوصول للميزات الأكاديمية؟
  bool get canAccessAcademicFeatures => !isApplicant && hasAssignedDepartment;

  static int? _tryParseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final studentData = json['student'] as Map<String, dynamic>?;
    final academicInfo = studentData?['academicInfo'] as Map<String, dynamic>?;
    final deptData = json['department'] as Map<String, dynamic>?;
    final departmentId =
        _tryParseInt(deptData?['id']) ??
        _tryParseInt(studentData?['departmentId']);
    final departmentName =
        deptData?['name']?.toString() ??
        studentData?['departmentNameAr']?.toString() ??
        studentData?['departmentName']?.toString();

    return UserModel(
      id: json['id']?.toString() ?? studentData?['id']?.toString() ?? '',
      // استخدام الاسم من الـ studentData أولاً لأنه الأدق (Ahmed Ali)
      name:
          studentData?['fullName']?.toString() ??
          json['displayName']?.toString() ??
          '',
      email:
          json['email']?.toString() ?? studentData?['email']?.toString() ?? '',
      token: json['token']?.toString(),
      profileImage:
          studentData?['profileImageUrl']?.toString() ??
          json['profileImage']?.toString(),
      role: (json['role'] is List)
          ? (json['role'] as List).join(', ')
          : json['role']?.toString(),

      // ✅ التأكد من تحويل الـ ID لـ int بشكل صريح
      departmentId: departmentId,
      department: departmentName,

      // ✅ قراءة السنة والترم
      academicYear:
          academicInfo?['academicYear'] ?? studentData?['academicYear'] ?? 1,
      semester: academicInfo?['semester'] ?? studentData?['semester'] ?? 1,

      studentCode: studentData?['studentCode']?.toString(),
      phone: studentData?['phone']?.toString(),
      nationalId: studentData?['nationalId']?.toString(),
      gender: studentData?['gender']?.toString(),
      facultyName:
          academicInfo?['facultyName']?.toString() ??
          studentData?['facultyNameAr']?.toString() ??
          studentData?['facultyName']?.toString(),
      studentId:
          _tryParseInt(studentData?['id']) ?? _tryParseInt(json['studentId']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'profileImage': profileImage,
      'role': role,
      'departmentId': departmentId,
      'department': department,
      'studentCode': studentCode,
      'academicYear': academicYear,
      'phone': phone,
      'nationalId': nationalId,
      'gender': gender,
      'semester': semester,
      'facultyName': facultyName,
      'studentId': studentId,
    };
  }

  @override
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? token,
    String? profileImage,
    String? role,
    int? departmentId,
    String? department,
    String? studentCode,
    int? academicYear,
    String? phone,
    String? nationalId,
    String? gender,
    int? semester,
    String? facultyName,
    int? studentId,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
      departmentId: departmentId ?? this.departmentId,
      department: department ?? this.department,
      studentCode: studentCode ?? this.studentCode,
      academicYear: academicYear ?? super.academicYear,
      phone: phone ?? this.phone,
      nationalId: nationalId ?? this.nationalId,
      gender: gender ?? this.gender,
      semester: semester ?? super.semester,
      facultyName: facultyName ?? this.facultyName,
      studentId: studentId ?? this.studentId,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props, // يأخذ خصائص الـ UserEntity
    studentCode,
    academicYear,
    phone,
    nationalId,
    gender,
    semester,
    facultyName,
    studentId,
  ];
}
