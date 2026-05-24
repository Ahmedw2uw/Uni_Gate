# 📚 Nuigate - Clean Architecture Documentation

## 🏗️ معمارية المشروع

تم تحويل المشروع من مجرد UI screens إلى **Clean Architecture** مع **Bloc/Cubit** لإدارة الحالة.

---

## 📁 هيكل المجلدات (Feature-based)

```
lib/
├── core/
│   ├── app_colors.dart          # الألوان
│   ├── app_strings.dart         # النصوص
│   ├── constants/               # الثوابت
│   └── service_locator.dart     # Dependency Injection
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_remote_datasource.dart   (API calls)
│   │   │   │   └── auth_local_datasource.dart    (SharedPreferences)
│   │   │   ├── models/
│   │   │   │   └── user_model.dart               (extends UserEntity)
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart     (implements repository)
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart          (abstract)
│   │   │   └── usecases/
│   │   │       └── auth_usecases.dart
│   │   │
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── auth_cubit.dart
│   │       │   └── auth_state.dart
│   │       ├── pages/
│   │       │   └── login_page.dart               (updated with Cubit)
│   │       └── widgets/
│   │
│   ├── courses/                 (نفس البنية)
│   ├── schedule/                (نفس البنية)
│   ├── exams/                   (نفس البنية)
│   └── ... (features أخرى)
│
├── network/
│   └── api_services.dart        (Dio implementation)
│
├── shared/
│   └── widgets/
│
├── utils/
│   ├── helpers.dart
│   └── validator.dart
│
└── main.dart                    (Entry point with BlocProvider)
```

---

## 🔄 Data Flow (Clean Architecture)

```
UI (Pages/Widgets)
    ↓
Presentation (Cubit) ← مسؤول عن الحالة والـ logic
    ↓
Domain (UseCases) ← العمليات والحالات
    ↓
Data (Repositories) ← التوازن بين local و remote
    ↓ ↓
Remote (API)  Local (SharedPreferences)
```

---

## 🎯 مثال: كيفية عمل تسجيل الدخول

### 1️⃣ **من صفحة البداية** (LoginPage)

```dart
// المستخدم يضغط على زر تسجيل الدخول
context.read<AuthCubit>().login(
  email: "student@university.com",
  password: "password123",
);
```

### 2️⃣ **في Cubit** (AuthCubit)

```dart
// يصدر حالة Loading
emit(const AuthLoading());

// يستدعي UseCase
final user = await loginUseCase(email: email, password: password);

// يصدر حالة Success مع بيانات المستخدم
emit(AuthSuccess(user: user));
```

### 3️⃣ **في UseCase** (LoginUseCase)

```dart
// يستدعي Repository
return repository.login(email: email, password: password);
```

### 4️⃣ **في Repository** (AuthRepositoryImpl)

```dart
// يستدعي Remote DataSource (API)
final userModel = await remoteDataSource.login(...);

// يحفظ البيانات محلياً
await localDataSource.saveUser(userModel);

// يرجع UserEntity
return userModel;
```

### 5️⃣ **في Remote DataSource**

```dart
// يستدعي API باستخدام Dio
final response = await apiServices.post(
  '/auth/login',
  data: {'email': email, 'password': password},
);

// يحول الـ JSON إلى Model
return UserModel.fromJson(response.data);
```

### 6️⃣ **النتيجة تعود للـ UI** (LoginPage)

```dart
BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state is AuthSuccess) {
      // التنقل إلى الداشبورد
      Navigator.pushReplacementNamed(context, '/');
    }
  },
)
```

---

## 🔑 الحالات المختلفة (AuthState)

```dart
// الحالة الأولية
AuthInitial() → الصفحة غير مُحملة بعد

// جاري التحميل
AuthLoading() → إظهار Spinner، تعطيل الأزرار

// نجاح تسجيل الدخول
AuthSuccess(user) → التنقل إلى الداشبورد

// فشل تسجيل الدخول
AuthFailure(message) → عرض رسالة خطأ

// تم تسجيل الخروج
AuthLoggedOut() → العودة إلى صفحة Login

// المصادقة
Authenticated(user) → المستخدم مصرح

// عدم المصادقة
Unauthenticated() → المستخدم غير مصرح
```

---

## 📡 API Configuration

تحديث عنوان API في: `lib/network/api_services.dart`

```dart
class ApiConfig {
  static const String baseUrl = 'https://api.example.com/v1';
}
```

**الـ Endpoints المتوقعة:**

- `POST /auth/login` → تسجيل دخول
- `GET /auth/me` → بيانات المستخدم الحالي
- `POST /auth/register` → تسجيل حساب جديد

---

## 💾 Token Storage

التوكن يُحفظ تلقائياً في `SharedPreferences`:

```dart
// حفظ التوكن
await localDataSource.saveToken(token);

// الحصول على التوكن
final token = await localDataSource.getToken();

// مسح التوكن عند تسجيل الخروج
await localDataSource.clearUser();
```

---

## ➕ إضافة Feature جديد (مثال: Courses)

### Step 1: إنشاء الـ Entity

```dart
// lib/features/courses/domain/entities/course_entity.dart
class CourseEntity {
  final String id;
  final String title;
  final String description;
  final String instructor;
  // ...
}
```

### Step 2: إنشاء الـ Model

```dart
// lib/features/courses/data/models/course_model.dart
class CourseModel extends CourseEntity {
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(...);
  }
}
```

### Step 3: إنشاء DataSources

```dart
// lib/features/courses/data/datasources/course_remote_datasource.dart
abstract class CourseRemoteDataSource {
  Future<List<CourseModel>> getCourses();
}
```

### Step 4: إنشاء Repository

```dart
// lib/features/courses/domain/repositories/course_repository.dart
abstract class CourseRepository {
  Future<List<CourseEntity>> getCourses();
}

// lib/features/courses/data/repositories/course_repository_impl.dart
class CourseRepositoryImpl implements CourseRepository {
  // ...
}
```

### Step 5: إنشاء UseCase

```dart
// lib/features/courses/domain/usecases/get_courses_usecase.dart
class GetCoursesUseCase {
  final CourseRepository repository;

  Future<List<CourseEntity>> call() {
    return repository.getCourses();
  }
}
```

### Step 6: إنشاء Cubit

```dart
// lib/features/courses/presentation/cubit/courses_cubit.dart
class CoursesCubit extends Cubit<CoursesState> {
  final GetCoursesUseCase getCoursesUseCase;

  Future<void> loadCourses() async {
    emit(CoursesLoading());
    try {
      final courses = await getCoursesUseCase();
      emit(CoursesSuccess(courses: courses));
    } catch (e) {
      emit(CoursesFailure(message: e.toString()));
    }
  }
}
```

### Step 7: ربط الـ Page مع Cubit

```dart
// lib/features/courses/presentation/pages/courses_page.dart
@override
Widget build(BuildContext context) {
  return BlocBuilder<CoursesCubit, CoursesState>(
    builder: (context, state) {
      if (state is CoursesLoading) {
        return Center(child: CircularProgressIndicator());
      }
      if (state is CoursesSuccess) {
        return ListView(...);
      }
      return SizedBox();
    },
  );
}
```

### Step 8: تسجيل الـ Cubit في ServiceLocator

```dart
// lib/core/service_locator.dart
// في دالة init()
_coursesCubit = CoursesCubit(
  getCoursesUseCase: GetCoursesUseCase(courseRepository),
);
```

### Step 9: إضافة BlocProvider في main.dart

```dart
MultiBlocProvider(
  providers: [
    BlocProvider<AuthCubit>(...),
    BlocProvider<CoursesCubit>(...), // إضافة جديد
  ],
)
```

---

## 🧪 Testing

### Unit Test Example (UseCase)

```dart
void main() {
  group('LoginUseCase', () {
    late MockAuthRepository mockRepository;
    late LoginUseCase loginUseCase;

    setUp(() {
      mockRepository = MockAuthRepository();
      loginUseCase = LoginUseCase(mockRepository);
    });

    test('should return UserEntity when login succeeds', () async {
      // Arrange
      const tEmail = 'test@test.com';
      const tPassword = 'password';
      final tUser = UserEntity(id: '1', name: 'Test', email: tEmail);

      when(mockRepository.login(email: tEmail, password: tPassword))
          .thenAnswer((_) async => tUser);

      // Act
      final result = await loginUseCase(
        email: tEmail,
        password: tPassword,
      );

      // Assert
      expect(result, tUser);
      verify(mockRepository.login(email: tEmail, password: tPassword));
    });
  });
}
```

---

## 📝 Best Practices المتبعة

✅ **Single Responsibility** - كل layer له دور واحد
✅ **Dependency Injection** - استخدام ServiceLocator
✅ **Immutability** - الـ Entities والـ States ثابتة
✅ **Error Handling** - معالجة منظمة للأخطاء
✅ **Separation of Concerns** - فصل الـ UI عن Logic
✅ **Reusability** - كود قابل لإعادة الاستخدام

---

## 🔗 روابط مفيدة

- [Flutter Bloc Documentation](https://bloclibrary.dev)
- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Dio Package](https://pub.dev/packages/dio)
- [SharedPreferences](https://pub.dev/packages/shared_preferences)

---

## ❓ الأسئلة الشائعة

### س: كيف أضيف validation للـ Email؟

**ج:** في `LoginPage`، تم إضافة `_isValidEmail()` بالفعل

### س: كيف أتعامل مع Server Errors؟

**ج:** في `RemoteDataSource`، استخدم `try-catch` وأرجع رسالة واضحة

### س: هل يمكن تعديل UI؟

**ج:** نعم! كل الـ Presentation layer قابل للتعديل دون التأثير على Logic

### س: كيف أختبر الـ Cubit؟

**ج:** استخدم `BlocTest` package وامثلة Unit Tests أعلاه

---

## 🚀 ملخص الخطوات التالية

1. ✅ تحديث `pubspec.yaml` مع الـ dependencies
2. ✅ إنشاء Domain Layer (Entities, Repositories, UseCases)
3. ✅ إنشاء Data Layer (Models, DataSources, RepositoryImpl)
4. ✅ إنشاء Presentation Layer (Cubit, States)
5. ✅ تحديث API Services مع Dio
6. ✅ إعداد ServiceLocator
7. ✅ ربط Login Page مع Cubit
8. ✅ تطبيق نفس النمط على الـ Features الأخرى

---

**هذا المشروع جاهز للإنتاج والتطوير المستقبلي! 🎉**
