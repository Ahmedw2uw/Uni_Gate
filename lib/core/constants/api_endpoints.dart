class ApiEndpoints {
  static const String baseUrl = 'http://uni-gate.runasp.net/api';

  // ===== Authentication =====
  static const String login = '/Authentication/login';
  static const String register = '/Authentication/register';
  static const String profile =
      '/Students/me/profile'; // ✅ أضفناه لجلب الـ DeptID

  // ===== Student Courses (المجلد اللي في الصورة) =====

  // جلب الكورسات بناءً على السنة والترم والقسم
  static const String getCoursesByYear = '/StudentCourse/my-courses/';

  // ⚠️ تحذير: الرابط القديم '/StudentCourse/course/$courseId' يسبب Error 500
  // الحل: استخدام '/with-content' الذي يعمل بدون مشاكل Object Cycle
  static String getCourseDetails(String courseId) =>
      '/StudentCourse/course/$courseId/with-content';

  static String getCourseWithContent(String courseId) =>
      '/StudentCourse/course/$courseId/with-content';

  // جلب الكورسات المسجلة للطالب (My Courses)
  static const String getMyCourses = '/StudentCourse/my-courses';

  // تسجيل كورس جديد
  static const String registerCourse = '/StudentCourse/register';

  // ===== Exams & Results =====
  static String getAvailableExams(int studentId) =>
      '/Exam/student/$studentId/available';
}
