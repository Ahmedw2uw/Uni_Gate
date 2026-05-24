# 🗺️ **خريطة الملفات - Course Content System**

**النظام المتكامل لعرض محتوى المقرر الدراسي**

---

## 📁 **البنية الكاملة**

```
lib/features/courses/
│
├── 📂 domain/
│   ├── entities/
│   │   └── course_entity.dart
│   ├── repositories/
│   │   └── courses_repository.dart (abstract)
│   └── usecases/
│       └── courses_usecases.dart
│           ├── GetCoursesUseCase
│           ├── GetCourseByIdUseCase ← 🎯 يُستخدم في fetchCourseContent
│           └── SearchCoursesUseCase
│
├── 📂 data/
│   ├── datasources/
│   │   ├── courses_remote_datasource.dart
│   │   └── courses_local_datasource.dart
│   ├── models/
│   │   └── course_model.dart
│   └── repositories/
│       └── courses_repository_impl.dart
│
├── 📂 presentation/
│   └── cubit/ ✅ معدل
│       ├── courses_cubit.dart ✅ (+fetchCourseContent)
│       └── courses_state.dart ✅ (+3 states)
│
├── 📂 view/ ✅ مضاف
│   ├── courses_page.dart
│   └── course_content_page.dart ✅ جديد 270 سطر
│
└── 📂 widgets/ ✅ معدل جزئياً
    ├── course_card.dart ✅ (زر محدث)
    ├── courses_view.dart
    └── courses_status_widgets.dart
```

---

## 🔗 **التدفق الكامل للنظام**

```
┌─────────────────────────────────────────────────┐
│         UI LAYER - واجهة المستخدم              │
├─────────────────────────────────────────────────┤
│  CoursesPage                                    │
│  └─ CoursesView                                │
│     └─ CourseCard ✅ [زر "عرض المحتوى"]        │
│        └─ عند الضغط:                          │
│           1. fetchCourseContent(courseId)     │
│           2. Navigator.push() → ContentPage   │
│           └─ course_content_page.dart ✅      │
│              └─ BlocBuilder<CoursesState>     │
│                 ├─ Loading: Spinner           │
│                 ├─ Success: بيانات المقرر     │
│                 └─ Failure: رسالة خطأ        │
│                                               │
├─────────────────────────────────────────────────┤
│    PRESENTATION LAYER - إدارة الحالة         │
├─────────────────────────────────────────────────┤
│  CoursesCubit ✅                               │
│  ├─ fetchCourses()       ← جلب القائمة        │
│  ├─ searchCourses()      ← البحث              │
│  └─ fetchCourseContent() ✅ ← جلب المحتوى    │
│     └─ emit states:                           │
│        ├─ CourseContentLoading ✅            │
│        ├─ CourseContentSuccess ✅            │
│        └─ CourseContentFailure ✅            │
│                                               │
├─────────────────────────────────────────────────┤
│      DOMAIN LAYER - منطق الأعمال              │
├─────────────────────────────────────────────────┤
│  GetCourseByIdUseCase ✅                       │
│  └─ repository.getCourseById(courseId)        │
│     └─ Returns: CourseEntity                  │
│                                               │
├─────────────────────────────────────────────────┤
│      DATA LAYER - تخزين البيانات              │
├─────────────────────────────────────────────────┤
│  CoursesRepository                            │
│  └─ CoursesRepositoryImpl                      │
│     ├─ Remote: CoursesRemoteDataSource        │
│     │  └─ API Call: GET /CourseById/{id}     │
│     └─ Local: CoursesLocalDataSource          │
│        └─ Cache handling                      │
│                                               │
├─────────────────────────────────────────────────┤
│      NETWORK LAYER - التواصل مع السيرفر      │
├─────────────────────────────────────────────────┤
│  Dio Client + Interceptors                    │
│  └─ API Response:                             │
│     {                                         │
│       "id": "CS201",                         │
│       "title": "Programming",                │
│       "instructor": "Dr. Ahmed",             │
│       "code": "CS201",                       │
│       "creditHours": 3,                      │
│       "description": "..."                   │
│     }                                        │
└─────────────────────────────────────────────────┘
```

---

## 🎯 **المكونات الرئيسية**

### **1. Cubit - إدارة الحالة**

```dart
CoursesCubit {
  GetCoursesUseCase getCoursesUseCase;
  GetCourseByIdUseCase getCourseByIdUseCase; ← 🔑
  SearchCoursesUseCase searchCoursesUseCase;
  AuthCubit authCubit;

  // الدوال:
  - fetchCourses()         // جلب القائمة
  - searchCourses()        // البحث
  - fetchCourseContent()   // 🆕 جلب محتوى مقرر
}
```

### **2. States - حالات الـ UI**

```dart
CoursesState {
  ├─ CoursesInitial          // حالة ابتدائية
  ├─ CoursesLoading          // تحميل القائمة
  ├─ CoursesSuccess          // نجاح جلب القائمة
  ├─ CoursesFailure          // فشل جلب القائمة
  ├─ CoursesUserNotAssigned  // مستخدم غير مسكن
  ├─ CourseDetailsState      // تفاصيل مقرر
  ├─ CourseContentLoading    // 🆕 تحميل محتوى
  ├─ CourseContentSuccess    // 🆕 نجاح محتوى
  └─ CourseContentFailure    // 🆕 فشل محتوى
}
```

### **3. Pages - صفحات التطبيق**

```dart
CoursesPage
├─ CoursesView
│  └─ ListView<CourseCard>
│     └─ عند الضغط: fetchCourseContent()
│        └─ Navigator.push()
│           └─ CourseContentPage 🆕
│              └─ BlocBuilder<CoursesState>
│                 ├─ _buildCourseInfoCard()
│                 ├─ _buildContentSection()
│                 └─ _buildContentItem()
```

---

## 🔄 **سير العمل (Workflow)**

### **السيناريو: المستخدم يضغط على مقرر**

```
بداية:
└─ CoursesPage → CoursesView → CourseCard [زر "عرض المحتوى"]

الضغط على الزر:
├─ 1. context.read<CoursesCubit>().fetchCourseContent(courseId)
├─ 2. Cubit emits: CourseContentLoading()
├─ 3. API Call: GET /CourseById/{courseId}
├─ 4. GetCourseByIdUseCase.call(courseId)
├─ 5. CoursesRepository.getCourseById(courseId)
├─ 6. CoursesRemoteDataSource.getCourseById(courseId)
├─ 7. Response from API
└─ 8. Cubit emits: CourseContentSuccess(course, content)

النتيجة:
├─ Navigator.push() → CourseContentPage
├─ BlocBuilder rebuilds with CourseContentSuccess
├─ _buildCourseInfoCard(course)
├─ _buildContentSection(content)
└─ UI يعرض البيانات

حالة الخطأ:
├─ if (exception) → Cubit emits: CourseContentFailure(message)
├─ BlocBuilder rebuilds with failure state
├─ يعرض رسالة الخطأ
└─ زر "إعادة المحاولة" يستدعي fetchCourseContent() مرة أخرى
```

---

## 📊 **البيانات التي تمر في النظام**

```
1. Input: courseId (String)
   ↓
2. Validation: if (courseId.isEmpty) → error
   ↓
3. API Request:
   GET /StudentCourse/courseDetails/{courseId}
   Headers: Authorization: Bearer {token}
   ↓
4. API Response:
   {
     "id": "1",
     "name": "البرمجة",
     "title": "Introduction to Programming",
     "description": "...",
     "instructor": "Dr. Ahmed",
     "code": "CS201",
     "creditHours": 3,
     "semester": "1"
   }
   ↓
5. Model Conversion:
   JSON → CourseModel → CourseEntity
   ↓
6. State Emission:
   CourseContentSuccess(
     course: courseEntity,
     courseContent: courseEntity
   )
   ↓
7. UI Rendering:
   BlocBuilder gets state
   → calls _buildCourseInfoCard()
   → displays data
```

---

## 🛡️ **طبقات الحماية (Defensive Layers)**

```
Layer 1: Input Validation
└─ if (courseId.isEmpty) → Error

Layer 2: Duplicate Request Prevention
└─ if (state is CourseContentLoading) → return

Layer 3: Error Handling
└─ try-catch block with proper error messages

Layer 4: UI Fallback
└─ CourseContentFailure state with retry button

Layer 5: Debug Logging
└─ print() in kDebugMode
```

---

## 🚀 **الأداء والتحسينات**

| الميزة                  | التطبيق                             |
| ----------------------- | ----------------------------------- |
| **Caching**             | LocalDataSource يمكن تحسينها لاحقاً |
| **Pagination**          | في الخطوات المستقبلية               |
| **Offline Support**     | يمكن إضافته لاحقاً                  |
| **Image Loading**       | يمكن إضافة lazy loading             |
| **Search Optimization** | البحث مُحسّن بالفعل                 |

---

## 📝 **ملفات التوثيق**

| الملف                              | الوصف                 |
| ---------------------------------- | --------------------- |
| `COURSE_CONTENT_IMPLEMENTATION.md` | توثيق شامل (400 سطر)  |
| `QUICK_START_COURSE_CONTENT.md`    | دليل سريع (100 سطر)   |
| `CHANGES_SUMMARY.md`               | ملخص التغييرات        |
| هذا الملف                          | خريطة الملفات والنظام |

---

## 🔗 **العلاقات بين الملفات**

```
course_card.dart
├─ imports CoursesCubit ✅
├─ imports CourseContentPage ✅
└─ on button press:
   ├─ calls: context.read<CoursesCubit>().fetchCourseContent(id)
   └─ navigates: Navigator.push(CourseContentPage)

course_content_page.dart
├─ imports CoursesState
├─ uses: BlocBuilder<CoursesCubit, CoursesState>
└─ listens to:
   ├─ CourseContentLoading
   ├─ CourseContentSuccess
   └─ CourseContentFailure

courses_cubit.dart
├─ has: fetchCourseContent(courseId)
└─ emits:
   ├─ CourseContentLoading
   ├─ CourseContentSuccess
   └─ CourseContentFailure

courses_state.dart
├─ defines CourseContentLoading
├─ defines CourseContentSuccess
└─ defines CourseContentFailure
```

---

## ✨ **الخصائص الرئيسية**

```
✅ Clean Architecture:
   Domain → Data → Presentation

✅ State Management:
   Cubit + States pattern

✅ Error Handling:
   Try-catch + proper error states

✅ UI/UX:
   BlocBuilder + responsive design

✅ Performance:
   Prevents duplicate requests

✅ Debugging:
   Debug logging with kDebugMode

✅ Scalability:
   Easy to extend with more features

✅ Testing:
   Each layer can be tested independently
```

---

## 🎓 **الدروس المستفادة**

1. **استخدام GetCourseByIdUseCase الموجود** ✅
2. **إنشاء حالات منفصلة للمحتوى** ✅
3. **معالجة الأخطاء بشكل شامل** ✅
4. **منع الطلبات المتكررة** ✅
5. **تصميم صفحة محتوى قابلة للتوسع** ✅

---

**آخر تحديث:** 14 مايو 2026  
**الحالة:** ✅ مكتمل وجاهز للإنتاج
