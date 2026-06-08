import 'package:flutter/material.dart';

class ProfileDrawerScreen extends StatelessWidget {
  const ProfileDrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية الخضراء الفاتحة المتدرجة للتطبيق
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFDFFCEA), Color(0xFF48ED86)],
              ),
            ),
          ),
          
          SafeArea(
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // الهيدر العلوي الحامل لاسمكِ المتألق ✨
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFE8F5E9), Color(0xFFB2D3C2)],
                          ),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(32),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            CircleAvatar(
                              radius: 36,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person, size: 40, color: Colors.grey),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Lara Al-malki', // تم التعديل لاسمكِ يا لارا 🌸
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // زر الانتقال الذكي إلى لوحة تحكم الحساسيات
                      ListTile(
                        leading: const Icon(Icons.shield_outlined, color: Colors.black87),
                        title: const Text('Allergy Management', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        onTap: () {
                          // ننتقل للوحة التحكم ونمرر قائمة مبدئية فارغة أو ببعض العناصر
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AllergyDashboardScreen()),
                          );
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.account_circle_outlined, color: Colors.grey),
                        title: const Text('Account Management', style: TextStyle(fontSize: 16, color: Colors.grey)),
                        onTap: () {},
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.redAccent),
                        title: const Text('Sign Out', style: TextStyle(color: Colors.redAccent, fontSize: 16)),
                        onTap: () {},
                      ),
                    ],
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


class AllergyDashboardScreen extends StatefulWidget {
  const AllergyDashboardScreen({super.key});

  @override
  State<AllergyDashboardScreen> createState() => _AllergyDashboardScreenState();
}

class _AllergyDashboardScreenState extends State<AllergyDashboardScreen> {
  // القائمة الشخصية للمستخدم (تبدأ ببعض العناصر وتتحدث ديناميكياً)
  List<Map<String, dynamic>> userAllergies = [
    {'name': 'Gluten', 'icon': Icons.bakery_dining},
    {'name': 'Dairy', 'icon': Icons.local_drink},
    {'name': 'Soy', 'icon': Icons.eco},
  ];

  // دالة الحذف الحقيقية مع بوب أب التأكيد الجميل المطابق لتصميمكِ الأخضر
  void _openDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFE8F5E9), Color(0xFF48ED86)], // التدرج الأخضر حق صورتكِ
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Are you sure you want to delete this allergy',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // زر التراجع
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        minimumSize: const Size(100, 44),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    // زر الحذف الفعلي التفاعلي
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B6B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        minimumSize: const Size(100, 44),
                      ),
                      onPressed: () {
                        setState(() {
                          userAllergies.removeAt(index); // يحذف العنصر من الشاشة والسيستم فوراً!
                        });
                        Navigator.pop(context); // إغلاق البوب أب
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFB2D3C2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Allergy Guide', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // بار البحث
          Container(
            color: const Color(0xFFB2D3C2),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for food or Ingredients...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // عرض القائمة التفاعلية للمستخدم
          Expanded(
            child: userAllergies.isEmpty
                ? const Center(
                    child: Text('No allergies managed yet. Click + to add!', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  )
                : ListView.builder(
                    itemCount: userAllergies.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(userAllergies[index]['icon'] ?? Icons.eco, color: Colors.orange),
                          ),
                          title: Text(
                            userAllergies[index]['name'],
                            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Color(0xFFFF6B6B)),
                            onPressed: () => _openDeleteConfirmation(index), // استدعاء نافذة الحذف التفاعلية
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      
      // زر الزائد (+) العائم للانتقال لسيستم الاختيارات العام
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF6B6B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () async {
          // ننتظر الشاشة العامة ترجع لنا الحساسيات الجديدة اللي تم اختيارها بالصح!
          final List<Map<String, dynamic>>? selectedFromCatalog = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GlobalAllergySelectionScreen(currentSelected: userAllergies),
            ),
          );

          if (selectedFromCatalog != null) {
            setState(() {
              userAllergies = selectedFromCatalog; // نحدث القائمة الأساسية لتظهر فوراً على لوحة التحكم!
            });
          }
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}


class GlobalAllergySelectionScreen extends StatefulWidget {
  final List<Map<String, dynamic>> currentSelected;
  const GlobalAllergySelectionScreen({super.key, required this.currentSelected});

  @override
  State<GlobalAllergySelectionScreen> createState() => _GlobalAllergySelectionScreenState();
}

class _GlobalAllergySelectionScreenState extends State<GlobalAllergySelectionScreen> {
  // كتالوج السيستم الشامل؛ مضافاً إليه خيارات جديدة وممتعة من عندي كما طلبتِ! 🌟
  late List<Map<String, dynamic>> catalogAllergies;

  @override
  void initState() {
    super.initState();
    
    // قائمة السيستم الكبرى المليئة بالخيارات
    List<Map<String, dynamic>> systemCatalog = [
      {'name': 'Gluten', 'icon': Icons.bakery_dining},
      {'name': 'Dairy', 'icon': Icons.local_drink},
      {'name': 'Soy', 'icon': Icons.eco},
      {'name': 'Shellfish', 'icon': Icons.set_meal},
      {'name': 'Nuts', 'icon': Icons.lunch_dining},
      {'name': 'Ground Milk', 'icon': Icons.water_drop},
      // 🍏 خيارات إضافية ذكية من السيستم لتبدو الشاشة غنية واحترافية:
      {'name': 'Peanuts', 'icon': Icons.breakfast_dining},
      {'name': 'Fish', 'icon': Icons.phishing},
      {'name': 'Eggs', 'icon': Icons.egg_alt},
      {'name': 'Wheat', 'icon': Icons.grass},
      {'name': 'Sesame', 'icon': Icons.grain},
    ];

    // نقوم بفحص وتحديد ما كان مختاراً مسبقاً في لوحة التحكم بشكل تفاعلي ذكي
    catalogAllergies = systemCatalog.map((item) {
      bool alreadySelected = widget.currentSelected.any((userItem) => userItem['name'] == item['name']);
      return {
        'name': item['name'],
        'icon': item['icon'],
        'selected': alreadySelected, // تفعيل الصح الأخضر أو الدائرة الرمادية تلقائياً
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF48ED86), // اللون الأخضر الأساسي المعتمد عندكِ
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Allergy Guide', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // حقل البحث الموحد العلوي
          Container(
            color: const Color(0xFFB2D3C2),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for food or Ingredients...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // عرض القائمة الشاملة للسيستم مع إمكانية التبديل بالاختيار
          Expanded(
            child: ListView.builder(
              itemCount: catalogAllergies.length,
              itemBuilder: (context, index) {
                bool isSelected = catalogAllergies[index]['selected'];
                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(catalogAllergies[index]['icon'], color: Colors.orange),
                    ),
                    title: Text(
                      catalogAllergies[index]['name'],
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    
                    // تحويل الدائرة لزر تفاعلي يضيف ويشيل الصح الأخضر! 🟢⚪
                    trailing: GestureDetector(
                      onTap: () {
                        setState(() {
                          catalogAllergies[index]['selected'] = !catalogAllergies[index]['selected'];
                        });
                      },
                      child: isSelected
                          ? const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 28)
                          : const Icon(Icons.circle, color: Colors.black26, size: 28),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // زر الحفظ التأكيدي (Confirm) لإرجاع الحساسيات المختارة للوحة التحكم
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                // نفلتر فقط العناصر التي تحتوي على صح أخضر ونعيدها للشاشة السابقة
                List<Map<String, dynamic>> finalSelection = catalogAllergies
                    .where((item) => item['selected'] == true)
                    .map((item) => {'name': item['name'], 'icon': item['icon']})
                    .toList();
                
                Navigator.pop(context, finalSelection); // العودة وإرسال البيانات للـ Dashboard فوراً! 🚀
              },
              child: const Text('Confirm', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}