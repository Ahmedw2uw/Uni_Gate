class DepartmentModel {
  final int id;
  final String name;
  final String? nameAr;

  const DepartmentModel({
    required this.id,
    required this.name,
    this.nameAr,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      nameAr: json['nameAr']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'nameAr': nameAr,
  };
}
