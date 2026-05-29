class UserSession {
  int? studentId;
  int? semester;
  String? token;

  // دالة لتحديث البيانات فور جلب الـ Profile بنجاح
  void updateSession({required int id, required int currentSemester}) {
    studentId = id;
    semester = currentSemester;
  }
}
