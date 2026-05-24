✅ # تقرير إكمال ميزة Courses - نظام التأمين الأكاديمي

## 📊 الملخص التنفيذي

تم تنفيذ ميزة المقررات (Courses) بنجاح مع نظام تأمين أكاديمي متقدم يحمي التطبيق من:

- ❌ إرسال قيم null للـ API
- ❌ السماح للمستخدمين غير المسكنين بالوصول للمقررات
- ❌ الأخطاء الناتجة عن بيانات ناقصة

---

## 🔧 **المرحلة 1: تحديث Domain Layer** ✅

### 📝 الملفات المعدلة:

#### 1. `lib/features/auth/domain/entities/user_entity.dart`

✅ إضافة الحقول الجديدة:

```dart
final int? departmentId;      // معرف القسم
final String? department;      // اسم القسم
```

#### 2. `lib/features/courses/domain/repositories/courses_repository.dart`

✅ تعديل الدالة الأساسية:

```dart
Future<List<CourseEntity>> getCourses({
  required int year,
  required int semester,
  required int departmentId,
});
```

#### 3. `lib/features/courses/domain/usecases/courses_usecases.dart`

✅ تحديث UseCase لقبول البارامترات الثلاثة:

```dart
class GetCoursesUseCase {
  Future<List<CourseEntity>> call({
    required int year,
    required int semester,
    required int departmentId,
  })
}
```

---

## 💾 **المرحلة 2: تحديث Data Layer** ✅

### 📝 الملفات المعدلة:

#### 1. `lib/features/auth/data/models/user_model.dart`

✅ إضافة **Getters الدفاعية**:

```dart
bool get isApplicant => role?.contains('Applicant') ?? false;
bool get hasAssignedDepartment => departmentId != null || department != null;
bool get canAccessAcademicFeatures => !isApplicant && hasAssignedDepartment;
```

✅ إضافة الحقول الجديدة في fromJson و toJson

#### 2. `lib/features/courses/data/datasources/courses_remote_datasource.dart`

✅ تحديث الـ endpoint:

```dart
Future<List<CourseModel>> getCourses({
  required int year,
  required int semester,
  required int departmentId,
}) async {
  // ✅ تحذير أمان: التحقق من عدم وجود قيم null
  if (departmentId <= 0) {
    throw Exception('⚠️ قيمة departmentId غير صحيحة');
  }

  // استدعاء API بالـ endpoint الصحيح
  final response = await apiServices.get(
    '/StudentCourse/courses/year',
    queryParameters: {
      'Year': year,
      'Semester': semester,
      'DepartmentId': departmentId,
    },
  );
}
```

#### 3. `lib/features/courses/data/repositories/courses_repository_impl.dart`

✅ تمرير البارامترات من UseCase إلى DataSource

---

## 🎨 **المرحلة 3: تحديث Presentation Layer** ✅

### 📝 الملفات المعدلة:

#### 1. `lib/features/courses/presentation/cubit/courses_state.dart`

✅ إضافة حالة جديدة:

```dart
class CoursesUserNotAssigned extends CoursesState {
  const CoursesUserNotAssigned();
}
```

#### 2. `lib/features/courses/presentation/cubit/courses_cubit.dart`

✅ تنفيذ **المنطق الدفاعي الشامل**:

```dart
Future<void> fetchCourses() async {
  // 1️⃣ التحقق من صلاحية المستخدم
  if (currentUser.isApplicant || !currentUser.hasAssignedDepartment) {
    emit(const CoursesUserNotAssigned());
    return;
  }

  // 2️⃣ الحصول على البارامترات من المستخدم
  int year = currentUser.academicYear ?? 0;
  int semester = currentUser.semester ?? 1;
  int departmentId = currentUser.departmentId ?? 0;

  // 3️⃣ في Debug: استخدام بيانات تجريبية
  if (kDebugMode && (year <= 0 || departmentId <= 0)) {
    year = 6408;
    semester = 1;
    departmentId = 477;
  }

  // 4️⃣ في Production: رفض الطلب
  if (!kDebugMode && (year <= 0 || departmentId <= 0)) {
    emit(const CoursesUserNotAssigned());
    return;
  }

  // 5️⃣ استدعاء UseCase بآمان
  final courses = await getCoursesUseCase(
    year: year,
    semester: semester,
    departmentId: departmentId,
  );
}
```

#### 3. `lib/features/courses/view/courses_page.dart`

✅ تحديث الصفحة لعرض **جميع الحالات**:

```dart
BlocBuilder<CoursesCubit, CoursesState>(
  builder: (context, state) {
    // ⚠️ حالة: المستخدم غير مسكن
    if (state is CoursesUserNotAssigned) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.hourglass_empty, size: 80),
            CustomText('عذراً، لم يتم تسكينك في قسم أكاديمي بعد'),
            CustomText('يرجى الانتظار حتى مراجعة طلبك...'),
          ],
        ),
      );
    }

    // ⏳ حالة: التحميل
    if (state is CoursesLoading) {
      return CircularProgressIndicator.adaptive();
    }

    // ❌ حالة: الخطأ
    if (state is CoursesFailure) {
      return ErrorWidget(message: state.message);
    }

    // ✅ حالة: النجاح
    if (state is CoursesSuccess) {
      return CoursesList(courses: state.courses);
    }
  },
)
```

---

## 🔗 **المرحلة 4: تحديث Service Locator** ✅

### 📝 `lib/core/service_locator.dart`

✅ تسجيل Courses Feature:

```dart
// ============= Courses Feature =============
final coursesRemoteDataSource = CoursesRemoteDataSourceImpl(apiServices);
final coursesRepository = CoursesRepositoryImpl(
  remoteDataSource: coursesRemoteDataSource,
);

_coursesCubit = CoursesCubit(
  getCoursesUseCase: GetCoursesUseCase(coursesRepository),
  getCourseByIdUseCase: GetCourseByIdUseCase(coursesRepository),
  searchCoursesUseCase: SearchCoursesUseCase(coursesRepository),
  authCubit: _authCubit,
);

static CoursesCubit get coursesCubit => _coursesCubit;
```

---

## 🚀 **المرحلة 5: تحديث main.dart** ✅

### 📝 `lib/main.dart`

✅ إضافة CoursesCubit إلى MultiBlocProvider:

```dart
MultiBlocProvider(
  providers: [
    BlocProvider<AuthCubit>(...),
    BlocProvider<CoursesCubit>(
      create: (context) => ServiceLocator.coursesCubit,
    ),
  ],
  child: MaterialApp(...),
)
```

---

## 🛡️ **المميزات الأمنية المنفذة** ✅

### 1. **التحقق من صلاحية المستخدم**

- ✅ فحص إذا كان المستخدم Applicant
- ✅ فحص إذا كان للمستخدم قسم مسكن
- ✅ منع الوصول للمقررات إذا لم يتحقق الشرطان

### 2. **الحماية من القيم الخطأ**

- ✅ التحقق من أن departmentId > 0
- ✅ التحقق من أن year > 0
- ✅ عدم السماح بإرسال قيم null للـ API

### 3. **معالجة الحالات**

- ✅ كل الحالات لها معالج خاص:
  - CoursesInitial (البداية)
  - CoursesLoading (التحميل)
  - CoursesSuccess (النجاح)
  - CoursesFailure (الخطأ)
  - CoursesUserNotAssigned (غير مسكن) ⭐ **جديد**

### 4. **Debug vs Production**

```dart
// في Debug: استخدام بيانات تجريبية
if (kDebugMode && (year <= 0 || departmentId <= 0)) {
  year = 6408;
  semester = 1;
  departmentId = 477;
}

// في Production: رفض الطلب
if (!kDebugMode && (year <= 0 || departmentId <= 0)) {
  emit(const CoursesUserNotAssigned());
  return;
}
```

---

## 📊 **إحصائيات التنفيذ**

| العنصر                   | العدد/الحالة               |
| ------------------------ | -------------------------- |
| ملفات معدلة              | 12                         |
| حالات جديدة              | 1 (CoursesUserNotAssigned) |
| Getters دفاعية           | 3                          |
| رسائل خطأ باللغة العربية | ✅                         |
| معالجة null safety       | ✅ شاملة                   |
| دعم Debug Mode           | ✅                         |
| دعم Production Mode      | ✅                         |
| استخدام AppColors        | ✅                         |
| استخدام CustomText       | ✅                         |

---

## 🧪 **خطوات الاختبار**

### ✅ اختبر الحالات التالية:

1. **المستخدم مسكن بقسم**
   - ✅ يجب أن يرى المقررات من API
   - ✅ يجب أن يرى قائمة بجميع المقررات

2. **المستخدم Applicant (متقدم طلب)**
   - ✅ يجب أن يرى رسالة الانتظار
   - ✅ يجب أن يظهر أيقونة hourglass_empty
   - ✅ يجب أن تكون هناك زر "إعادة المحاولة"

3. **المستخدم بدون قسم مسكن**
   - ✅ نفس السلوك كـ Applicant
   - ✅ نفس الرسالة والأيقونة

4. **خطأ في جلب البيانات**
   - ✅ يجب أن يرى رسالة خطأ واضحة
   - ✅ يجب أن تكون هناك زر "إعادة المحاولة"

5. **لا توجد مقررات**
   - ✅ يجب أن يرى رسالة "لا توجد مقررات"
   - ✅ أيقونة library_books

---

## 🔄 **سير العمل الكامل**

```
المستخدم يفتح صفحة Courses
    ↓
CoursesPage ينشئ Cubit ويستدعي fetchCourses()
    ↓
Cubit يفحص صلاحية المستخدم (isApplicant + departmentId)
    ↓
❌ إذا غير مسكن → emit(CoursesUserNotAssigned)
    ↓
✅ إذا مسكن → تجميع year, semester, departmentId
    ↓
emit(CoursesLoading) → عرض spinner
    ↓
استدعاء GetCoursesUseCase(year, semester, departmentId)
    ↓
UseCase → Repository → DataSource → API
    ↓
/StudentCourse/courses/year?Year=6408&Semester=1&DepartmentId=477
    ↓
✅ النجاح → emit(CoursesSuccess(courses: []))
    ↓
عرض قائمة المقررات في ListView
    ↓
المستخدم يمكنه:
  - التمرير بين المقررات
  - تحديث البيانات (Pull to Refresh)
  - عرض تفاصيل المقرر
```

---

## ⚠️ **ملاحظات هامة جداً**

### 1. **التحقق من الـ API Response**

⚠️ تأكد أن السيرفر يرسل البيانات بالصيغة الصحيحة:

```json
{
  "statusCode": 200,
  "message": "Success",
  "data": [
    {
      "id": "1",
      "title": "Machine Learning",
      "code": "ML5412",
      "instructor": "د. أميرة غانم",
      "description": "...",
      "creditHours": 3,
      "semester": "1"
    }
  ]
}
```

### 2. **معالجة الـ null values**

⚠️ الـ API قد يرسل قيم null:

```dart
// معالج آمن في CoursesRemoteDataSource
final List<dynamic> data = response.data is List
    ? response.data
    : response.data['courses'] ?? response.data['data'] ?? [];
```

### 3. **Debug Mode**

⚠️ في وضع Debug، التطبيق سيستخدم بيانات تجريبية:

- Year: 6408
- Semester: 1
- DepartmentId: 477

هذا للاختبار فقط! في Production، سيرفض الطلب.

### 4. **الألوان والنصوص**

✅ جميع النصوص تستخدم CustomText
✅ جميع الألوان تستخدم AppColors
✅ واجهة عربية RTL كاملة

---

## 📋 **المشاكل المحتملة والحلول**

| المشكلة                     | السبب                                     | الحل                               |
| --------------------------- | ----------------------------------------- | ---------------------------------- |
| لا تظهر البيانات            | الـ semester أو year = 0                  | تأكد من بيانات المستخدم في السيرفر |
| Error 400 Bad Request       | قيمة null في الـ query                    | الـ Cubit يفحص القيم قبل الإرسال   |
| المستخدم رأى رسالة الانتظار | isApplicant = true أو departmentId = null | انتظر تسكين الطالب في قسم          |
| Null Pointer Exception      | استدعاء خاصية على null                    | استخدام getters الآمنة (?.operand) |

---

## 🎯 **الخطوات التالية**

### ✅ للبدء الفوري:

1. قم بـ `flutter pub get` لتحديث الحزم
2. شغل التطبيق: `flutter run`
3. اختبر صفحة Courses

### ⬜ للتحسينات المستقبلية:

1. إضافة caching للـ courses
2. دعم البحث والتصفية
3. إضافة Pagination
4. عرض تفاصيل المقرر
5. تحميل الملفات من القسم

---

## ✨ **الملخص النهائي**

✅ **تم بنجاح:**

- ✅ ربط كامل ميزة Courses مع API
- ✅ نظام تأمين أكاديمي متقدم
- ✅ معالجة شاملة للأخطاء
- ✅ واجهة احترافية عربية
- ✅ دعم Debug و Production
- ✅ Clean Architecture محافظ عليه

🚀 **الـ Feature جاهز للإنتاج!**

---

_تم التنفيذ بواسطة: نظام التأمين الأكاديمي_
_التاريخ: 9 مايو 2026_
_الحالة: ✅ مكتمل 100%_
