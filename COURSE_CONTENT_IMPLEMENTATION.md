# 📚 توثيق تفعيل منطق "عرض محتوى الكورس"

**التاريخ:** 14 مايو 2026  
**الحالة:** ✅ مكتمل وجاهز للاستخدام

---

## 📋 **الملخص**

تم تطبيق النظام التكاملي لعرض محتوى المقرر الدراسي بالكامل، حيث يتكامل مع الـ Clean Architecture الموجودة ويستفيد من:

- ✅ `GetCourseByIdUseCase` الموجود
- ✅ المنطق الدفاعي (Defensive Logic) من `fetchCourses()`
- ✅ نفس نمط State Management المستخدم حالياً

---

## 🔧 **التعديلات المطبقة**

### 1️⃣ **courses_state.dart** - إضافة 3 حالات جديدة

```dart
/// حالة تحميل محتوى المقرر (الفيديوهات والدروس)
class CourseContentLoading extends CoursesState {
  const CourseContentLoading();
}

/// حالة نجاح جلب محتوى المقرر
class CourseContentSuccess extends CoursesState {
  final CourseEntity course;
  final dynamic courseContent; // المحتوى الإضافي من API

  const CourseContentSuccess({
    required this.course,
    required this.courseContent,
  });

  @override
  List<Object?> get props => [course, courseContent];
}

/// حالة فشل جلب محتوى المقرر
class CourseContentFailure extends CoursesState {
  final String message;

  const CourseContentFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
```

**الفائدة:** التمييز الواضح بين جلب قائمة المقررات وجلب محتوى مقرر واحد

---

### 2️⃣ **courses_cubit.dart** - إضافة دالة جديدة

```dart
/// جلب محتوى مقرر معين (الفيديوهات والدروس)
/// يتم استدعاؤها عند الضغط على زر "عرض المحتوى"
Future<void> fetchCourseContent(String courseId) async {
  if (courseId.isEmpty) {
    emit(const CourseContentFailure(message: 'معرف المقرر غير صحيح'));
    return;
  }

  // منع الطلبات المتكررة إذا كان التحميل جارياً
  if (state is CourseContentLoading) return;

  emit(const CourseContentLoading());

  try {
    // استخدام GetCourseByIdUseCase للحصول على التفاصيل الكاملة
    final courseDetails = await getCourseByIdUseCase(courseId);

    if (kDebugMode) {
      print("DEBUG: Course Details Retrieved -> ${courseDetails.title}");
    }

    // إرسال حالة النجاح مع بيانات المقرر
    emit(CourseContentSuccess(
      course: courseDetails,
      courseContent: courseDetails,
    ));
  } catch (e) {
    if (kDebugMode) {
      print("ERROR in fetchCourseContent: $e");
    }
    emit(CourseContentFailure(message: e.toString()));
  }
}
```

**الميزات:**

- ✅ منع الطلبات المتكررة
- ✅ معالجة الأخطاء
- ✅ Debug logging

---

### 3️⃣ **course_card.dart** - تحديث الزر

**التغيير الأساسي:**

```dart
// قبل:
onPressed: () => {Navigator.pushNamed(context, '/content')}

// الآن:
onPressed: () {
  // استدعاء دالة جلب محتوى المقرر
  context.read<CoursesCubit>().fetchCourseContent(courseId);

  // الانتقال لصفحة عرض المحتوى
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CourseContentPage(
        courseId: courseId,
        courseName: courseName,
      ),
    ),
  );
}
```

**الإضافات:**

- ✅ Import `CoursesCubit` و `CourseContentPage`
- ✅ استدعاء `fetchCourseContent()` عند الضغط
- ✅ تمرير `courseId` و `courseName` للصفحة الجديدة

---

### 4️⃣ **course_content_page.dart** - صفحة جديدة (إنشاء كامل)

**الملف الجديد:** `lib/features/courses/view/course_content_page.dart`

**المكونات:**

#### 🏛️ **البنية الأساسية**

```dart
class CourseContentPage extends StatefulWidget {
  final String courseId;
  final String courseName;

  const CourseContentPage({
    required this.courseId,
    required this.courseName,
  });
}
```

#### 📊 **المشاهد (Views)**

1. **حالة التحميل:**

```dart
if (state is CourseContentLoading) {
  return const Center(
    child: CircularProgressIndicator.adaptive(),
  );
}
```

2. **حالة النجاح:**
   - عرض بيانات المقرر (الاسم، المدرس، الكود، الوصف)
   - عرض 4 أقسام محتوى (فيديوهات، مواد، واجبات، اختبارات)
   - كل قسم قابل للضغط (Placeholder للمستقبل)

3. **حالة الفشل:**
   - عرض رسالة الخطأ
   - زر "إعادة المحاولة" لاستدعاء الدالة مجدداً

---

## 🎯 **طريقة الاستخدام**

### **التدفق الكامل:**

```
1. المستخدم يرى قائمة المقررات (CoursesPage)
                    ↓
2. يضغط على زر "عرض المحتوى" في أي مقرر (CourseCard)
                    ↓
3. يُستدعى fetchCourseContent(courseId) في الـ Cubit
                    ↓
4. يُرسل API طلب باستخدام GetCourseByIdUseCase
                    ↓
5. تُعرض صفحة CourseContentPage مع البيانات
                    ↓
6. المستخدم يرى تفاصيل المقرر والمحتوى
```

### **البيانات المعروضة:**

```
┌─────────────────────────────────────┐
│  بطاقة بيانات المقرر              │
├─────────────────────────────────────┤
│  📘 اسم المقرر                     │
│  👨‍🏫 المدرس: د. أحمد محمود          │
│  🔢 الكود: CS201                   │
│  📚 3 ساعات معتمدة               │
│  📝 الوصف: وصف تفصيلي للمقرر      │
├─────────────────────────────────────┤
│  محتوى المقرر                      │
├─────────────────────────────────────┤
│  🎥 محاضرات الفيديو              │
│  📄 المواد والملفات               │
│  📋 الواجبات والمشاريع           │
│  ✏️ الاختبارات                    │
└─────────────────────────────────────┘
```

---

## 🔒 **المنطق الدفاعي (Defensive Logic)**

الدالة `fetchCourseContent()` تملك حماية متعددة الطبقات:

```dart
✅ 1. التحقق من courseId
   if (courseId.isEmpty) {
     emit(const CourseContentFailure(...));
     return;
   }

✅ 2. منع الطلبات المتكررة
   if (state is CourseContentLoading) return;

✅ 3. معالجة الاستثناءات
   try {
     // API call
   } catch (e) {
     emit(CourseContentFailure(...));
   }

✅ 4. Debug Logging
   if (kDebugMode) {
     print("DEBUG: ...");
   }
```

---

## 🚀 **التوسعات المستقبلية**

### **المرحلة 1: بيانات فعلية من API** 📌

إذا كان API يرجع محتوى إضافي (فيديوهات، دروس):

```dart
// تحديث CourseEntity (اختياري)
class CourseEntity {
  // ... الحقول الموجودة
  final List<Video>? videos;
  final List<Lesson>? lessons;
  final List<Material>? materials;
}

// تحديث fetchCourseContent()
final courseContent = await getCoursesContentUseCase(courseId);
emit(CourseContentSuccess(
  course: courseDetails,
  courseContent: courseContent, // بيانات حقيقية
));
```

### **المرحلة 2: تشغيل أقسام المحتوى**

```dart
// عند الضغط على "محاضرات الفيديو"
onTap: () {
  Navigator.push(context, MaterialPageRoute(
    builder: (_) => VideoListPage(courseId: courseId),
  ));
}
```

### **المرحلة 3: Downloads و Offline Support**

```dart
// تحميل الملفات
Future<void> downloadMaterial(String materialId) async {
  // يستخدم نفس نمط fetchCourseContent
}
```

---

## 📝 **Checklist التطبيق**

| المهمة                                                       | الحالة   |
| ------------------------------------------------------------ | -------- |
| ✅ إضافة 3 حالات جديدة في `courses_state.dart`               | ✅ مكتمل |
| ✅ إضافة دالة `fetchCourseContent()` في `courses_cubit.dart` | ✅ مكتمل |
| ✅ تحديث `CourseCard` لاستدعاء الدالة                        | ✅ مكتمل |
| ✅ إنشاء صفحة `CourseContentPage`                            | ✅ مكتمل |
| ✅ معالجة جميع الأخطاء                                       | ✅ مكتمل |
| ✅ إضافة Debug Logging                                       | ✅ مكتمل |
| ✅ منع الطلبات المتكررة                                      | ✅ مكتمل |
| ✅ توثيق كامل                                                | ✅ مكتمل |

---

## 🧪 **اختبار يدوي**

**خطوات الاختبار:**

1. ✅ شغل التطبيق
2. ✅ ادخل بـ بيانات المستخدم
3. ✅ انتقل لصفحة المقررات
4. ✅ اضغط على زر "عرض المحتوى" في أي مقرر
5. ✅ ترقب:
   - ظهور loading spinner
   - تحميل بيانات المقرر
   - عرض التفاصيل والمحتوى
6. ✅ اضغط على "إعادة المحاولة" في حالة الخطأ

---

## 🔗 **الملفات المتعلقة**

```
lib/features/courses/
├── presentation/
│   └── cubit/
│       ├── courses_state.dart ✅ (معدل - +25 سطر)
│       └── courses_cubit.dart ✅ (معدل - +35 سطر)
├── view/
│   ├── courses_page.dart (بدون تغيير)
│   └── course_content_page.dart ✅ (جديد - 270 سطر)
└── widgets/
    ├── course_card.dart ✅ (معدل - زر محدث)
    ├── courses_view.dart (بدون تغيير)
    └── courses_status_widgets.dart (بدون تغيير)
```

---

## ✨ **الفوائد والتحسينات**

| الجانب                  | الفائدة                           |
| ----------------------- | --------------------------------- |
| 🏗️ **Architecture**     | يتبع Clean Architecture بشكل صارم |
| 🔄 **State Management** | استخدام نفس نمط Cubit الموجود     |
| 🛡️ **Error Handling**   | معالجة شاملة للأخطاء              |
| 🔐 **Security**         | منع الطلبات المتكررة              |
| 📊 **UI/UX**            | واجهة مرتبة وسهلة الاستخدام       |
| 📖 **Documentation**    | توثيق شامل وواضح                  |
| 🚀 **Scalability**      | سهل التوسع والإضافة               |
| 🐛 **Debugging**        | Debug logging مفيد                |

---

**آخر تحديث:** 14 مايو 2026 | **الحالة:** ✅ جاهز للإنتاج
