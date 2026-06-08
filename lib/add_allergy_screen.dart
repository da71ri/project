import 'package:flutter/material.dart';
import 'confirm_screen.dart'; // استدعاء شاشة التأكيد التالية

class AddAllergyScreen extends StatefulWidget {
  const AddAllergyScreen({Key? key}) : super(key: key);

  @override
  State<AddAllergyScreen> createState() => _AddAllergyScreenState();
}

class _AddAllergyScreenState extends State<AddAllergyScreen> {
  // التكست كنترولر لقراءة الكلمة التي تكتبينها بيدكِ
  final TextEditingController _allergyController = TextEditingController();
  
  String? _selectedLevel = 'Level'; // القيمة الافتراضية للقائمة المنسدلة

  // القائمة تبدأ فارغة وتعتمد على إدخالكِ وحفظكِ
  final List<String> _dynamicAllergies = [];

  // دالة إضافة الحساسية الجديدة تلقائياً وحفظها في السيستم عند ضغط زر الصح
  void _addNewAllergy() {
    String text = _allergyController.text.trim();
    
    if (text.isNotEmpty) {
      setState(() {
        _dynamicAllergies.add('$text-Free');
        _allergyController.clear(); // تنظيف الحقل بعد الإضافة
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an allergy name first!')),
      );
    }
  }

  // 🗑️ دالة الحذف السحرية عند الضغط على زر الـ X
  void _removeAllergy(String allergyName) {
    setState(() {
      _dynamicAllergies.remove(allergyName); // تحذف العنصر المحدد بالظبط من السيستم
    });
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الجزء العلوي الأخضر المنحني
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                color: Color(0xFFB2D3C2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: const Text(
                'Add New Allergy',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  const Text('Allergy Name', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  
                  // حقل الكتابة مع زر الصح (✓)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _allergyController,
                          decoration: InputDecoration(
                            hintText: 'e.g., Peanuts',
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _addNewAllergy,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.check, color: Colors.green, size: 24),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  const Text('Severity Level', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  
                  // قائمة اللفل المنسدلة
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400, width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedLevel,
                        isExpanded: true,
                        items: <String>['Level', 'Mild', 'Severe'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedLevel = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 🛠️ عرض الشارات المضافة مع إضافة زر الـ X الذكي بجانب كل اسم!
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _dynamicAllergies.map((allergy) {
                      return Container(
                        padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8), // مسافات متناسقة
                        decoration: BoxDecoration(
                          color: const Color(0xFF48ED86), // لون لارا الأخضر المفضل
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.block, size: 16, color: Colors.red), // أيقونة المنع
                            const SizedBox(width: 8),
                            Text(
                              allergy,
                              style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                            ),
                            const SizedBox(width: 6),
                            
                            // ❌ زر الحذف الصغير التفاعلي
                            GestureDetector(
                              onTap: () => _removeAllergy(allergy), // يستدعي دالة الحذف فوراً
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white38, // خلفية شبه شفافة تجعل الـ X يبدو جميلاً
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(2),
                                child: const Icon(
                                  Icons.close, 
                                  size: 16, 
                                  color: Colors.black87
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            
            // زر الانتقال للشاشة التالية
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConfirmScreen(userAllergies: _dynamicAllergies)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF52E57), // اللون الوردي/الأحمر للأزرار
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Add Allergy', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}