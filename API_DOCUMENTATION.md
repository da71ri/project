# 📚 توثيق الـ API والخدمات

دليل شامل لجميع الخدمات والفئات في المشروع مع أمثلة الاستخدام.

---

## 🔐 AuthService

خدمة المصادقة والتعامل مع المستخدمين.

### Methods

#### `signInWithEmail(String email, String password)`
تسجيل دخول المستخدم بالبريد وكلمة المرور.

```dart
try {
  final userCredential = await authService.signInWithEmail(
    'user@example.com',
    'password123',
  );
  print('تسجيل دخول ناجح: ${userCredential.user?.email}');
} catch (e) {
  print('خطأ: $e');
}
```

**المعاملات:**
- `email` (String): البريد الإلكتروني
- `password` (String): كلمة المرور

**القيمة المرجعة:**
- `Future<UserCredential>`: بيانات المستخدم

**الأخطاء المحتملة:**
- `user-not-found`: المستخدم غير موجود
- `wrong-password`: كلمة المرور خاطئة
- `invalid-email`: صيغة البريد خاطئة

---

#### `signUpWithEmail(String name, String email, String password)`
إنشاء حساب جديد.

```dart
try {
  final userCredential = await authService.signUpWithEmail(
    'أحمد محمد',
    'ahmad@example.com',
    'password123',
  );
  print('تم إنشاء الحساب بنجاح');
} catch (e) {
  print('خطأ: $e');
}
```

**المعاملات:**
- `name` (String): الاسم الكامل
- `email` (String): البريد الإلكتروني
- `password` (String): كلمة المرور

---

#### `signInWithGoogle()`
تسجيل الدخول عبر Google.

```dart
try {
  final userCredential = await authService.signInWithGoogle();
  print('تسجيل دخول Google ناجح');
} catch (e) {
  print('خطأ في Google Sign In: $e');
}
```

---

#### `sendPasswordResetEmail(String email)`
إرسال بريد لإعادة تعيين كلمة المرور.

```dart
try {
  await authService.sendPasswordResetEmail('user@example.com');
  print('تم إرسال بريد إعادة التعيين');
} catch (e) {
  print('خطأ: $e');
}
```

---

#### `signOut()`
تسجيل الخروج.

```dart
try {
  await authService.signOut();
  print('تم تسجيل الخروج بنجاح');
} catch (e) {
  print('خطأ: $e');
}
```

---

#### `currentUser` (Getter)
الحصول على بيانات المستخدم الحالي.

```dart
final user = authService.currentUser;
if (user != null) {
  print('المستخدم: ${user.email}');
} else {
  print('لا يوجد مستخدم مسجل دخول');
}
```

**النوع:**
- `User?`: بيانات المستخدم أو null

---

#### `authStateChanges` (Stream)
الاستماع لتغييرات حالة المصادقة.

```dart
authService.authStateChanges.listen((user) {
  if (user != null) {
    print('المستخدم مسجل دخول: ${user.email}');
  } else {
    print('المستخدم غير مسجل دخول');
  }
});
```

---

## 🗄️ FirestoreService

خدمة التعامل مع قاعدة بيانات Firestore.

### Methods

#### `getProduct(String barcode)`
الحصول على معلومات المنتج من رقم الباركود.

```dart
try {
  final product = await firestoreService.getProduct('5901234123457');
  print('اسم المنتج: ${product.name}');
  print('الشركة: ${product.company}');
  print('المكونات: ${product.ingredients.join(", ")}');
} catch (e) {
  print('خطأ: $e');
}
```

**المعاملات:**
- `barcode` (String): رقم الباركود

**القيمة المرجعة:**
- `Future<Product>`: بيانات المنتج

**الأخطاء المحتملة:**
- خطأ في الاتصال بـ Firestore
- المنتج غير موجود

---

#### `getUser(String userId)`
الحصول على بيانات المستخدم.

```dart
try {
  final user = await firestoreService.getUser('user-id-123');
  print('الاسم: ${user.name}');
  print('الحساسيات: ${user.allergies}');
} catch (e) {
  print('خطأ: $e');
}
```

---

#### `getUserAllergies(String userId)`
الحصول على قائمة حساسيات المستخدم.

```dart
try {
  final allergies = await firestoreService.getUserAllergies('user-id-123');
  for (final allergy in allergies) {
    print('حساسية: $allergy');
  }
} catch (e) {
  print('خطأ: $e');
}
```

**القيمة المرجعة:**
- `Future<List<String>>`: قائمة بأسماء الحساسيات

---

#### `updateUserAllergies(String userId, List<String> allergies)`
تحديث قائمة حساسيات المستخدم.

```dart
try {
  await firestoreService.updateUserAllergies(
    'user-id-123',
    ['فول سوداني', 'أسماك', 'بيض'],
  );
  print('تم تحديث الحساسيات');
} catch (e) {
  print('خطأ: $e');
}
```

---

## 🏷️ Model Classes

### User Model

```dart
class User {
  final String id;           // معرّف فريد
  final String email;        // البريد الإلكتروني
  final String name;         // الاسم الكامل
  final List<String> allergies;  // قائمة الحساسيات
  final DateTime createdAt;  // تاريخ الإنشاء

  User({
    required this.id,
    required this.email,
    required this.name,
    this.allergies = const [],
    required this.createdAt,
  });
}
```

**الاستخدام:**
```dart
final user = User(
  id: 'uid-123',
  email: 'user@example.com',
  name: 'أحمد محمد',
  allergies: ['فول سوداني', 'حليب'],
  createdAt: DateTime.now(),
);
```

---

### Product Model

```dart
class Product {
  final String id;           // رقم الباركود
  final String name;         // اسم المنتج
  final String company;      // الشركة المصنعة
  final List<String> ingredients;  // المكونات
  final List<String> allergens;    // المواد المسببة للحساسية
  final String? imageUrl;    // رابط الصورة

  Product({
    required this.id,
    required this.name,
    required this.company,
    required this.ingredients,
    this.allergens = const [],
    this.imageUrl,
  });
}
```

**الاستخدام:**
```dart
final product = Product(
  id: '5901234123457',
  name: 'حليب كامل الدسم',
  company: 'شركة الألبان',
  ingredients: ['حليب', 'ماء', 'ملح'],
  allergens: ['حليب'],
);
```

---

### Allergy Model

```dart
class Allergy {
  final String id;          // معرّف فريد
  final String name;        // اسم الحساسية
  final String severity;    // الخطورة: low, medium, high
  final String icon;        // أيقونة

  Allergy({
    required this.id,
    required this.name,
    required this.severity,
    required this.icon,
  });
}
```

**الاستخدام:**
```dart
final allergy = Allergy(
  id: 'peanut-1',
  name: 'فول سوداني',
  severity: 'high',
  icon: '🥜',
);
```

---

## 🎨 Widget Components

### CustomButton

زر مخصص مع دعم الحالات المختلفة.

```dart
CustomButton(
  label: 'تسجيل الدخول',
  onPressed: () {
    // إجراء
  },
  isLoading: false,
  backgroundColor: Colors.green,
)
```

**المعاملات:**
- `label` (String): نص الزر
- `onPressed` (Function): الإجراء عند الضغط
- `isLoading` (bool): حالة التحميل
- `backgroundColor` (Color): لون الخلفية

---

### AllergyCage

عرض حساسية واحدة كشارة.

```dart
AllergyBadge(
  allergyName: 'فول سوداني',
  severity: 'high',
  onRemove: () {
    // إزالة الحساسية
  },
)
```

---

### ProductCard

بطاقة المنتج.

```dart
ProductCard(
  product: product,
  isSafe: true,
  onTap: () {
    // عند الضغط
  },
)
```

---

## 🔄 State Management Examples

### Using StatefulWidget

```dart
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  late AuthService authService;
  
  @override
  void initState() {
    super.initState();
    authService = AuthService();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الشاشة')),
      body: Center(
        child: Text('محتوى الشاشة'),
      ),
    );
  }
}
```

### Using StreamBuilder

```dart
StreamBuilder<User?>(
  stream: authService.authStateChanges,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    
    if (snapshot.hasData) {
      return Text('مرحباً بـ ${snapshot.data?.email}');
    }
    
    return Text('لم تسجل دخول');
  },
)
```

### Using FutureBuilder

```dart
FutureBuilder<Product>(
  future: firestoreService.getProduct(barcode),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    
    if (snapshot.hasError) {
      return Text('خطأ: ${snapshot.error}');
    }
    
    if (snapshot.hasData) {
      return ProductCard(product: snapshot.data!);
    }
    
    return Text('لا توجد بيانات');
  },
)
```

---

## 📡 Firebase Collections Schema

### users
```javascript
{
  id: string,
  email: string,
  name: string,
  allergies: array[string],
  createdAt: timestamp,
  updatedAt: timestamp
}
```

### products
```javascript
{
  barcode: string,
  name: string,
  company: string,
  ingredients: array[string],
  allergens: array[string],
  imageUrl: string,
  createdAt: timestamp
}
```

### allergies
```javascript
{
  id: string,
  name: string,
  severity: string,
  icon: string,
  description: string
}
```

---

## ⚡ نصائح للأداء الأفضل

### 1. استخدام const حيث أمكن
```dart
// ✅ جيد
const Text('نص ثابت')

// ❌ سيء
Text('نص ثابت')
```

### 2. استخدام عمليات محدودة من Firestore
```dart
// ✅ جيد
.where('status', isEqualTo: 'active')
.limit(10)

// ❌ سيء - جلب كل البيانات
```

### 3. استخدام debounce للبحث
```dart
StreamBuilder(
  stream: searchController.stream
    .debounceTime(Duration(milliseconds: 500))
    .switchMap((query) => search(query)),
  builder: (context, snapshot) {
    // ...
  },
)
```

---

## 🐛 معالجة الأخطاء الموحدة

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

// الاستخدام في الخدمة:
try {
  // عملية
} on FirebaseException catch (e) {
  throw AppException(
    message: 'خطأ Firebase',
    code: e.code,
  );
} catch (e) {
  throw AppException(
    message: 'خطأ غير متوقع',
  );
}
```

---

## 📞 المراجع الإضافية

- [Flutter Docs](https://flutter.dev/docs)
- [Firebase Docs](https://firebase.flutter.dev)
- [Dart API Reference](https://api.dart.dev)

---

**آخر تحديث**: 2026-06-04
