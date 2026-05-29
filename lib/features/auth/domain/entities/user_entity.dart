import 'package:equatable/equatable.dart';

/// User Entity - تمثيل الطالب في الـ domain layer
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? token;
  final String? profileImage;
  final String? role;
  final int? departmentId;
  final String? department;
  final int? academicYear;
  final int? semester;
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    this.profileImage,
    this.role,
    this.departmentId,
    this.department,
    this.academicYear,
    this.semester,
  });
  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? token,
    String? profileImage,
    String? role,
    int? departmentId,
    String? department,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
      departmentId: departmentId ?? this.departmentId,
      department: department ?? this.department,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    token,
    profileImage,
    role,
    departmentId,
    department,
    academicYear,
    semester,
  ];
}
