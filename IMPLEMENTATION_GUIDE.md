# 🚀 دليل إضافة Features جديدة

## 📋 Checklist لإضافة feature جديد

لإضافة feature جديد (مثل Schedule, Exams, Profile، إلخ)، اتبع هذه الخطوات بنفس الترتيب:

---

## ✅ Step-by-Step

### 1️⃣ **Domain Layer**

#### إنشاء Entity

```bash
lib/features/[feature_name]/domain/entities/[feature]_entity.dart
```

**مثال:**

```dart
class ScheduleEntity extends Equatable {
  final String id;
  final String courseTitle;
  final String day;
  final String startTime;
  final String endTime;
  final String location;

  const ScheduleEntity({...});
}
```

#### إنشاء Repository (Abstract)

```bash
lib/features/[feature_name]/domain/repositories/[feature]_repository.dart
```

**مثال:**

```dart
abstract class ScheduleRepository {
  Future<List<ScheduleEntity>> getSchedule();
  Future<ScheduleEntity> getScheduleById(String id);
}
```

#### إنشاء UseCase(s)

```bash
lib/features/[feature_name]/domain/usecases/[feature]_usecases.dart
```

---

### 2️⃣ **Data Layer**

#### إنشاء Model

```bash
lib/features/[feature_name]/data/models/[feature]_model.dart
```

**مثال:**

```dart
class ScheduleModel extends ScheduleEntity {
  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(...);
  }
}
```

#### إنشاء Remote DataSource

```bash
lib/features/[feature_name]/data/datasources/[feature]_remote_datasource.dart
```

**مثال:**

```dart
abstract class ScheduleRemoteDataSource {
  Future<List<ScheduleModel>> getSchedule();
}

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final ApiServices apiServices;

  @override
  Future<List<ScheduleModel>> getSchedule() async {
    final response = await apiServices.get('/schedule');
    // ...
  }
}
```

#### إنشاء Local DataSource (Optional)

```bash
lib/features/[feature_name]/data/datasources/[feature]_local_datasource.dart
```

#### إنشاء Repository Implementation

```bash
lib/features/[feature_name]/data/repositories/[feature]_repository_impl.dart
```

**مثال:**

```dart
class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;

  @override
  Future<List<ScheduleEntity>> getSchedule() async {
    return await remoteDataSource.getSchedule();
  }
}
```

---

### 3️⃣ **Presentation Layer**

#### إنشاء States

```bash
lib/features/[feature_name]/presentation/cubit/[feature]_state.dart
```

**مثال:**

```dart
abstract class ScheduleState extends Equatable {}
class ScheduleLoading extends ScheduleState {}
class ScheduleSuccess extends ScheduleState {
  final List<ScheduleEntity> schedules;
}
class ScheduleFailure extends ScheduleState {
  final String message;
}
```

#### إنشاء Cubit

```bash
lib/features/[feature_name]/presentation/cubit/[feature]_cubit.dart
```

**مثال:**

```dart
class ScheduleCubit extends Cubit<ScheduleState> {
  final GetScheduleUseCase getScheduleUseCase;

  Future<void> loadSchedule() async {
    emit(const ScheduleLoading());
    try {
      final schedules = await getScheduleUseCase();
      emit(ScheduleSuccess(schedules: schedules));
    } catch (e) {
      emit(ScheduleFailure(message: e.toString()));
    }
  }
}
```

#### تحديث الـ Page

```dart
// lib/features/[feature_name]/presentation/pages/[feature]_page.dart

@override
Widget build(BuildContext context) {
  return BlocBuilder<ScheduleCubit, ScheduleState>(
    builder: (context, state) {
      if (state is ScheduleLoading) {
        return Center(child: CircularProgressIndicator());
      }
      if (state is ScheduleSuccess) {
        return ListView.builder(
          itemCount: state.schedules.length,
          itemBuilder: (context, index) {
            // UI Code
          },
        );
      }
      if (state is ScheduleFailure) {
        return Center(child: Text(state.message));
      }
      return SizedBox();
    },
  );
}
```

---

### 4️⃣ **Dependency Injection**

#### تحديث ServiceLocator

```dart
// lib/core/service_locator.dart

static Future<void> init() async {
  // ... existing code ...

  // ===== Schedule Feature =====
  final scheduleRemoteDataSource = ScheduleRemoteDataSourceImpl(apiServices);
  final scheduleRepository = ScheduleRepositoryImpl(
    remoteDataSource: scheduleRemoteDataSource,
  );
  final getScheduleUseCase = GetScheduleUseCase(scheduleRepository);

  _scheduleCubit = ScheduleCubit(getScheduleUseCase: getScheduleUseCase);
}

static late ScheduleCubit _scheduleCubit;
static ScheduleCubit get scheduleCubit => _scheduleCubit;
```

#### إضافة في main.dart

```dart
// lib/main.dart

MultiBlocProvider(
  providers: [
    BlocProvider<AuthCubit>(...),
    BlocProvider<CoursesCubit>(...),
    BlocProvider<ScheduleCubit>(...),  // ← جديد
  ],
)
```

---

## 📁 الهيكل الكامل لـ Feature جديد

```
features/[feature_name]/
├── data/
│   ├── datasources/
│   │   ├── [feature]_remote_datasource.dart
│   │   └── [feature]_local_datasource.dart (optional)
│   ├── models/
│   │   └── [feature]_model.dart
│   └── repositories/
│       └── [feature]_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── [feature]_entity.dart
│   ├── repositories/
│   │   └── [feature]_repository.dart
│   └── usecases/
│       └── [feature]_usecases.dart
└── presentation/
    ├── cubit/
    │   ├── [feature]_cubit.dart
    │   └── [feature]_state.dart
    ├── pages/
    │   └── [feature]_page.dart
    └── widgets/
        └── (custom widgets if any)
```

---

## 🎯 Features المتبقية

### 📅 **Schedule Feature**

- **Endpoints:** `GET /schedule`
- **Data:** يوم، وقت، مكان، مقرر

### 📊 **Exams Feature**

- **Endpoints:** `GET /exams`, `GET /exams/{id}`
- **Data:** اسم، تاريخ، وقت، علامة

### 📋 **Results Feature**

- **Endpoints:** `GET /results`, `GET /courses/{id}/grades`
- **Data:** المقرر، الدرجة، النسبة المئوية

### 👤 **Profile Feature**

- **Endpoints:** `GET /profile`, `PUT /profile`
- **Data:** اسم، بريد، رقم الجامعة، السنة الدراسية

### 📤 **Submission Feature**

- **Endpoints:** `GET /submissions`, `POST /submissions/{id}/submit`
- **Data:** التكليف، الموعد، الحالة

### 📚 **Content Feature**

- **Endpoints:** `GET /courses/{id}/content`, `GET /content/{id}`
- **Data:** نوع، عنوان، وصف، ملف

---

## ⚡ نصائح سريعة

| الخطأ                      | ✅ الحل                                              |
| -------------------------- | ---------------------------------------------------- |
| نسيان تحديث ServiceLocator | تأكد من إضافة Cubit الجديد في `service_locator.dart` |
| عدم إضافة BlocProvider     | أضفه في `main.dart` داخل `MultiBlocProvider`         |
| الخلط بين Entity و Model   | Entity في Domain، Model في Data                      |
| استخدام المباشر للـ API    | استخدم DataSource و Repository                       |
| عدم التعامل مع الأخطاء     | أضف `try-catch` و أصدر `Failure` state               |

---

## 🧪 اختبار Feature جديد

```dart
void main() {
  group('ScheduleCubit', () {
    late MockScheduleRepository mockRepository;
    late ScheduleCubit scheduleBloc;

    setUp(() {
      mockRepository = MockScheduleRepository();
      scheduleBloc = ScheduleCubit(
        getScheduleUseCase: GetScheduleUseCase(mockRepository),
      );
    });

    test('emit [ScheduleLoading, ScheduleSuccess] when data is fetched', () async {
      when(mockRepository.getSchedule()).thenAnswer(
        (_) async => [testSchedule],
      );

      expect(
        scheduleBloc.stream,
        emitsInOrder([
          const ScheduleLoading(),
          ScheduleSuccess(schedules: [testSchedule]),
        ]),
      );

      scheduleBloc.loadSchedule();
    });
  });
}
```

---

## 🔗 API Endpoints المطلوبة

```
# Auth
POST   /auth/login
POST   /auth/register
GET    /auth/me
POST   /auth/logout

# Courses
GET    /courses
GET    /courses/{id}
GET    /courses/search?q=

# Schedule
GET    /schedule
GET    /schedule/{id}

# Exams
GET    /exams
GET    /exams/{id}
POST   /exams/{id}/submit

# Results
GET    /results
GET    /courses/{id}/grades

# Profile
GET    /profile
PUT    /profile

# Submissions
GET    /submissions
POST   /submissions/{id}/submit
GET    /submissions/{id}

# Content
GET    /courses/{id}/content
GET    /content/{id}
```

---

## ✨ Template سريع (Copy & Paste)

```dart
// Entity Template
class [Feature]Entity extends Equatable {
  final String id;

  const [Feature]Entity({required this.id});

  @override
  List<Object?> get props => [id];
}

// Model Template
class [Feature]Model extends [Feature]Entity {
  factory [Feature]Model.fromJson(Map<String, dynamic> json) {
    return [Feature]Model(id: json['id']);
  }

  Map<String, dynamic> toJson() => {'id': id};
}

// State Template
class [Feature]Loading extends [Feature]State {}
class [Feature]Success extends [Feature]State {
  final List<[Feature]Entity> items;
}
class [Feature]Failure extends [Feature]State {
  final String message;
}

// Cubit Template
class [Feature]Cubit extends Cubit<[Feature]State> {
  final GetUseCase getUseCase;

  Future<void> load() async {
    emit([Feature]Loading());
    try {
      final items = await getUseCase();
      emit([Feature]Success(items: items));
    } catch(e) {
      emit([Feature]Failure(message: e.toString()));
    }
  }
}
```

---

**عند اتباع هذه الخطوات، ستتمكن من إضافة أي feature جديد بسهولة! 🚀**
