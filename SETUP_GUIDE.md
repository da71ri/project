# 🔧 دليل الإعداد المتقدم

دليل شامل لإعداد المشروع على جهازك بخطوات تفصيلية.

---

## 📋 المتطلبات الأساسية

### النظام العام
- **Windows 10/11** أو **macOS 10.15+** أو **Linux**
- **رام**: 8 GB على الأقل
- **مساحة**: 10 GB حرة على الأقل
- **اتصال الإنترنت**

### البرامج المطلوبة
- **Git**: [تحميل Git](https://git-scm.com/download)
- **Flutter SDK**: الإصدار 3.11.0 أو أحدث
- **Android Studio**: إذا كنت تطور لـ Android
- **Xcode**: إذا كنت تطور لـ iOS (macOS فقط)
- **VS Code**: محرر النصوص (اختياري)

---

## 🎯 خطوات الإعداد

### المرحلة 1: تثبيت Flutter

#### على Windows:
```bash
# 1. تحميل Flutter SDK
# https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.19.0-stable.zip

# 2. فك الضغط إلى C:\src\flutter

# 3. إضافة Flutter للـ PATH
# اذهب إلى متغيرات البيئة (Environment Variables)
# أضف: C:\src\flutter\bin

# 4. تحديث PATH في PowerShell
$Env:PATH += ";C:\src\flutter\bin"

# 5. التحقق من التثبيت
flutter --version
flutter doctor
```

#### على macOS/Linux:
```bash
# 1. استنساخ المشروع
git clone https://github.com/flutter/flutter.git -b stable
cd flutter
export PATH="$PWD/bin:$PATH"

# 2. التحقق
flutter --version
flutter doctor
```

### المرحلة 2: إعداد Android

```bash
# 1. تثبيت Java JDK 17
# https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html

# 2. تثبيت Android Studio
# https://developer.android.com/studio

# 3. تثبيت Android SDK
# افتح Android Studio > SDK Manager
# اختر:
#   - Android 13 (API 33) أو أحدث
#   - Android SDK Build-Tools 33.0.0 أو أحدث

# 4. توافق التراخيص
flutter doctor --android-licenses
# اكتب 'y' لقبول جميع التراخيص
```

### المرحلة 3: إعداد iOS (macOS فقط)

```bash
# 1. تثبيت Xcode
# من App Store أو: https://developer.apple.com/xcode/

# 2. تفعيل أدوات سطر الأوامر
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcode-select --reset

# 3. تثبيت CocoaPods
sudo gem install cocoapods

# 4. القبول بترخيص Xcode
sudo xcodebuild -license accept
```

### المرحلة 4: التحقق من التثبيت

```bash
# الأمر الشامل
flutter doctor

# النتيجة المتوقعة:
# ✓ Flutter
# ✓ Android toolchain
# ✓ Xcode (على Mac)
# ✓ Connected devices (على الأقل محاكي)
```

---

## 🔥 إعداد Firebase

### خطوة 1: إنشاء مشروع Firebase

1. انتقل إلى [Firebase Console](https://console.firebase.google.com)
2. اضغط "Create a new project"
3. أدخل اسم المشروع (مثل: "allergy-guide")
4. قبول الشروط واضغط "Create project"
5. انتظر إكمال الإنشاء

### خطوة 2: إضافة تطبيق Android

```
1. في Firebase Console، اختر: "+Add app" > Android
2. أدخل Package Name: com.example.project
3. اضغط "Register app"
4. اضغط "Download google-services.json"
5. ضع الملف في: android/app/google-services.json

# في Android Studio:
# Project > Project Structure > Modules > app > google-services.json
# تأكد أن الملف موجود
```

### خطوة 3: إضافة تطبيق iOS

```
1. في Firebase Console، اختر: "+Add app" > iOS
2. أدخل Bundle ID: com.example.project
3. اضغط "Register app"
4. اضغط "Download GoogleService-Info.plist"
5. افتح ios/Runner.xcworkspace في Xcode
6. انقر يميناً على Runner > Add Files to "Runner"
7. اختر GoogleService-Info.plist
8. تأكد أنه في Build Phases > Copy Bundle Resources
```

### خطوة 4: تفعيل المصادقة

```
في Firebase Console:
1. Build > Authentication
2. Sign-in method
3. فعّل:
   - Email/Password
   - Google Sign-In

للـ Google Sign-In:
1. اذهب إلى Google Cloud Console
2. OAuth consent screen > Edit
3. أضف البريد الإلكتروني والشركة
4. أضف Scopes: email, profile
5. اختبر التطبيق > أضف حسابات اختبار
```

### خطوة 5: إعداد Firestore

```
في Firebase Console:
1. Build > Firestore Database
2. Create database
3. اختر: Start in test mode
4. Region: قريب من موقعك
5. Create

الآن أنشئ Collections:
- users
- products
- allergies
```

### خطوة 6: قواعد الأمان

```
في Firebase Console:
1. Rules > edit rules

أدرج:
```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    // يرى المستخدمون بيانات أنفسهم فقط
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }

    // المنتجات للقراءة فقط للمستخدمين المصرح لهم
    match /products/{productId} {
      allow read: if request.auth != null;
    }

    // الحساسيات للقراءة فقط
    match /allergies/{allergyId} {
      allow read: if request.auth != null;
    }
  }
}
```
```

---

## 📦 استنساخ المشروع

```bash
# 1. استنساخ المشروع
git clone https://github.com/yourusername/allergy-guide.git
cd allergy-guide

# 2. تثبيت الحزم
flutter pub get

# 3. تحديث الحزم
flutter pub upgrade

# 4. تنظيف البناء
flutter clean
flutter pub get
```

---

## ▶️ تشغيل التطبيق

### على محاكي Android

```bash
# 1. فتح AVD Manager
android studio > Device Manager > Create Virtual Device

# 2. اختر جهاز (Pixel 6 مثلاً)
# 3. حمّل صورة النظام (Android 13+)
# 4. اضغط "Finish"

# 5. تشغيل التطبيق
flutter run

# أو مع تفاصيل
flutter run -v
```

### على جهاز Android فعلي

```bash
# 1. فعّل وضع المطور
# الإعدادات > حول الهاتف > اضغط رقم الإصدار 7 مرات

# 2. فعّل تصحيح USB
# الإعدادات > خيارات المطور > تصحيح USB

# 3. وصّل الهاتف بـ USB

# 4. تحقق من الاتصال
flutter devices

# 5. شغّل التطبيق
flutter run
```

### على محاكي iOS (macOS فقط)

```bash
# 1. فتح Simulator
open -a Simulator

# 2. تشغيل التطبيق
flutter run

# أو حدد الجهاز
flutter run -d "iPhone 14 Pro"
```

---

## 🐛 استكشاف المشاكل الشائعة

### مشكلة: Flutter Doctor يظهر أخطاء

```bash
# الحل:
flutter doctor --verbose

# إذا كانت هناك مشاكل، اتبع التوصيات
# قد تحتاج:
flutter doctor --android-licenses
flutter pub get
flutter clean
```

### مشكلة: خطأ "No devices found"

```bash
# على Windows:
# 1. ثبّت Android USB drivers
# 2. فعّل تصحيح USB على الهاتف
# 3. استخدم: flutter devices

# على Mac/Linux:
# 1. تحقق من الاتصال: adb devices
# 2. أعد تشغيل adb: adb kill-server && adb start-server
```

### مشكلة: خطأ Firebase

```
خطأ: "[core/no-app]No firebase app '[DEFAULT]' has been created"

الحل:
1. تأكد من وجود google-services.json
2. تأكد من com.google.gms.google-services في build.gradle
3. نفذ: flutter clean && flutter pub get
```

### مشكلة: خطأ Gradle

```bash
# الحل:
flutter clean
flutter pub get
flutter pub upgrade
flutter run

# أو نسخ جديد:
rm -rf build/ && flutter run
```

### مشكلة: نقص الذاكرة

```bash
# لـ Flutter build:
flutter run --release

# لـ Gradle (في android/gradle.properties):
org.gradle.jvmargs=-Xmx2048m
```

---

## 🎨 إعداد محرر النصوص

### VS Code Setup

```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "Dart-Code.dart-code",
  "[dart]": {
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.fixAll": true,
      "source.organizeImports": true
    }
  }
}
```

### تثبيت Extensions
```
- Dart (Dart-Code.dart-code)
- Flutter (Dart-Code.flutter)
- Awesome Flutter Snippets
- Firebase Explorer
- Firestore Rules
```

---

## 📊 بناء الإصدارات

### بناء APK (Android)

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Split APKs بحسب المعالج
flutter build apk --target-platform android-arm64
```

### بناء iOS

```bash
# Build iOS app
flutter build ios

# Build for release
flutter build ios --release
```

### بناء Web (اختياري)

```bash
# تفعيل Web
flutter config --enable-web

# Build Web
flutter build web
```

---

## 📱 الأجهزة المدعومة

### Android
- **الحد الأدنى**: Android 5.0 (API 21)
- **الموصى به**: Android 8.0+ (API 26+)
- **الحالي**: تم الاختبار على Android 12+

### iOS
- **الحد الأدنى**: iOS 11
- **الموصى به**: iOS 14+
- **الحالي**: تم الاختبار على iOS 15+

---

## 📞 الدعم

إذا واجهت مشاكل:

1. تحقق من [Troubleshooting Guide](TROUBLESHOOTING.md)
2. اقرأ [Flutter Docs](https://flutter.dev/docs)
3. ابحث في [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
4. افتح [Issue](../../issues) مع التفاصيل

---

## ✅ قائمة التحقق الأخيرة

- [ ] تثبيت Flutter بنجاح (flutter --version)
- [ ] تثبيت Android Studio/Xcode
- [ ] إنشاء مشروع Firebase
- [ ] تحميل google-services.json
- [ ] استنساخ المشروع
- [ ] تشغيل flutter pub get
- [ ] تشغيل التطبيق على محاكي/جهاز
- [ ] اختبار المصادقة
- [ ] اختبار ماسح الباركود

**مبروك! 🎉 المشروع جاهز للتطوير!**
