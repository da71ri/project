import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     
      debugShowCheckedModeBanner: false,
      home: BarcodeHomeScreen(
        userId: "12345",
),
      routes: {
  "/home": (context) => BarcodeHomeScreen(
    userId: "12345",
  ),

  "/profile": (context) => ProfileScreen(
    userName: "Dana",
  ),

  "/menu": (context) => MenuScreen(
    userName: "Dana",
  ),

  "/signout": (context) => SignOutDialog(),

  "/safe": (context) => ProductSafeScreen(
    productName: "productName",
    companyName: "companyName",
    ingredients: ["ingredient1", "ingredient2", "ingredient3"],
  ),

  "/danger": (context) => ProductWarningScreen(
    productName: "productName",
    companyName: "companyName",
    ingredients: ["ingredient1", "ingredient2", "ingredient3"],
    allergicIngredients: ["ingredient1"],
  ),
}

    );
  }
}

class BarcodeHomeScreen extends StatefulWidget {
  final String userId; // رقم المستخدم لجلب حساسيته

  const BarcodeHomeScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<BarcodeHomeScreen> createState() => _BarcodeHomeScreenState();
}

class _BarcodeHomeScreenState extends State<BarcodeHomeScreen> {
  bool isProcessing = false;

  // الدالة الأساسية: تصوير + قراءة + فايربيس + مقارنة + توجيه
  Future<void> scanProduct(String barcodeValue) async {
    if (isProcessing) return;
    setState(() => isProcessing = true);

    try {

      // 3) جلب بيانات المنتج من فايربيس
      var productSnapshot = await FirebaseFirestore.instance
          .collection("products")
          .doc(barcodeValue)
          .get();

          if (!productSnapshot.exists) {
            setState(() => isProcessing = false);}

      String productName = productSnapshot["name"];
      String companyName = productSnapshot["company"];
      List<String> ingredients =
          List<String>.from(productSnapshot["ingredients"]);

      // 4) جلب حساسية المستخدم
      var userSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .get();

      List<String> userAllergies =
          List<String>.from(userSnapshot["allergies"]);

      // 5) المقارنة
      List<String> dangerousIngredients = ingredients
          .where((item) => userAllergies.contains(item))
          .toList();

      // 6) التوجيه
      if (dangerousIngredients.isEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductSafeScreen(
              productName: productName,
              companyName: companyName,
              ingredients: ingredients,
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductWarningScreen(
              productName: productName,
              companyName: companyName,
              ingredients: ingredients,
              allergicIngredients: dangerousIngredients,
            ),
          ),
        );
      }
    } catch (e) {
      print("Error: $e");
    }

    setState(() => isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // الكاميرا
  MobileScanner(
  onDetect: (BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      debugPrint('Barcode found! ${barcode.rawValue}');
    }
  },
),
          // الشريط السفلي الأخضر
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 85,
              decoration: const BoxDecoration(
                color: Color(0xFF52C47D),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // زر البروفايل
                  IconButton(
                    icon: const Icon(Icons.person_rounded,
                        size: 32, color: Colors.black,),
                    onPressed: () {
                      Navigator.push(
                        context,
                    MaterialPageRoute(
                      builder:(context) => const ProfileScreen(
                      userName: "Dana",
                    ),
                    ),
                    );
                    },
                  ),

                  // زر الكاميرا
                 GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MobileScanner(
          onDetect: ( capture) {
            final List<Barcode> barcodes = capture.barcodes;
            if (barcodes.isNotEmpty) {
              final String? code = barcodes.first.rawValue;
              if (code != null) {
                Navigator.pop(context); // إغلاق الكاميرا
                scanProduct(code);      // استدعاء الدالة
              }
            }
          },
        ),
      ),
    );
  },
  child: Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 3)),
    ]),
    child: const Icon(Icons.camera_alt_rounded, size: 32, color: Colors.black),
  ),
),

                  // زر الجرس
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded,
                        size: 30, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String userName;

const ProfileScreen({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      drawer: Drawer(),

      body: Column(
        children: [
          // الهيدر الأخضر
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 40, bottom: 30),
            decoration: BoxDecoration(
              color: Color(0xFF52C47D),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: Icon(Icons.menu_rounded, size: 30, color: Colors.black),
                        onPressed: () { Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MenuScreen(userName: "Dana"))); },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.4),
                  ),
                  child: Icon(Icons.person_rounded, size: 60, color: Colors.black54),
                ),

                SizedBox(height: 12),

                Text(
                  userName,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),

          SizedBox(height: 25),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'My Allergies',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ),
          ),

          SizedBox(height: 15),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Wrap(
              spacing: 15,
              runSpacing: 15,
            ),
          ),

          SizedBox(height: 40),

          Expanded(child: Container()),

          Container(
            height: 85,
            color: Color(0xFF52C47D),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.notifications_none_rounded, size: 30, color: Colors.black),
                  onPressed: () {},
                ),

                IconButton(
                  icon: Icon(Icons.camera_alt_rounded, size: 32, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                Icon(Icons.person_rounded, size: 32, color: Colors.black),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class MenuScreen extends StatelessWidget {
  final String userName;

  const MenuScreen({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
     body: Row(
        children: [
          // المستطيل الأبيض الخاص بالمنيو
          Container(
            width: MediaQuery.of(context).size.width * 0.65, // يأخذ 65% من عرض الشاشة
            height: double.infinity,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                
                // 1) الهيدر الأخضر
                Container(
                  padding: const EdgeInsets.only(top: 50, bottom: 25, left: 10, right: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF52C47D),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(35),
                    ),
                  ),
                  child: Column(
                    children: [
                      // سهم الرجوع
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // صورة البروفايل داخل الهيدر
                      Container(
                        width: 75,
                        height: 75,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white24,
                        ),
                        child: const Icon(Icons.person_rounded, size: 45, color: Colors.black54),
                      ),
                      const SizedBox(height: 10),
                      // اسم المستخدم
                      Text(
                        userName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),

                // 2) قائمة الأزرار (تحت الهيدر الأخضر مباشرة)
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.health_and_safety_outlined, color: Colors.black),
                        title: const Text("Allergy Management", style: TextStyle(fontSize: 16, color: Colors.black)),
                        onTap: () {
                          // هنا تيم الحساسية يربط صفحته
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.manage_accounts_outlined, color: Colors.black),
                        title: const Text("Account Management", style: TextStyle(fontSize: 16, color: Colors.black)),
                        onTap: () {
                          // هنا التيم الثاني يربط صفحته
                        },
                      ),
                      const Divider(), // خط فاصل جمالي
                      ListTile(
                        leading: const Icon(Icons.logout_rounded, color: Colors.red),
                        title: const Text("Sign Out", style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold)),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => const SignOutDialog(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // المساحة الشفافة الباقية من الشاشة (إذا ضغط عليها اليوزر يقفل المنيو)
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(color: Colors.white.withOpacity(0.3)), // تظليل خفيف جداً خلف المنيو
            ),
          ),
        ],
      ),
    );
  }
}

class SignOutDialog extends StatelessWidget {
  const SignOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // طبقة شفافة
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            color: Colors.black.withOpacity(0.4),
          ),
        ),

        // مربع تسجيل الخروج الأخضر
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF52C47D), // أخضر
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // العنوان
                Text(
                  "⁠Sign Out?⁠",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: 10),

                // النص
                Text(
                  "Are you sure you want to sign out?⁠",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: 20),

                // الأزرار
                Row(
                  children: [
                    // زر تسجيل خروج (أحمر)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // يودّي لأول صفحة في التطبيق (التيم الثاني)
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Center(
                            child: Text(
                              "Sign Out",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 20),


                    // زر Cancel (أبيض)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // يرجع للمنيو
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ProductSafeScreen extends StatelessWidget {
  final String productName;          // اسم المنتج من الفايربيس
  final String companyName;          // اسم الشركة من الفايربيس
  final List<String> ingredients;    // قائمة المكونات

  const ProductSafeScreen({
    super.key,
    required this.productName,
    required this.companyName,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الهيدر الأخضر
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 40, bottom: 15),
            color: Color(0xFF52C47D),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      size: 22, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context); // يرجع لصفحة الكام
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 15),

          // مستطيل الصورة (بدون لون – بدون أيقونة)
          Container(
            width: double.infinity,
            height: 360,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                color: Colors.grey[300],
                child: Center(
                  child: Icon(Icons.qr_code_scanner, size: 80, color: Colors.grey[700]),
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          // اسم المنتج
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              productName,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          // اسم الشركة
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              companyName,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),

          SizedBox(height: 15),

          // خط أسود
          Container(
            width: double.infinity,
            height: 1.5,
            color: Colors.black,
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),

          SizedBox(height: 15),

          // عنوان المكونات
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "INGREDIENTS",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          SizedBox(height: 10),

          // قائمة المكونات (كلها آمنة)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ingredients
                  .map(
                    (item) => Padding(
                      padding: EdgeInsets.only(bottom: 6),
                      child: Text(
                        item,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          Spacer(),

          // المستطيل الأخضر (SAFE)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 25),
            color: Color(0xFF52C47D),
            child: Column(
              children: [
                Text(
                  "SAFE",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Eat it safely",
                  style: TextStyle(
                    fontSize: 15,color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class ProductWarningScreen extends StatelessWidget {
  final String productName;
  final String companyName;
  final List<String> ingredients;          // كل المكونات
  final List<String> allergicIngredients;  // المكونات اللي المستخدم حساس لها

  const ProductWarningScreen({
    super.key,
    required this.productName,
    required this.companyName,
    required this.ingredients,
    required this.allergicIngredients,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الهيدر الأخضر
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 40, bottom: 15),
            color: Color(0xFF52C47D),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      size: 22, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 15),

          // صورة المنتج
          Container(
            width: double.infinity,
            height: 360,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                color:Colors.grey[300],
                child: Center(
                  child: Icon(Icons.qr_code_scanner, size:80,color: Colors.grey[700]),)
              ),
            ),
          ),

          SizedBox(height: 20),

          // اسم المنتج
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              productName,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          // اسم الشركة
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              companyName,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),

          SizedBox(height: 15),

          // خط
          Container(
            width: double.infinity,
            height: 1.5,
            color: Colors.black,
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),

          SizedBox(height: 15),

          // عنوان المكونات
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "INGREDIENTS",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          SizedBox(height: 10),

          // قائمة المكونات (الخطر أحمر)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ingredients
                  .map(
                    (item) => Padding(
                      padding: EdgeInsets.only(bottom: 6),
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 16,
                          color: allergicIngredients.contains(item)
                              ? Colors.red
                              : Colors.black,
                          fontWeight: allergicIngredients.contains(item)
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          Spacer(),

          // المستطيل الأحمر (DANGEROUS)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 25),
            color: Colors.red,
            child: Column(
              children: [
                Text(
                  "DANGEROUS",
                  style: TextStyle(
                    fontSize: 26,fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  "This product contains:",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 5),

                // قائمة المكونات الخطيرة
                Text(
                  allergicIngredients.join(", "),
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 15),

                // زر البدائل الآمنة
                GestureDetector(
                  onTap: () {
                    // التيم الثاني بيربطه
                  },
                  child: Text(
                    "Click here to view safe alternatives",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}