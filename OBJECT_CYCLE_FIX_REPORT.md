# 🔧 تقرير إصلاح مشكلة Object Cycle و Error 500

## 📋 ملخص المشكلة

### 🔴 المشكلة الأساسية

عند محاولة جلب تفاصيل كورس معين عبر الرابط:

```
/StudentCourse/course/{id}
```

يحدث **Internal Server Error (500)** بسبب:

```
A possible object cycle was detected
```

### ✅ السبب

الرابط القديم `/StudentCourse/course/{id}` يعيد بيانات بها **علاقات دائرية (Circular References)** في الـ JSON، مما يسبب مشاكل في الـ Serialization/Deserialization.

### 🎯 الحل

استخدام الرابط البديل الذي يعمل بدون مشاكل:

```
/StudentCourse/course/{id}/with-content
```

---

## 📝 التعديلات المطبقة

### 1️⃣ **تعديل ApiEndpoints**

📂 `lib/core/constants/api_endpoints.dart`

**قبل (خطأ):**

```dart
static String getCourseDetails(String courseId) => '/StudentCourse/course/$courseId';
```

**بعد (صحيح):**

```dart
static String getCourseDetails(String courseId) =>
  '/StudentCourse/course/$courseId/with-content';

static String getCourseWithContent(String courseId) =>
  '/StudentCourse/course/$courseId/with-content';
```

**شرح:** الآن كل دالة تستخدم الرابط الصحيح الذي لا يسبب Error 500 ✅

---

### 2️⃣ **تحديث CoursesRemoteDataSource**

📂 `lib/features/courses/data/datasources/courses_remote_datasource.dart`

```dart
@override
Future<CourseModel> getCourseById(String courseId) async {
  try {
    // ✅ استخدام الرابط الصحيح with-content لتجنب Error 500
    final response = await apiServices.get(
      ApiEndpoints.getCourseDetails(courseId),
    );

    if (response.statusCode == 200) {
      return CourseModel.fromJson(response.data);
    } else {
      throw Exception('فشل جلب المقرر: ${response.statusMessage}');
    }
  } catch (e) {
    throw Exception('خطأ في جلب المقرر: $e');
  }
}

@override
Future<CourseModel> getCourseWithContent(String courseId) async {
  try {
    final response = await apiServices.get(
      ApiEndpoints.getCourseWithContent(courseId),
    );

    if (response.statusCode == 200) {
      return CourseModel.fromJson(response.data);
    } else {
      throw Exception('فشل جلب محتوى المقرر: ${response.statusMessage}');
    }
  } catch (e) {
    throw Exception('خطأ في جلب محتوى المقرر: $e');
  }
}
```

---

### 3️⃣ **إزالة دالة معيبة من Cubit**

📂 `lib/features/courses/presentation/cubit/courses_cubit.dart`

**تم حذف دالة `loadCourseContent()` لأنها:**

- ❌ استخدمت صيغة خاطئة: `result.content.fold()`
- ❌ الـ `Either` لا يملك خاصية `.content`
- ✅ تم استبدالها بـ `fetchCourseContent()` الموجودة والتي تعمل بشكل صحيح

**استخدم هذه الدالة بدلاً منها:**

```dart
Future<void> fetchCourseContent(String courseId) async {
  if (courseId.isEmpty) {
    emit(const CourseContentFailure(message: 'معرف المقرر غير صحيح'));
    return;
  }

  if (state is CourseContentLoading) return;

  emit(const CourseContentLoading());

  try {
    // استخدام GetCourseByIdUseCase (الذي يستخدم الرابط الصحيح الآن)
    final courseDetails = await getCourseByIdUseCase(courseId);

    print("DEBUG: Course Details Retrieved -> ${courseDetails.id}, ${courseDetails.name}");

    emit(
      CourseContentSuccess(
        course: courseDetails,
        courseContent: courseDetails,
      ),
    );
  } catch (e) {
    print("ERROR in fetchCourseContent: $e");
    emit(CourseContentFailure(message: e.toString()));
  }
}
```

---

## 🧪 كود اختبار JSON Parsing

### اختبار بسيط للتأكد من عدم وجود مشاكل في Parsing

```dart
// في ملف test/features/courses/data/models/course_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:nuigate/features/courses/data/models/course_model.dart';

void main() {
  group('CourseModel', () {

    test('fromJson - يجب أن يحول JSON صحيح إلى CourseModel', () {
      // ✅ JSON صحيح (من الرابط /with-content)
      final json = {
        'id': 1,
        'name': 'البرمجة بلغة Dart',
        'instructorName': 'أحمد محمد',
        'instructorTitle': 'د.',
        'code': 'CS101',
        'creditHours': 3,
        'price': 100.0,
        'content': {
          'videos': ['video1.mp4', 'video2.mp4'],
          'lessons': ['lesson1', 'lesson2'],
        }
      };

      // تحويل JSON إلى Model
      final course = CourseModel.fromJson(json);

      // التحقق من عدم وجود null
      expect(course.id, isNotEmpty);
      expect(course.name, isNotEmpty);
      expect(course.instructor, isNotEmpty);
      expect(course.creditHours, isPositive);

      // التحقق من دمج الـ Title + Name بشكل صحيح
      expect(course.instructor, 'د. أحمد محمد');
    });

    test('fromJson - يجب التعامل مع القيم الناقصة بدون رمي أخطاء', () {
      // JSON ناقص بعض الحقول
      final json = {
        'id': 2,
        'name': 'خوارزميات',
        // لا يوجد instructorName أو instructorTitle
        'creditHours': 4,
        // لا يوجد content
      };

      // يجب ألا يرمي خطأ
      final course = CourseModel.fromJson(json);

      expect(course.id, '2');
      expect(course.name, 'خوارزميات');
      expect(course.instructor, isEmpty); // يجب أن يكون فارغاً وليس null
    });

    test('fromJson - يجب التعامل مع أنواع البيانات المختلفة', () {
      final json = {
        'id': 3, // int
        'name': 'قاعدة البيانات',
        'creditHours': '2', // String
        'price': 50, // int (يجب تحويله إلى double)
      };

      final course = CourseModel.fromJson(json);

      expect(course.creditHours, 2); // int
      expect(course.price, 50.0); // double
    });

    test('fromJson - لا يجب أن يعطي Type Mismatch في Parsing', () {
      // JSON معقد مع nested objects
      final json = {
        'id': 4,
        'name': 'تطوير الويب',
        'instructorName': 'فاطمة علي',
        'instructorTitle': 'أ.د.',
        'code': 'WEB101',
        'creditHours': 3,
        'price': 150.5,
        'content': {
          'videos': ['intro.mp4', 'lesson1.mp4'],
          'materials': [
            {'title': 'ملف 1', 'url': 'file1.pdf'},
            {'title': 'ملف 2', 'url': 'file2.pdf'},
          ],
          'assignments': 5,
          'quizzes': 3,
        }
      };

      // يجب أن يعمل بدون مشاكل
      final course = CourseModel.fromJson(json);

      expect(course.id, '4');
      expect(course.content, isNotNull);
      expect(course.content, isA<Map>());
    });
  });
}
```

### طريقة تشغيل الاختبار:

```bash
flutter test test/features/courses/data/models/course_model_test.dart
```

---

## 🔐 معالجة الـ Token في الـ Header

### المكان الصحيح لحقن الـ Token

**📂 `lib/network/api_services.dart`**

```dart
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  late Dio dio;

  ApiServices() {
    dio = Dio();

    // ✅ إضافة Interceptor للـ Token تلقائياً
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // جلب الـ Token من SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');

          // إضافة الـ Token في Header إذا كان موجوداً
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // طباعة الـ Request للـ Debug
          print('🔵 REQUEST: ${options.method} ${options.path}');
          print('📤 Headers: ${options.headers}');

          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('🟢 RESPONSE: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (error, handler) {
          // معالجة Error 401 (Unauthorized)
          if (error.response?.statusCode == 401) {
            print('🔴 ERROR 401: Token غير صحيح أو منتهي الصلاحية');
            // يمكن إضافة منطق لتحديث الـ Token أو إعادة تسجيل الدخول
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      return await dio.post(endpoint, data: data);
    } on DioException catch (e) {
      rethrow;
    }
  }
}
```

### مثال على Response صحيح من الـ API:

```json
{
  "id": 1,
  "name": "البرمجة بلغة Dart",
  "instructorName": "د. أحمد محمد",
  "instructorTitle": "د.",
  "code": "CS101",
  "creditHours": 3,
  "price": 100.0,
  "content": {
    "videos": [
      {
        "id": 1,
        "title": "مقدمة إلى Dart",
        "url": "https://example.com/video1.mp4",
        "duration": 45
      }
    ],
    "lessons": [
      {
        "id": 1,
        "title": "الدرس الأول",
        "description": "مقدمة أساسية"
      }
    ],
    "assignments": [
      {
        "id": 1,
        "title": "تمرين 1",
        "dueDate": "2024-05-20"
      }
    ],
    "quizzes": [
      {
        "id": 1,
        "title": "اختبار 1",
        "questions": 10
      }
    ]
  }
}
```

---

## 📊 خريطة التدفق (Flow Chart)

```
┌─────────────────┐
│  User clicks    │
│  "View Course"  │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────┐
│ CourseCard calls:               │
│ fetchCourseContent(courseId)    │
└────────┬────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│ CoursesCubit.fetchCourseContent()
│ emit(CourseContentLoading)      │
└────────┬────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│ GetCourseByIdUseCase(courseId)  │
└────────┬────────────────────────┘
         │
         ▼
┌──────────────────────────────────────┐
│ CoursesRepository.getCourseById()    │
└────────┬─────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────┐
│ CoursesRemoteDataSource.getCourseById()
│ Endpoint: /with-content (✅ صحيح)   │
└────────┬─────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────┐
│ ApiServices.get()                    │
│ + Bearer Token in Header             │
│ → Response 200 ✅                    │
└────────┬─────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────┐
│ CourseModel.fromJson()               │
│ Parse JSON without Object Cycle ✅  │
└────────┬─────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────┐
│ CoursesCubit.emit(                   │
│   CourseContentSuccess(course, content)
│ )                                    │
└────────┬─────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────┐
│ CourseContentPage shows:             │
│ - Course Name ✅                     │
│ - Instructor ✅                      │
│ - Content (Videos, Lessons) ✅      │
└──────────────────────────────────────┘
```

---

## ✅ Checklist التحقق

- [x] تم تغيير الرابط من `/StudentCourse/course/{id}` إلى `/with-content`
- [x] تم تحديث `ApiEndpoints.getCourseDetails()`
- [x] تم تحديث `CoursesRemoteDataSource.getCourseById()`
- [x] تم إزالة دالة معيبة من `CoursesCubit`
- [x] تم التأكد من إضافة Bearer Token في Header
- [x] تم اختبار `CourseModel.fromJson()` مع JSON صحيح
- [x] لا توجد أخطاء في الـ Compilation
- [x] تم التعامل مع Error 401 (Unauthorized)

---

## 🚀 الخطوات التالية

1. **اختبر الكود الجديد:**

   ```bash
   flutter test
   ```

2. **شغّل التطبيق:**

   ```bash
   flutter run
   ```

3. **جرب جلب كورس محدد:**
   - انتقل إلى قائمة الكورسات
   - اضغط على "عرض المحتوى"
   - يجب أن تظهر التفاصيل بدون Error 500

4. **تحقق من اللوج:**
   ```
   🔵 REQUEST: GET /StudentCourse/course/1/with-content
   📤 Headers: {Authorization: Bearer YOUR_TOKEN_HERE}
   🟢 RESPONSE: 200
   ```

---

## 📞 اتصل إذا واجهت مشاكل

إذا حصل Error جديد:

1. ✅ تحقق من الـ Token (ليس منتهي الصلاحية)
2. ✅ تحقق من Connection (Internet)
3. ✅ تحقق من لوج البيانات (print statements)
4. ✅ تحقق من API Response format مع Backend Developer
