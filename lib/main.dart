import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({Key? key, required this.camera}) : super(key: key);

  //Home screen

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BarcodeHomeScreen(camera: camera),
    );
  }
}

class BarcodeHomeScreen extends StatefulWidget {
  final CameraDescription camera;

  const BarcodeHomeScreen({Key? key, required this.camera}) : super(key: key);

  @override
  State<BarcodeHomeScreen> createState() => _BarcodeHomeScreenState();
}

class _BarcodeHomeScreenState extends State<BarcodeHomeScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  int _currentIndex = 1; 

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, 
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: CameraPreview(_controller),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          const Center(
            child: SizedBox(
              width: 200, 
              height: 200,
              child: Stack(
                children: [
                  Positioned(top: 0, left: 0, child: BuildCorner(top: true, left: true)),
                  Positioned(top: 0, right: 0, child: BuildCorner(top: true, left: false)),
                  Positioned(bottom: 0, left: 0, child: BuildCorner(bottom: true, left: true)),
                  Positioned(bottom: 0, right: 0, child: BuildCorner(bottom: true, left: false)),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BuildBarcodeLine(height: 100, width: 8),
                        SizedBox(width: 6),
                        BuildBarcodeLine(height: 100, width: 4),
                        SizedBox(width: 8),
                        BuildBarcodeLine(height: 100, width: 12),
                        SizedBox(width: 6),
                        BuildBarcodeLine(height: 100, width: 6),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF52C47D), 
        ),
        child: SafeArea(
          child: SizedBox(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications_none_rounded, 
                    color: _currentIndex == 0 ? Colors.black : Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    setState(() { _currentIndex = 0; });
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.black,
                      size: 28,
                    ),
                    onPressed: () {
                      setState(() { _currentIndex = 1; });
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.person_outline_rounded,
                    color: _currentIndex == 2 ? Colors.black : Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    setState(() { _currentIndex = 2; });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuildCorner extends StatelessWidget {
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  const BuildCorner({
    Key? key,
    this.top = false,
    this.bottom = false,
    this.left = false,
    this.right = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double length = 25;
    const double thickness = 5;
    const Color cornerColor = Color(0xFF4A4A4A); 

    return Container(
      width: length,
      height: length,
      decoration: BoxDecoration(
        border: Border(
          top: top ? const BorderSide(color: cornerColor, width: thickness) : BorderSide.none,
          bottom: bottom ? const BorderSide(color: cornerColor, width: thickness) : BorderSide.none,
          left: left ? const BorderSide(color: cornerColor, width: thickness) : BorderSide.none,
          right: right ? const BorderSide(color: cornerColor, width: thickness) : BorderSide.none,
        ),
      ),
    );
  }
}

class BuildBarcodeLine extends StatelessWidget {
  final double height;
  final double width;

  const BuildBarcodeLine({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFF4A4A4A),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

// After scanning safe
class ProductSafeScreen extends StatelessWidget {
  final String productName;
  final String companyName;
  final List<String> ingredients;

  const ProductSafeScreen({
    Key? key,
    required this.productName,
    required this.companyName,
    required this.ingredients,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: const Color(0xFF52C47D),
            child: SafeArea(
              bottom: false,
              child: Container(
                height: 56,
                padding: const EdgeInsets.horizontal(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black, size: 32),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 220,
                    color: const Color(0xFFE5E5E5),
                    child: const Center(
                      child: Icon(
                        Icons.qr_code_scanner_rounded,
                        size: 80,
                        color: Color(0xFF4A4A4A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.horizontal(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product: $productName',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Company: $companyName',
                          style: const TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Colors.black38, thickness: 1),
                        const SizedBox(height: 16),
                        const Text(
                          'INGREDIENTS',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 0.5),
                        ),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: ingredients.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Text(
                                ingredients[index],
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Container(width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFD4EDDA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFC3E6CB), width: 1),
              ),
              child: const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.gpp_good_outlined, color: Color(0xFF155724), size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Safe',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF155724)),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.gpp_good_outlined, color: Color(0xFF155724), size: 24),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Eat it safely',
                    style: TextStyle(fontSize: 14, color: Color(0xFF155724), fontWeight: FontWeight.w500),
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

// After scanning warning
class ProductWarningScreen extends StatelessWidget {
  final String productName;
  final String companyName;
  final List<String> ingredients;
  final List<String> allergicIngredients;    

  const ProductWarningScreen({
    Key? key,
    required this.productName,
    required this.companyName,
    required this.ingredients,
    required this.allergicIngredients,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String allergiesText = allergicIngredients.join(', ');
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: const Color(0xFF52C47D),
            child: SafeArea(
              bottom: false,
              child: Container(
                height: 56,
                padding: const EdgeInsets.horizontal(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black, size: 32),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 220,
                    color: const Color(0xFFE5E5E5),
                    child: const Center(
                      child: Icon(
                        Icons.qr_code_scanner_rounded,
                        size: 80,
                        color: Color(0xFF4A4A4A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.horizontal(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product: $productName',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Company: $companyName',
                          style: const TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Colors.black38, thickness: 1),
                        const SizedBox(height: 16),
                        const Text(
                          'INGREDIENTS',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 0.5),
                        ),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: ingredients.length,
                          itemBuilder: (context, index) {
                            final ingredient = ingredients[index];
                            // فحص هل هذا المكون يسبب حساسية لتلوينه بالأحمر
                            final isAllergic = allergicIngredients.contains(ingredient);

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Text(
                                ingredient,
                                style: TextStyle(
                                  fontSize: 15, 
                                  fontWeight: isAllergic ? FontWeight.bold : FontWeight.w500, 
                                  color: isAllergic ? Colors.red : Colors.black87,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8D7DA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF5C6CB), width: 1),
              ),
              child: Column(
                children: [
                  const Text(
                    'WARNING',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF721C24), letterSpacing: 1),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'This product contains: $allergiesText.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF721C24), fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      // كود صفحة البدائل لاحقاً
                    },
                    child: const Text(
                      'Click here to view alternatives',
                      style: TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                    ),
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
// Profile Screen
class ProfileScreen extends StatelessWidget {
  // متغيرات تستقبل بيانات المستخدم الحقيقية من صفحة تسجيل الدخول أو الفايربيس
  final String userName;
  final List<String> userAllergies; 

  const ProfileScreen({
    Key? key,
    required this.userName,
    required this.userAllergies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // نمرر اسم المستخدم والمنيو لكي يعرضهم جوه القائمة الجانبية
      drawer: CustomSideMenu(userName: userName),
      body: Column(
        children: [
          // الجزء العلوي الأخضر
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 24),
            decoration: const BoxDecoration(
              color: Color(0xFF52C47D),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Row(
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu_rounded, color: Colors.black, size: 30),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.person_rounded, size: 60, color: Color(0xFF4A4A4A)),
                  ),
                  const SizedBox(height: 16),
                  // هنا يعرض اسم اليوزر اللي دخل الحين تلقائياً
                  Text(
                    userName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          // الجزء الأبيض السفلي (الحساسيات)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Allergies',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  // يعرض فقط الحساسيات التي اختارها هذا المستخدم ديناميكياً
                  userAllergies.isEmpty
                      ? const Text('No allergies selected', style: TextStyle(color: Colors.black38))
                      : Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: userAllergies.map((allergy) => _buildAllergyItem(allergy)).toList(),
                        ),
                ],
              ),
            ),
          ),
          _buildBottomNavigationBar(context),
        ],
      ),
    );
  }

  // ويدجت تعرض شكل مربع الحساسية بناءً على الاسم القادم من الكود
  Widget _buildAllergyItem(String allergyName) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFEEBA)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_amber_rounded, size: 20, color: Color(0xFF856404)),
          const SizedBox(width: 6),
          Text(
            allergyName,style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF856404)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF52C47D),
        border: Border(top: BorderSide(color: Colors.black.withOpacity(0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: Colors.black45, size: 28),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt_rounded, color: Colors.black45, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            icon: const Icon(Icons.person_rounded, color: Colors.black, size: 32),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
// Side Menu Screen
class CustomSideMenu extends StatelessWidget {
  final String userName; // تستقبل الاسم من صفحة البروفايل تلقائياً

  const CustomSideMenu({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.65,
      child: Drawer(
        elevation: 0,
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: const Color(0xFF52C47D),
                padding: const EdgeInsets.only(bottom: 20),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 20),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                        child: const Icon(Icons.person_rounded, size: 45, color: Color(0xFF4A4A4A)),
                      ),
                      const SizedBox(height: 10),
                      // الاسم الحقيقي للمستخدم الحالي
                      Text(
                        userName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.shield_outlined, color: Colors.black54),
                      title: const Text('Allergy Management', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.account_circle_outlined, color: Colors.black54),
                      title: const Text('Account Management', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.logout_rounded, color: Colors.red),
                      title: const Text('Sign Out', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red)),
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          barrierDismissible: false,
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
      ),
    );
  }
}
