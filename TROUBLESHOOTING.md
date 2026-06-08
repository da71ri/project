# 🔧 دليل استكشاف الأخطاء والمشاكل

حل سريع للمشاكل الشائعة التي قد تواجهك أثناء التطوير أو التشغيل.

---

## 🚨 الأخطاء الشائعة

### 1. خطأ Firebase: "No app '[DEFAULT]' has been created"

**الأعراض:**
```
Exception: [core/no-app]No firebase app '[DEFAULT]' has been created - call Firebase.initializeApp()
```

**الأسباب المحتملة:**
- ملف `google-services.json` مفقود
- Firebase لم تتم تهيئتها قبل استخدام خدماتها
- خطأ في تكوين Firebase

**الحل:**

```bash
# 1. تأكد من وجود الملف
ls android/app/google-services.json

# 2. إذا كان مفقوداً، حمّله من Firebase Console
# Firebase Console > Project Settings > Download google-services.json

# 3. تنظيف وإعادة بناء
flutter clean
flutter pub get
flutter run

# 4. تأكد من main.dart
# يجب أن يكون:
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
```

### 2. خطأ: "Plugin exception occurred"

**الأعراض:**
```
ProcessException: Cannot find a program to run named "flutter"
```

**الحل:**

```bash
# 1. تأكد من تثبيت Flutter
flutter --version

# 2. أضف Flutter للـ PATH
# Windows:
$Env:PATH += ";C:\src\flutter\bin"

# Mac/Linux:
export PATH="$PATH:~/flutter/bin"

# 3. أعد تشغيل الطرفية
```

### 3. خطأ: "Android SDK is not installed"

**الأعراض:**
```
[!] Android toolchain - develop for Android devices
    ✗ Unable to locate Android SDK
```

**الحل:**

```bash
# 1. تثبيت Android Studio من:
# https://developer.android.com/studio

# 2. فتح Android Studio وتثبيت SDK
# Tools > SDK Manager

# 3. ضبط ANDROID_HOME
# Windows:
$Env:ANDROID_HOME = "C:\Users\YourUsername\AppData\Local\Android\sdk"

# Mac/Linux:
export ANDROID_HOME=~/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
```

### 4. خطأ: "Gradle build failed"

**الأعراض:**
```
FAILURE: Build failed with an exception.
```

**الحل:**

```bash
# 1. تنظيف البناء
flutter clean

# 2. تحديث الحزم
flutter pub get
flutter pub upgrade

# 3. بناء جديد
flutter run -v

# 4. إذا استمرت المشكلة، حاول:
rm -rf android/build
rm -rf build/
flutter clean
flutter pub get
flutter run
```

### 5. خطأ: "No connected devices"

**الأعراض:**
```
No devices found yet. Waiting for any devices to connect
```

**الحل:**

```bash
# Android Device:
# 1. تفعيل وضع المطور
#    الإعدادات > حول الهاتف > اضغط رقم الإصدار 7 مرات

# 2. تفعيل تصحيح USB
#    الإعدادات > خيارات المطور > تصحيح USB

# 3. اختبار الاتصال
adb devices

# 4. إذا لم يظهر:
adb kill-server
adb start-server
adb devices

# محاكي Android:
# 1. فتح Android Studio
# 2. Device Manager > Create Virtual Device
# 3. تشغيل المحاكي
# 4. flutter run
```

### 6. خطأ: "Xcode build system not configured" (iOS)

**الأعراض:**
```
Could not find a command named "build-ios"
```

**الحل:**

```bash
# 1. تثبيت Xcode
# من App Store

# 2. قبول الترخيص
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# 3. قبول الشروط
sudo xcodebuild -license accept

# 4. تثبيت CocoaPods
sudo gem install cocoapods

# 5. إعادة محاولة
flutter run
```

### 7. خطأ: "MobileScanner not working"

**الأعراض:**
```
Camera permission denied
```

**الحل:**

**AndroidManifest.xml:**
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
```

**طلب الأذونات (في الكود):**
```dart
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestCameraPermission() async {
  final status = await Permission.camera.request();
  return status.isGranted;
}

// قبل استخدام المسح:
bool hasPermission = await requestCameraPermission();
if (!hasPermission) {
  // إظهار رسالة للمستخدم
}
```

### 8. خطأ: "Firestore rules rejection"

**الأعراض:**
```
PERMISSION_DENIED: Missing or insufficient permissions
```

**الحل:**

**في Firebase Console > Firestore > Rules:**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // اسمح للمستخدمين بقراءة وكتابة بيانات أنفسهم
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }

    // اسمح بقراءة المنتجات للمصرح لهم
    match /products/{document=**} {
      allow read: if request.auth != null;
      allow write: if request.auth.token.admin == true;
    }
  }
}
```

---

## ⚡ مشاكل الأداء

### المشكلة: التطبيق بطيء جداً

**الحل:**

```bash
# 1. استخدم Release build بدلاً من Debug
flutter run --release

# 2. قلل عدد الـ rebuild
# استخدم const widgets حيث أمكن

# 3. تحسين queries Firestore
# - استخدم indexes
# - صغّر حجم البيانات المجلوبة
```

**في الكود:**
```dart
// ❌ بطيء
Widget build(BuildContext context) {
  return Container(
    child: Text("test"),
  );
}

// ✅ سريع
const Widget build = Container(
  child: Text("test"),
);
```

### المشكلة: استهلاك عالي للبطارية

**الحل:**

```dart
// تقليل تحديثات الواجهة
// استخدم StreamBuilder بحذر
// أوقف الخدمات غير المستخدمة
// استخدم debounce للبحث

import 'package:rxdart/rxdart.dart';

final _searchController = BehaviorSubject<String>();

Stream<List<Product>> get searchResults {
  return _searchController.stream
    .debounceTime(Duration(milliseconds: 500))
    .switchMap((query) => _firestore.searchProducts(query));
}
```

---

## 🧪 اختبار المشروع

### الاختبار اليدوي

```bash
# اختبار شامل
flutter test

# اختبار ملف محدد
flutter test test/widget_test.dart

# مع التفاصيل
flutter test -v
```

### اختبار على أجهزة متعددة

```bash
# جميع الأجهزة المتوفرة
flutter run -d all

# جهاز محدد
flutter run -d "device_name"

# القائمة
flutter devices
```

---

## 🔐 مشاكل الأمان

### مشكلة: بيانات حساسة مكشوفة

**الحل:**

```dart
// ❌ لا تفعل هذا
const API_KEY = "sk-12345678";

// ✅ استخدم متغيرات البيئة
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  final apiKey = dotenv.env['API_KEY'];
}
```

### مشكلة: قواعد Firestore ضعيفة

**❌ قواعد خطرة:**
```javascript
match /databases/{database}/documents {
  match /{document=**} {
    allow read, write; // خطر جداً!
  }
}
```

**✅ قواعد آمنة:**
```javascript
match /databases/{database}/documents {
  match /users/{userId} {
    allow read, write: if request.auth.uid == userId;
  }
  match /products/{docId} {
    allow read: if request.auth != null;
    allow write: if false; // قراءة فقط
  }
}
```

---

## 📊 تصحيح الأخطاء (Debugging)

### استخدام debugPrint

```dart
import 'package:flutter/foundation.dart';

debugPrint('قيمة المتغير: $value');
```

### استخدام DevTools

```bash
# بدء DevTools
flutter pub global activate devtools
devtools

# أو مع التطبيق
flutter run
# في طرفية أخرى: devtools
```

### استخدام Breakpoints

```dart
// في VS Code
// F9 لإضافة breakpoint
// F5 للتشغيل
// F10 للخطوة التالية

// في Android Studio
// اضغط على رقم السطر لإضافة breakpoint
```

---

## 📈 تحسين الأداء

### 1. استخدام معرّفات فريدة للـ widgets

```dart
// ✅ جيد
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return Container(
      key: ValueKey(items[index].id), // معرف فريد
      child: Text(items[index].name),
    );
  },
)
```

### 2. تقليل rebuilds

```dart
// ✅ استخدم RepaintBoundary
RepaintBoundary(
  child: ExpensiveWidget(),
)

// ✅ استخدم const widgets
const MyConstWidget()
```

### 3. تحسين Firestore queries

```dart
// ❌ سيء - جلب كل البيانات
db.collection('users').get()

// ✅ جيد - استخدم filters و limits
db.collection('users')
  .where('status', isEqualTo: 'active')
  .limit(10)
  .get()

// ✅ أفضل - استخدم pagination
db.collection('users')
  .where('status', isEqualTo: 'active')
  .orderBy('createdAt', descending: true)
  .limit(10)
  .get()
```

---

## 🔄 الإعادة والاستعادة

### إذا فسدت البيئة تماماً

```bash
# 1. تنظيف شامل
flutter clean
rm -rf pubspec.lock
rm -rf build/
rm -rf .dart_tool/

# 2. إعادة التثبيت
flutter pub get
flutter pub upgrade

# 3. محاولة جديدة
flutter run
```

### استعادة إصدار سابق

```bash
# عرض السجل
git log --oneline

# العودة لإصدار سابق
git checkout <commit-hash>

# أو إنشاء فرع جديد
git checkout -b recover-branch <commit-hash>
```

---

## ✅ قائمة التحقق قبل الرفع

- [ ] لا توجد أخطاء في `flutter analyze`
- [ ] جميع الاختبارات تمر `flutter test`
- [ ] لا توجد تحذيرات في البناء
- [ ] التطبيق يعمل على Release build
- [ ] تم اختباره على أجهزة متعددة
- [ ] لا توجد بيانات حساسة مكشوفة
- [ ] قواعد Firestore آمنة
- [ ] جودة الكود عالية

---

## 📞 للحصول على المزيد من المساعدة

- 📖 [Flutter Documentation](https://flutter.dev)
- 🔥 [Firebase Support](https://firebase.google.com/support)
- 🐛 [Stack Overflow - Flutter](https://stackoverflow.com/questions/tagged/flutter)
- 💬 [Flutter Community](https://flutter.dev/community)

---

**آخر تحديث**: 2026-06-04
