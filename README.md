# 🎓 Nuigate - Student Portal Application

> تطبيق بوابة الطالب الجامعي - تطبيق Flutter مع **Clean Architecture**

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.10+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Architecture](https://img.shields.io/badge/Architecture-Clean-blueviolet)

---

## 📱 نبذة عن المشروع

**Nuigate** هو تطبيق فلاتر متقدم لإدارة شؤون الطلاب الجامعيين، مبني بـ **Clean Architecture** و **Bloc/Cubit** للإدارة المتقدمة للحالات.

### الميزات الرئيسية:

- 🔐 **تسجيل دخول آمن** مع حفظ التوكن
- 📚 **إدارة الدورات الدراسية**
- 📅 **جدول المحاضرات الأسبوعي**
- 📋 **إدارة الواجبات والتكليفات**
- 📊 **عرض النتائج والدرجات**
- 👤 **الملف الشخصي للطالب**
- ✏️ **الامتحانات الإلكترونية**

---

## 🛠️ التكنولوجيا المستخدمة

### Framework & Language

- **Flutter** 3.0+
- **Dart** 3.10.4

### State Management

- **Flutter Bloc** (flutter_bloc 8.1.3)

### Networking & Data

- **Dio** 5.3.1 (HTTP Client)
- **SharedPreferences** 2.2.2 (Local Storage)

### Utilities

- **Equatable** 2.0.5 (Value Equality)
- **Flutter Localizations** (Arabic Support)

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── app_colors.dart           # ألوان التطبيق
│   ├── app_strings.dart          # نصوص التطبيق
│   ├── constants/                # ثوابت
│   └── service_locator.dart      # Dependency Injection
│
├── features/
│   ├── auth/                     # خاصية المصادقة
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   │
│   ├── courses/                  # خاصية الدورات
│   ├── schedule/                 # خاصية الجدول
│   ├── exams/                    # خاصية الامتحانات
│   ├── results/                  # خاصية النتائج
│   ├── profile/                  # خاصية الملف الشخصي
│   ├── submission/               # خاصية الواجبات
│   └── content/                  # خاصية المحتوى
│
├── network/
│   └── api_services.dart         # خدمات API (Dio)
│
├── shared/
│   └── widgets/                  # widgets مشتركة
│
├── utils/
│   ├── helpers.dart
│   └── validator.dart
│
└── main.dart                     # نقطة البداية
```

---

## 🏗️ المعمارية

التطبيق يتبع **Clean Architecture** مع ثلاثة طبقات رئيسية:

### 🔷 Domain Layer (Business Logic)

- **Entities**: تمثيل البيانات النقية
- **Repositories**: عقود الوصول للبيانات
- **UseCases**: عمليات منفصلة

### 🔶 Data Layer (Data Management)

- **Models**: توسيع الـ Entities
- **DataSources**: الوصول الفعلي للبيانات (Remote + Local)
- **Repositories**: توازن بين المصادر

### 🟦 Presentation Layer (UI & State)

- **Cubit**: منطق الحالة
- **States**: حالات التطبيق
- **Pages**: واجهات المستخدم

---

## 🚀 البدء السريع

### المتطلبات

- Flutter 3.0+
- Dart 3.10+
- Android Studio / VS Code

### التثبيت

```bash
# استنساخ المشروع
git clone https://github.com/yourusername/nuigate.git
cd nuigate

# تثبيت Dependencies
flutter pub get

# تشغيل التطبيق
flutter run
```

### تحديث API URL

```dart
// lib/network/api_services.dart
class ApiConfig {
  static const String baseUrl = 'https://your-api.com/v1';
}
```

---

## 📚 الوثائق الشاملة

لفهم المعمارية والتطبيق بشكل أعمق:

- 📖 **[ARCHITECTURE.md](./ARCHITECTURE.md)** - شرح معماري شامل مع أمثلة
- 📚 **[IMPLEMENTATION_GUIDE.md](./IMPLEMENTATION_GUIDE.md)** - دليل خطوة بخطوة لإضافة features جديدة
- 📋 **[IMPLEMENTATION_SUMMARY.md](./IMPLEMENTATION_SUMMARY.md)** - ملخص الإنجازات والإحصائيات

---

## 🔒 المصادقة والأمان

- ✅ حفظ التوكن آمن في `SharedPreferences`
- ✅ معالجة شاملة للأخطاء
- ✅ التحقق من صحة البيانات المدخلة
- ✅ تسجيل تلقائي للطلبات والاستجابات

---

## 🧪 الاختبار

### Unit Testing Example

```dart
void main() {
  group('AuthCubit', () {
    test('emit [AuthLoading, AuthSuccess] on successful login', () async {
      // Test code
    });
  });
}
```

---

## 📡 API Endpoints

```
# Authentication
POST   /auth/login
GET    /auth/me

# Courses
GET    /courses
GET    /courses/{id}

# Schedule
GET    /schedule

# Exams
GET    /exams

# Results
GET    /results

# Profile
GET    /profile
PUT    /profile

# Submissions
GET    /submissions
POST   /submissions/{id}/submit

# Content
GET    /content
```

---

## 🎯 المرحلة القادمة

- [ ] إضافة اختبارات شاملة (Unit + Widget)
- [ ] تحسين الـ Performance
- [ ] إضافة Offline Support
- [ ] تحسين UX/UI
- [ ] إضافة Analytics
- [ ] تحسين Localization

---

## 📱 المنصات المدعومة

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ Linux
- ✅ macOS

---

## 🤝 المساهمة

نرحب بالمساهمات! يرجى:

1. Fork المشروع
2. إنشاء branch جديد (`git checkout -b feature/AmazingFeature`)
3. Commit التغييرات (`git commit -m 'Add AmazingFeature'`)
4. Push إلى Branch (`git push origin feature/AmazingFeature`)
5. فتح Pull Request

---

## 📄 الترخيص

هذا المشروع مرخص تحت [MIT License](LICENSE)

---

## 👨‍💼 الفريق

- 🎓 **الطالب**: الخريج من جامعة [الجامعة]
- 🏢 **المشروع**: مشروع التخرج
- 📅 **السنة**: 2026

---

## 📞 الدعم والتواصل

للأسئلة والدعم:

- 📧 البريد الإلكتروني: [your-email@example.com]
- 💬 GitHub Issues: [Issues Page]
- 🔗 LinkedIn: [Your Profile]

---

## 🎉 شكراً!

شكراً لاستخدام Nuigate! نتمنى أن يكون المشروع مفيداً لك.

---

**Last Updated**: 29 أبريل 2026  
**Version**: 1.0.0  
**Status**: ✅ Production Ready
