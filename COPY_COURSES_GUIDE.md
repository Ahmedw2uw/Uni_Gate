📋 # دليل نسخ ميزة Courses للـ Features الأخرى

## 🎯 الفكرة الأساسية

تم بناء **Courses** باستخدام Clean Architecture تماماً.  
**يمكنك نسخ نفس البنية** للـ features الأخرى بتغيير الأسماء فقط.

---

## 📋 قائمة الـ Features المتبقية

| الـ Feature | الحالة | الأولوية   | الجهد                      |
| ----------- | ------ | ---------- | -------------------------- |
| Schedule    | ❌     | ⭐⭐⭐⭐⭐ | 2 ساعة                     |
| Exams       | ❌     | ⭐⭐⭐⭐⭐ | 2 ساعة                     |
| Results     | ❌     | ⭐⭐⭐⭐   | 2 ساعة                     |
| Profile     | ⚠️     | ⭐⭐⭐     | 3 ساعات (مع PUT)           |
| Submission  | ❌     | ⭐⭐       | 4 ساعات (مع file upload)   |
| Content     | ❌     | ⭐⭐       | 4 ساعات (مع file download) |

---

## 🔄 خطوات النسخ السريعة (لـ Schedule)

### **الخطوة 1: Domain Layer**

#### 1️⃣ إنشاء Entity

```bash
lib/features/schedule/domain/entities/schedule_entity.dart
```

```dart
class ScheduleEntity extends Equatable {
  final String id;
  final String courseTitle;
  final String day;
  final String startTime;
  final String endTime;
  final String location;
  final String professorName;

  const ScheduleEntity({
    required this.id,
    required this.courseTitle,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.professorName,
  });

  @override
  List<Object?> get props => [
    id, courseTitle, day, startTime, endTime, location, professorName
  ];
}
```

#### 2️⃣ إنشاء Repository (Abstract)

```bash
lib/features/schedule/domain/repositories/schedule_repository.dart
```

```dart
abstract class ScheduleRepository {
  Future<List<ScheduleEntity>> getSchedule({
    required int year,
    required int semester,
    required int departmentId,
  });

  Future<ScheduleEntity> getScheduleById(String scheduleId);
}
```

#### 3️⃣ إنشاء UseCases

```bash
lib/features/schedule/domain/usecases/schedule_usecases.dart
```

```dart
class GetScheduleUseCase {
  final ScheduleRepository repository;

  GetScheduleUseCase(this.repository);

  Future<List<ScheduleEntity>> call({
    required int year,
    required int semester,
    required int departmentId,
  }) {
    return repository.getSchedule(
      year: year,
      semester: semester,
      departmentId: departmentId,
    );
  }
}

class GetScheduleByIdUseCase {
  final ScheduleRepository repository;

  GetScheduleByIdUseCase(this.repository);

  Future<ScheduleEntity> call(String scheduleId) {
    return repository.getScheduleById(scheduleId);
  }
}
```

---

### **الخطوة 2: Data Layer**

#### 1️⃣ إنشاء Model

```bash
lib/features/schedule/data/models/schedule_model.dart
```

```dart
class ScheduleModel extends ScheduleEntity {
  const ScheduleModel({
    required super.id,
    required super.courseTitle,
    required super.day,
    required super.startTime,
    required super.endTime,
    required super.location,
    required super.professorName,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id']?.toString() ?? '',
      courseTitle: json['courseTitle']?.toString() ?? '',
      day: json['day']?.toString() ?? '',
      startTime: json['startTime']?.toString() ?? '',
      endTime: json['endTime']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      professorName: json['professorName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'courseTitle': courseTitle,
    'day': day,
    'startTime': startTime,
    'endTime': endTime,
    'location': location,
    'professorName': professorName,
  };
}
```

#### 2️⃣ إنشاء Remote DataSource

```bash
lib/features/schedule/data/datasources/schedule_remote_datasource.dart
```

```dart
abstract class ScheduleRemoteDataSource {
  Future<List<ScheduleModel>> getSchedule({
    required int year,
    required int semester,
    required int departmentId,
  });

  Future<ScheduleModel> getScheduleById(String scheduleId);
}

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final ApiServices apiServices;

  ScheduleRemoteDataSourceImpl(this.apiServices);

  @override
  Future<List<ScheduleModel>> getSchedule({
    required int year,
    required int semester,
    required int departmentId,
  }) async {
    try {
      if (departmentId <= 0) {
        throw Exception('⚠️ قيمة departmentId غير صحيحة');
      }

      final response = await apiServices.get(
        '/StudentSchedule/schedule/year',
        queryParameters: {
          'Year': year,
          'Semester': semester,
          'DepartmentId': departmentId,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List
            ? response.data
            : response.data['schedule'] ?? response.data['data'] ?? [];

        return data
            .map((item) => ScheduleModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('فشل جلب الجدول: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('خطأ في جلب الجدول: $e');
    }
  }

  @override
  Future<ScheduleModel> getScheduleById(String scheduleId) async {
    try {
      final response = await apiServices.get('/schedule/$scheduleId');

      if (response.statusCode == 200) {
        return ScheduleModel.fromJson(response.data);
      } else {
        throw Exception('فشل جلب الجدول: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('خطأ في جلب الجدول: $e');
    }
  }
}
```

#### 3️⃣ إنشاء Repository Implementation

```bash
lib/features/schedule/data/repositories/schedule_repository_impl.dart
```

```dart
class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;

  ScheduleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ScheduleEntity>> getSchedule({
    required int year,
    required int semester,
    required int departmentId,
  }) async {
    try {
      return await remoteDataSource.getSchedule(
        year: year,
        semester: semester,
        departmentId: departmentId,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ScheduleEntity> getScheduleById(String scheduleId) async {
    try {
      return await remoteDataSource.getScheduleById(scheduleId);
    } catch (e) {
      rethrow;
    }
  }
}
```

---

### **الخطوة 3: Presentation Layer**

#### 1️⃣ إنشاء States

```bash
lib/features/schedule/presentation/cubit/schedule_state.dart
```

```dart
abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object?> get props => [];
}

class ScheduleInitial extends ScheduleState {
  const ScheduleInitial();
}

class ScheduleLoading extends ScheduleState {
  const ScheduleLoading();
}

class ScheduleSuccess extends ScheduleState {
  final List<ScheduleEntity> schedules;

  const ScheduleSuccess({required this.schedules});

  @override
  List<Object?> get props => [schedules];
}

class ScheduleFailure extends ScheduleState {
  final String message;

  const ScheduleFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ScheduleUserNotAssigned extends ScheduleState {
  const ScheduleUserNotAssigned();
}
```

#### 2️⃣ إنشاء Cubit

```bash
lib/features/schedule/presentation/cubit/schedule_cubit.dart
```

```dart
class ScheduleCubit extends Cubit<ScheduleState> {
  final GetScheduleUseCase getScheduleUseCase;
  final GetScheduleByIdUseCase getScheduleByIdUseCase;
  final AuthCubit authCubit;

  ScheduleCubit({
    required this.getScheduleUseCase,
    required this.getScheduleByIdUseCase,
    required this.authCubit,
  }) : super(const ScheduleInitial());

  Future<void> fetchSchedule() async {
    emit(const ScheduleLoading());

    try {
      final currentUser = (authCubit.state as dynamic).user;

      if (currentUser.isApplicant || !currentUser.hasAssignedDepartment) {
        emit(const ScheduleUserNotAssigned());
        return;
      }

      int year = currentUser.academicYear ?? 0;
      int semester = currentUser.semester ?? 1;
      int departmentId = currentUser.departmentId ?? 0;

      if (kDebugMode && (year <= 0 || departmentId <= 0)) {
        year = 6408;
        semester = 1;
        departmentId = 477;
      }

      if (!kDebugMode && (year <= 0 || departmentId <= 0)) {
        emit(const ScheduleUserNotAssigned());
        return;
      }

      final schedules = await getScheduleUseCase(
        year: year,
        semester: semester,
        departmentId: departmentId,
      );

      emit(ScheduleSuccess(schedules: schedules));
    } catch (e) {
      emit(ScheduleFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
```

---

### **الخطوة 4: تحديث Service Locator**

في `lib/core/service_locator.dart`:

```dart
// ============= Schedule Feature =============
final scheduleRemoteDataSource = ScheduleRemoteDataSourceImpl(apiServices);
final scheduleRepository = ScheduleRepositoryImpl(
  remoteDataSource: scheduleRemoteDataSource,
);

_scheduleCubit = ScheduleCubit(
  getScheduleUseCase: GetScheduleUseCase(scheduleRepository),
  getScheduleByIdUseCase: GetScheduleByIdUseCase(scheduleRepository),
  authCubit: _authCubit,
);

static ScheduleCubit get scheduleCubit => _scheduleCubit;
```

---

### **الخطوة 5: تحديث main.dart**

```dart
import 'features/schedule/presentation/cubit/schedule_cubit.dart';

// في MultiBlocProvider:
BlocProvider<ScheduleCubit>(
  create: (context) => ServiceLocator.scheduleCubit,
),
```

---

## 🎯 ملخص الخطوات السريعة

### نفس البنية لـ 3 features:

```
Schedule   = نسخ Courses
Exams      = نسخ Courses + إضافة submit() method
Results    = نسخ Courses
```

### Features بها متطلبات خاصة:

```
Profile    = نسخ Courses + إضافة PUT request للتحديث
Submission = نسخ Courses + إضافة file upload مع POST
Content    = نسخ Courses + إضافة file download مع GET
```

---

## ⏱️ المدة الزمنية المتوقعة

```
Schedule:      2 ساعة (نسخ مباشر من Courses)
Exams:         2 ساعة (نسخ مع إضافة submit)
Results:       2 ساعة (نسخ مباشر من Courses)
Profile:       3 ساعات (مع PUT + file upload للصورة)
Submission:    4 ساعات (file upload متقدم)
Content:       4 ساعات (file download متقدم)
---
Total:         17 ساعة (~2-3 أيام)
```

---

## ✅ قائمة التحقق لكل Feature جديد

- [ ] هل أنشأت Entity؟
- [ ] هل أنشأت Repository (abstract و impl)؟
- [ ] هل أنشأت DataSource (abstract و impl)؟
- [ ] هل أنشأت Model مع fromJson و toJson؟
- [ ] هل أنشأت UseCase؟
- [ ] هل أنشأت States؟
- [ ] هل أنشأت Cubit مع المنطق الدفاعي؟
- [ ] هل أضفت الـ feature للـ ServiceLocator؟
- [ ] هل أضفت الـ Cubit للـ main.dart؟
- [ ] هل أنشأت الـ UI (Page)؟
- [ ] هل أضفت الـ route للـ routes map؟
- [ ] هل اختبرت الـ feature؟

---

## 🚀 الخطوة التالية المقترحة

**ابدأ بـ Schedule Feature (الأسهل):**

- ✅ نفس البنية كـ Courses تماماً
- ✅ بدون متطلبات إضافية معقدة
- ✅ API endpoint مشابه جداً
- ✅ الانتهاء فيه حوالي ساعتين

---

## 📌 نقاط هامة

1. ✅ جميع الـ Features تستخدم **نفس الـ Getters الدفاعية** من UserModel
2. ✅ جميع الـ Features تستخدم **نفس البارامترات**: year, semester, departmentId
3. ✅ جميع الـ Features تستخدم **نفس المنطق الدفاعي** في Cubit
4. ✅ جميع الـ Features تستخدم **AppColors و CustomText** فقط

---

**كل ما تحتاجه موجود في Courses!** 🎉  
انسخ، غيّر الأسماء، واختبر! ✅
