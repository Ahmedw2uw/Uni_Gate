import 'package:nuigate/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  final String? studentCode;
  final int? academicYear;
  // الحقول الجديدة المكتشفة من السيرفر
  final String? phone;
  final String? nationalId;
  final String? gender;
  final int? semester;
  final String? facultyName;

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
    this.academicYear,
    this.phone, // جديد
    this.nationalId, // جديد
    this.gender, // جديد
    this.semester, // جديد
    this.facultyName, // جديد
  });

  // ========== الـ Getters الدفاعية للتأمين الأكاديمي ==========

  /// هل المستخدم متقدم طلب (Applicant)؟
  bool get isApplicant => role?.contains('Applicant') ?? false;

  /// هل للمستخدم قسم مسكن؟
  bool get hasAssignedDepartment => departmentId != null || department != null;

  /// هل يمكن للمستخدم الوصول للميزات الأكاديمية؟
  bool get canAccessAcademicFeatures => !isApplicant && hasAssignedDepartment;

factory UserModel.fromJson(Map<String, dynamic> json) {
  final studentData = json['student'] as Map<String, dynamic>?;
  final academicInfo = studentData?['academicInfo'] as Map<String, dynamic>?;
  final deptData = json['department'] as Map<String, dynamic>?;

  return UserModel(
    id: json['id']?.toString() ?? studentData?['id']?.toString() ?? '',
    // استخدام الاسم من الـ studentData أولاً لأنه الأدق (Ahmed Ali)
    name: studentData?['fullName']?.toString() ?? json['displayName']?.toString() ?? '',
    email: json['email']?.toString() ?? studentData?['email']?.toString() ?? '',
    token: json['token']?.toString(),
    role: (json['role'] is List) ? (json['role'] as List).join(', ') : json['role']?.toString(),

    // ✅ التأكد من تحويل الـ ID لـ int بشكل صريح
    departmentId: deptData?['id'] is int ? deptData!['id'] : int.tryParse(deptData?['id']?.toString() ?? '0') ?? 0,
    department: deptData?['name']?.toString(),

    // ✅ قراءة السنة والترم
    academicYear: academicInfo?['academicYear'] ?? studentData?['academicYear'] ?? 1,
    semester: academicInfo?['semester'] ?? studentData?['semester'] ?? 1,

    studentCode: studentData?['studentCode']?.toString(),
    phone: studentData?['phone']?.toString(),
    facultyName: academicInfo?['facultyName']?.toString(),
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
    };
  }

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
      academicYear: academicYear ?? this.academicYear,
      phone: phone ?? this.phone,
      nationalId: nationalId ?? this.nationalId,
      gender: gender ?? this.gender,
      semester: semester ?? this.semester,
      facultyName: facultyName ?? this.facultyName,
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
    ];
}
