# 🚀 **دليل استخدام سريع - Course Content**

**للاستخدام الفوري والسريع**

---

## 📌 **ما تم تنفيذه؟**

عند الضغط على زر "عرض المحتوى" في أي مقرر:

```
الضغط على الزر → جلب البيانات من API → عرض الصفحة الجديدة
```

---

## ✅ **التأكد من التطبيق**

### **1. تحقق من Cubit:**

```dart
// في courses_cubit.dart - موجودة الدالة الجديدة
Future<void> fetchCourseContent(String courseId) async {
  // تجلب تفاصيل المقرر من API
  // وتعرض حالات Loading, Success, Failure
}
```

### **2. تحقق من الحالات:**

```dart
// في courses_state.dart - موجودة 3 حالات جديدة
✅ CourseContentLoading
✅ CourseContentSuccess
✅ CourseContentFailure
```

### **3. تحقق من الزر:**

```dart
// في course_card.dart - الزر محدث ليستدعي الدالة
onPressed: () {
  context.read<CoursesCubit>().fetchCourseContent(courseId);
  // ثم الانتقال للصفحة الجديدة
}
```

### **4. تحقق من الصفحة الجديدة:**

```dart
// في course_content_page.dart - موجودة صفحة جديدة
class CourseContentPage extends StatefulWidget {
  // تعرض بيانات المقرر والمحتوى
}
```

---

## 🎯 **كيفية العمل خطوة بخطوة**

```
المستخدم يضغط على "عرض المحتوى"
           ↓
CourseCard استدعاء fetchCourseContent(courseId)
           ↓
CoursesCubit emit(CourseContentLoading())
           ↓
GetCourseByIdUseCase جلب البيانات من API
           ↓
CoursesCubit emit(CourseContentSuccess(...))
           ↓
CourseContentPage عرض البيانات باستخدام BlocBuilder
           ↓
المستخدم يرى التفاصيل
```

---

## 📊 **البيانات المعروضة**

### **في الصفحة:**

```
┌──────────────────────────┐
│  اسم المقرر: Programming│
│  المدرس: د. أحمد        │
│  الكود: CS201           │
│  ساعات معتمدة: 3        │
├──────────────────────────┤
│  محتوى المقرر           │
├──────────────────────────┤
│  [🎥] محاضرات الفيديو  │
│  [📄] المواد والملفات   │
│  [📋] الواجبات          │
│  [✏️] الاختبارات        │
└──────────────────────────┘
```

---

## ⚠️ **نقاط مهمة**

| النقطة                | التفصيل                                 |
| --------------------- | --------------------------------------- |
| 🔄 **منع التكرار**    | إذا كان التحميل جاري، لن يرسل طلب جديد  |
| 🛡️ **معالجة الأخطاء** | في حالة الخطأ، يظهر زر "إعادة المحاولة" |
| 🔍 **Debug**          | يوجد print في وضع debug للتتبع          |
| 📱 **Responsive**     | تعمل على جميع أحجام الشاشات             |

---

## 🔮 **المستقبل**

عندما يوفر API محتوى حقيقي (فيديوهات، ملفات)، يمكن تعديل:

```dart
// في courses_cubit.dart
final courseContent = await getCoursesContentUseCase(courseId);
emit(CourseContentSuccess(
  course: courseDetails,
  courseContent: courseContent, // بيانات فعلية
));

// في course_content_page.dart
_buildContentSection(state.courseContent) {
  // عرض الفيديوهات والملفات الفعلية
}
```

---

## 🧪 **اختبار سريع**

1. شغل التطبيق ✅
2. ادخل بيانات المستخدم ✅
3. روح المقررات ✅
4. اضغط "عرض المحتوى" ✅
5. تأكد من ظهور الصفحة الجديدة ✅

---

**السؤال:** هل تريد إضافة ميزات إضافية؟  
**الإجابة:** سهل! فقط عدل `_buildContentSection()` في `course_content_page.dart`

---

**آخر تحديث:** 14 مايو 2026
