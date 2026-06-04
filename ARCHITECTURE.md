# 🏛️ البنية المعمارية

وثائق تفصيلية عن بنية المشروع والمعمارية المستخدمة.

---

## 📊 نظرة عامة

المشروع يستخدم **معمارية الخدمات (Service-Based Architecture)** مع فصل واضح بين:
- **Layer الواجهة** (Presentation): الشاشات والمكونات
- **Layer العمل** (Business): الخدمات والمنطق
- **Layer البيانات** (Data): Firebase وقاعدة البيانات

```
┌─────────────────────────────────────────────────┐
│           Presentation Layer                    │
│  (Screens & Widgets)                            │
├─────────────────────────────────────────────────┤
│           Business Logic Layer                  │
│  (Services & State Management)                  │
├─────────────────────────────────────────────────┤
│           Data Layer                            │
│  (Firebase, Firestore, APIs)                    │
└─────────────────────────────────────────────────┘
```

---

## 📁 هيكل المشروع المفصل

```
lib/
├── main.dart
│   └── نقطة دخول التطبيق + تهيئة Firebase
│
├── config/
│   ├── app_colors.dart
│   │   └── ألوان موحدة (primaryGreen, lightGreen, إلخ)
│   ├── app_theme.dart
│   │   └── تعريف الثيم والأنماط
│   └── firebase_options.dart
│       └── إعدادات Firebase للمنصات المختلفة
│
├── models/
│   ├── user_model.dart
│   │   └── User {id, email, name, allergies, createdAt}
│   ├── product_model.dart
│   │   └── Product {id, barcode, name, company, ingredients}
│   ├── allergy_model.dart
│   │   └── Allergy {id, name, severity, icon}
│   └── onboarding_page.dart
│       └── OnboardingPage {icon, title, description}
│
├── services/
│   ├── auth_service.dart
│   │   ├── signInWithEmail()
│   │   ├── signUpWithEmail()
│   │   ├── signInWithGoogle()
│   │   ├── sendPasswordResetEmail()
│   │   ├── signOut()
│   │   ├── currentUser (getter)
│   │   └── authStateChanges (stream)
│   │
│   ├── firestore_service.dart
│   │   ├── getProduct(barcode)
│   │   ├── getUser(userId)
│   │   ├── getUserAllergies(userId)
│   │   ├── updateUserAllergies(userId, allergies)
│   │   ├── saveUser(user)
│   │   └── updateUserProfile(userId, data)
│   │
│   └── barcode_service.dart
│       ├── scanBarcode()
│       ├── validateBarcode()
│       └── checkProductSafety(product, allergies)
│
├── screens/
│   ├── splash_screen.dart
│   │   └── شاشة تحميل بتأثيرات متحركة (3 ثواني)
│   │
│   ├── onboarding_screen.dart
│   │   └── عرض شرائح للمميزات (PageView + Indicators)
│   │
│   ├── login_screen.dart
│   │   ├── البريد الإلكتروني
│   │   ├── كلمة المرور
│   │   ├── Google Sign In
│   │   └── نسيت كلمة المرور
│   │
│   ├── sign_up_screen.dart
│   │   ├── الاسم الكامل
│   │   ├── البريد
│   │   ├── كلمة المرور
│   │   └── تأكيد كلمة المرور
│   │
│   ├── forgot_password_screen.dart
│   │   └── إعادة تعيين كلمة المرور
│   │
│   ├── barcode_home_screen.dart
│   │   ├── ماسح الباركود (MobileScanner)
│   │   ├── معالجة النتائج
│   │   └── Bottom Navigation (3 أيقونات)
│   │
│   ├── profile_screen.dart
│   │   ├── بيانات المستخدم
│   │   ├── قائمة الحساسيات
│   │   └── Bottom Navigation
│   │
│   ├── menu_screen.dart
│   │   ├── قائمة الخيارات
│   │   ├── إدارة الحساسيات
│   │   ├── إدارة الحساب
│   │   └── تسجيل الخروج
│   │
│   ├── notifications_screen.dart
│   │   └── الإشعارات والرسائل
│   │
│   ├── product_safe_screen.dart
│   │   ├── صورة المنتج
│   │   ├── البيانات
│   │   ├── قائمة المكونات (أخضر)
│   │   └── شارة "آمن"
│   │
│   └── product_warning_screen.dart
│       ├── صورة المنتج
│       ├── المكونات الخطرة (مظللة بالأحمر)
│       ├── قائمة المواد المسببة للحساسية
│       └── شارة "خطر"
│
└── widgets/
    ├── sign_out_dialog.dart
    │   └── نافذة تأكيد تسجيل الخروج
    ├── custom_button.dart
    │   └── زر مخصص (Primary, Secondary)
    ├── allergy_badge.dart
    │   └── عرض حساسية واحدة
    ├── product_card.dart
    │   └── بطاقة المنتج
    └── loading_widget.dart
        └── عرض حالة التحميل
```

---

## 🔄 تدفق البيانات

### 1. تسجيل الدخول
```
LoginScreen
    ↓ (البريد + كلمة المرور)
AuthService.signInWithEmail()
    ↓
FirebaseAuth
    ↓ (النتيجة)
BarcodeHomeScreen
```

### 2. ماسح الباركود
```
BarcodeHomeScreen
    ↓ (الباركود الممسوح)
BarcodeService.scanBarcode()
    ↓
FirestoreService.getProduct()
    ↓
Firebase Firestore
    ↓ (بيانات المنتج)
BarcodeService.checkProductSafety()
    ↓
ProductSafeScreen / ProductWarningScreen
```

### 3. إدارة الحساسيات
```
MenuScreen / AllergiesScreen
    ↓ (إضافة/حذف حساسية)
FirestoreService.updateUserAllergies()
    ↓
Firebase Firestore
    ↓ (تحديث بيانات المستخدم)
ProfileScreen (تحديث)
```

---

## 🎯 مسؤوليات كل Layer

### Presentation Layer (Screens & Widgets)
**المسؤولية:** عرض الواجهة والتعامل مع التفاعلات

```dart
// مثال: LoginScreen
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  Future<void> _handleLogin() async {
    // استدعاء الخدمة
    try {
      await authService.signInWithEmail(
        _emailController.text,
        _passwordController.text,
      );
      // الملاح للشاشة التالية
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // عرض الخطأ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // واجهة تسجيل الدخول
    );
  }
}
```

### Business Logic Layer (Services)
**المسؤولية:** المنطق التجاري والعمليات المعقدة

```dart
// مثال: AuthService
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  Future<UserCredential> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception('فشل تسجيل الدخول: ${e.message}');
    }
  }
  
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      throw Exception('فشل تسجيل الخروج: $e');
    }
  }
}
```

### Data Layer (Firebase & Firestore)
**المسؤولية:** التعامل مع البيانات والاتصالات

```dart
// مثال: FirestoreService
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<Product> getProduct(String barcode) async {
    try {
      final doc = await _firestore
          .collection('products')
          .doc(barcode)
          .get();
      
      if (!doc.exists) {
        throw Exception('المنتج غير موجود');
      }
      
      return Product.fromMap(doc.data()!);
    } catch (e) {
      throw Exception('خطأ في جلب المنتج: $e');
    }
  }
}
```

---

## 🔐 معالجة الأخطاء

### Pattern الخطأ الموحد
```dart
class AppException implements Exception {
  final String message;
  final String? code;
  
  AppException({
    required this.message,
    this.code,
  });
  
  @override
  String toString() => message;
}

// في الخدمة:
try {
  // عملية
} on FirebaseAuthException catch (e) {
  throw AppException(
    message: 'خطأ في المصادقة',
    code: e.code,
  );
} catch (e) {
  throw AppException(
    message: 'خطأ غير متوقع',
  );
}

// في الشاشة:
try {
  await service.doSomething();
} on AppException catch (e) {
  // عرض الخطأ
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.message)),
  );
}
```

---

## 📡 تدفق Firebase

### Cloud Firestore Collections
```
users/
├── {userId}/
│   ├── email: string
│   ├── name: string
│   ├── allergies: array[string]
│   ├── createdAt: timestamp
│   └── updatedAt: timestamp

products/
├── {barcode}/
│   ├── name: string
│   ├── company: string
│   ├── ingredients: array[string]
│   ├── allergenic_ingredients: array[string]
│   └── image_url: string

allergies/
├── {allergyId}/
│   ├── name: string
│   ├── severity: "low" | "medium" | "high"
│   └── icon: string
```

### Firebase Rules
```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    // المستخدمون يرون ملفاتهم فقط
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // المنتجات للجميع للقراءة فقط
    match /products/{document=**} {
      allow read: if request.auth != null;
    }
    
    // الحساسيات للجميع للقراءة
    match /allergies/{document=**} {
      allow read: if request.auth != null;
    }
  }
}
```

---

## 🎨 نمط التصميم المستخدم

### 1. Service Locator (للخدمات)
```dart
final authService = AuthService();
final firestoreService = FirestoreService();
final barcodeService = BarcodeService();
```

### 2. Provider Pattern (للبيانات المشتركة)
```dart
// مثال للاستخدام المستقبلي
class AuthProvider with ChangeNotifier {
  User? _user;
  
  User? get user => _user;
  
  Future<void> login(String email, String password) async {
    // ...
    notifyListeners();
  }
}
```

### 3. Builder Pattern (للـ Widgets)
```dart
Builder(
  builder: (context) {
    return Text('محتوى معقد');
  },
)
```

---

## ✅ أفضل الممارسات المتبعة

1. **فصل المسؤوليات**: كل فئة لها مسؤولية واحدة
2. **Dependency Injection**: الخدمات تُحقن في الشاشات
3. **Error Handling**: معالجة شاملة للأخطاء
4. **Async/Await**: للعمليات غير المتزامنة
5. **Null Safety**: كود آمن من null
6. **Widget Composition**: إعادة استخدام المكونات
7. **State Management**: فصل الحالة عن العرض

---

## 🚀 كيفية إضافة ميزة جديدة

### 1. أنشئ النموذج (إن لزم)
```dart
// lib/models/new_model.dart
class NewModel {
  final String id;
  final String name;
  
  NewModel({required this.id, required this.name});
}
```

### 2. أنشئ الخدمة
```dart
// lib/services/new_service.dart
class NewService {
  Future<NewModel> getData() async {
    // المنطق
  }
}
```

### 3. أنشئ الشاشة
```dart
// lib/screens/new_screen.dart
class NewScreen extends StatefulWidget {
  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  final NewService _service = NewService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // الواجهة
    );
  }
}
```

### 4. أضف المسار
```dart
// في main.dart
routes: {
  '/new': (context) => const NewScreen(),
}
```

---

## 📚 المراجع

- [Flutter Architecture Best Practices](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.flutter.dev)
- [Dart Guidelines](https://dart.dev/guides)
