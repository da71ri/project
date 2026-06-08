# 🏥 تطبيق دليل الحساسيات - Allergy Guide

تطبيق جوال متقدم مبني بـ **Flutter** يساعد المستخدمين على اكتشاف أمان المنتجات الغذائية بناءً على حساسيتهم الغذائية.

---

## 📋 جدول المحتويات

- [المميزات الرئيسية](#المميزات-الرئيسية)
- [المتطلبات](#المتطلبات)
- [التثبيت والإعداد](#التثبيت-والإعداد)
- [البنية المعمارية](#البنية-المعمارية)
- [دليل الاستخدام](#دليل-الاستخدام)
- [دليل التطوير](#دليل-التطوير)
- [الحزم المستخدمة](#الحزم-المستخدمة)
- [استكشاف الأخطاء](#استكشاف-الأخطاء)

---

## ✨ المميزات الرئيسية

### 🔐 المصادقة والأمان
- ✅ تسجيل الدخول عبر البريد الإلكتروني وكلمة المرور
- ✅ إنشاء حساب جديد
- ✅ تسجيل الدخول عبر Google
- ✅ استعادة كلمة المرور
- ✅ إدارة جلسات آمنة

### 📱 ماسح الباركود
- ✅ ماسح باركود في الوقت الفعلي
- ✅ البحث عن المنتجات من قاعدة البيانات
- ✅ عرض معلومات مفصلة عن المنتج

### 🍽️ إدارة الحساسيات
- ✅ إضافة وإزالة الحساسيات المخصصة
- ✅ حفظ الحساسيات في الحساب الشخصي
- ✅ عرض تنبيهات تلقائية عند المنتجات الخطرة

### 👤 الملف الشخصي
- ✅ عرض بيانات المستخدم
- ✅ إدارة قائمة الحساسيات
- ✅ إعدادات الحساب
- ✅ تسجيل الخروج الآمن

### 📊 قاعدة البيانات
- ✅ تخزين آمن على Firebase Firestore
- ✅ مزامنة فورية للبيانات
- ✅ نسخ احتياطية تلقائية

---

## 📦 المتطلبات

### متطلبات النظام
- **Flutter SDK**: الإصدار 3.11.0 أو أحدث
- **Dart SDK**: يأتي مع Flutter
- **Android Studio** أو **Xcode** (للتطوير)
- **Java 17 أو أعلى** (لـ Android)

### الحسابات المطلوبة
- حساب **Firebase** وإنشاء مشروع
- حساب **Google Cloud** لتفعيل Google Sign In
- `google-services.json` و `GoogleService-Info.plist`

---

## 🚀 التثبيت والإعداد

### 1️⃣ استنساخ المشروع
```bash
git clone https://github.com/yourusername/allergy-guide.git
cd allergy-guide
```

### 2️⃣ تثبيت الحزم
```bash
flutter pub get
```

### 3️⃣ إعداد Firebase

#### للـ Android:
1. انتقل إلى [Firebase Console](https://console.firebase.google.com)
2. أنشئ مشروع جديد أو افتح مشروع موجود
3. اضغط على "إضافة تطبيق" واختر Android
4. اتبع الخطوات وحمّل `google-services.json`
5. ضع الملف في: `android/app/google-services.json`

#### للـ iOS:
1. اتبع نفس خطوات Android
2. حمّل `GoogleService-Info.plist`
3. أضفه إلى Xcode Project

### 4️⃣ تشغيل التطبيق

```bash
# للاختبار
flutter run

# للإصدار
flutter run --release

# للـ Android فقط
flutter run -d android

# للـ iOS فقط
flutter run -d ios
```

---

## 🏗️ البنية المعمارية

```
lib/
├── main.dart                      # نقطة دخول التطبيق
├── config/                        # إعدادات التطبيق
│   ├── app_colors.dart           # الألوان المستخدمة
│   ├── app_theme.dart            # الثيم والنمط
│   └── firebase_options.dart     # إعدادات Firebase
├── models/                        # نماذج البيانات
│   ├── user_model.dart           # نموذج المستخدم
│   ├── product_model.dart        # نموذج المنتج
│   └── allergy_model.dart        # نموذج الحساسية
├── services/                      # خدمات العمل
│   ├── auth_service.dart         # خدمة المصادقة
│   ├── firestore_service.dart    # خدمة قاعدة البيانات
│   └── barcode_service.dart      # خدمة ماسح الباركود
├── screens/                       # شاشات التطبيق
│   ├── splash_screen.dart        # شاشة البداية
│   ├── onboarding_screen.dart    # شاشة التعريف
│   ├── login_screen.dart         # شاشة تسجيل الدخول
│   ├── sign_up_screen.dart       # شاشة إنشاء حساب
│   ├── forgot_password_screen.dart
│   ├── barcode_home_screen.dart  # شاشة الماسح
│   ├── profile_screen.dart       # الملف الشخصي
│   ├── menu_screen.dart          # القائمة الجانبية
│   ├── notifications_screen.dart # إشعارات
│   ├── product_safe_screen.dart  # عرض منتج آمن
│   └── product_warning_screen.dart # عرض منتج خطر
└── widgets/                       # مكونات قابلة لإعادة الاستخدام
    ├── sign_out_dialog.dart      # نافذة تسجيل الخروج
    ├── custom_button.dart        # زر مخصص
    └── allergy_badge.dart        # شارة الحساسية
```

---

## 📖 دليل الاستخدام

### للمستخدم النهائي

#### 1. إنشاء حساب جديد
1. اضغط على "إنشاء حساب"
2. أدخل الاسم الكامل والبريد الإلكتروني وكلمة المرور
3. اضغط "التسجيل"
4. أضف حساسياتك الغذائية

#### 2. تسجيل الدخول
- استخدم بريدك وكلمة المرور أو الدخول عبر Google

#### 3. ماسح الباركود
1. اضغط على أيقونة الكاميرا
2. وجّه الكاميرا نحو الباركود
3. سيظهر تقرير يوضح ما إذا كان المنتج آمناً أم لا

#### 4. إدارة الحساسيات
1. انتقل إلى ملفك الشخصي
2. اضغط على "إدارة الحساسيات"
3. أضف أو أزل حساسيتك حسب الحاجة

---

## 💻 دليل التطوير

### هيكل المشروع

#### Services (الخدمات)
الخدمات تتولى التعامل مع المنطق التجاري الرئيسي:

```dart
// مثال: auth_service.dart
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
```

#### Screens (الشاشات)
كل شاشة مسؤولة عن عرض جزء من التطبيق:

```dart
// مثال: login_screen.dart
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  void _handleLogin() {
    // منطق تسجيل الدخول
  }
}
```

#### Models (النماذج)
تمثل هياكل البيانات في التطبيق:

```dart
// مثال: user_model.dart
class User {
  final String id;
  final String email;
  final String name;
  final List<String> allergies;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.allergies = const [],
  });
}
```

### إضافة ميزة جديدة

1. **أنشئ نموذج البيانات** (إن لزم الأمر)
2. **أنشئ الخدمة** المطلوبة
3. **أنشئ الشاشة** أو المكون
4. **أضف المسارات** في `main.dart`

### اتباع أفضل الممارسات

- ✅ استخدم **Services** للعمليات المعقدة
- ✅ فصل المنطق عن الواجهة
- ✅ استخدم `const` للـ Widgets الثابتة
- ✅ اكتب تعليقات واضحة
- ✅ استخدم أسماء وصفية للمتغيرات

---

## 📚 الحزم المستخدمة

| الحزمة | الإصدار | الوصف |
|------|--------|-------|
| `flutter` | SDK | إطار عمل Flutter |
| `firebase_core` | ^3.0.0 | مركز Firebase |
| `cloud_firestore` | ^5.0.0 | قاعدة بيانات Firestore |
| `firebase_auth` | ^6.5.2 | خدمة المصادقة |
| `google_sign_in` | ^6.3.0 | تسجيل الدخول عبر Google |
| `mobile_scanner` | ^3.5.0 | ماسح الباركود |
| `camera` | ^0.10.5+2 | وصول الكاميرا |
| `google_mlkit_barcode_scanning` | ^0.14.2 | تحليل الباركود بـ ML Kit |
| `cupertino_icons` | ^1.0.9 | أيقونات iOS |

---

## 🔧 استكشاف الأخطاء

### خطأ Firebase: "No app '[DEFAULT]' has been created"
```bash
# الحل:
1. تأكد من وجود google-services.json
2. قم بتشغيل: flutter clean && flutter pub get
3. أعد بناء التطبيق: flutter run
```

### خطأ ماسح الباركود لا يعمل
```bash
# الحل:
1. تحقق من أذونات الكاميرا في AndroidManifest.xml
2. اطلب الأذونات في وقت التشغيل
3. تأكد من تثبيت جميع الحزم
```

### خطأ في Firestore
```bash
# الحل:
1. تحقق من قواعد الأمان في Firebase Console
2. تأكد من وجود البيانات في Firestore
3. تحقق من اتصال الإنترنت
```

### تطبيق لا يبدأ
```bash
# الحل:
flutter clean
flutter pub get
flutter pub upgrade
flutter run -v  # للتفاصيل الكاملة
```

---

## 📱 معلومات الإصدار

- **الإصدار الحالي**: 1.0.0
- **حالة التطوير**: قيد التطوير
- **آخر تحديث**: يونيو 2026

---

## 👨‍💻 المساهمة

نرحب بمساهماتك! يرجى:
1. **Fork** المشروع
2. إنشاء فرع جديد (`git checkout -b feature/amazing-feature`)
3. **Commit** التغييرات (`git commit -m 'Add amazing feature'`)
4. **Push** للفرع (`git push origin feature/amazing-feature`)
5. فتح **Pull Request**

---

## 📄 الترخيص

هذا المشروع مرخص تحت [MIT License](LICENSE)

---

## 📞 التواصل والدعم

- **بريد إلكتروني**: support@allergyguide.com
- **المشاكل**: [قسم Issues](../../issues)
- **النقاشات**: [Discussions](../../discussions)

---

## 🙏 شكر وتقدير

شكراً لاستخدامك تطبيق دليل الحساسيات! نتطلع لملاحظاتك وآرائك.

---

**آخر تحديث**: 2026-06-04
