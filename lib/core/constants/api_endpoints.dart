class ApiEndpoints {
  static const String baseUrl = 'http://uni-gate.runasp.net/api';

  // ===== Authentication =====
  static const String login = '/Authentication/login';
  static const String register = '/Authentication/register';
  static const String profile = '/Students/me/profile';

  // ===== StudentCourse Endpoints (Student) =====
  static const String getMyCourses = '/StudentCourse/my-courses';
  static const String getCoursesByYear = '/StudentCourse/courses/year';
  static String getCourseContent(String studentId, String courseId) =>
      '/StudentCourse/$studentId/courses/$courseId/content';
  static String getAvailableCourses(String studentId) =>
      '/StudentCourse/$studentId/courses/available';
  static const String registerCourses = '/StudentCourse/courses/register';
  static String registerSuccess(String sessionId) =>
      '/StudentCourse/courses/register-success/$sessionId';
  static String dropCourse(String studentId, String courseId) =>
      '/StudentCourse/$studentId/courses/$courseId';
  static String confirmCourses(String studentId) =>
      '/StudentCourse/$studentId/courses/confirm';
  static String getCourseDetails(String courseId) =>
      '/StudentCourse/course/$courseId';
  static String getCourseWithContent(String courseId) =>
      '/StudentCourse/course/$courseId/with-content';
  static String checkCourseExists(String courseId) =>
      '/StudentCourse/course/$courseId/exists';

  // ===== StudentCourse Endpoints (Admin) - Constants only =====
  // TODO: Implement admin endpoints when admin feature is built
  // static String adminUpdateCourse(String courseId) => '/StudentCourse/course/$courseId';
  // static String adminDeleteCourse(String courseId) => '/StudentCourse/course/$courseId';
  // static const String adminCreateCourse = '/StudentCourse/course';
  // static String adminGetStudentCourses(String studentId) => '/StudentCourse/$studentId/courses';

  // ===== Exams & Results =====
  static String getAvailableExams(int studentId) =>
      '/Exam/student/$studentId/available';

  // ===== Payment (Student) =====
  static const String checkout = '/Payment/checkout';
  static const String myPayments = '/Payment/my-payments';
  static const String refundRequest = '/Payment/refund-request';
  static String paymentSuccess(String sessionId) =>
      '/Payment/success/$sessionId';
}
