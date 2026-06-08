import 'package:flutter/material.dart';

class ConfirmScreen extends StatelessWidget {
  // 🟢 استقبلنا القائمة الديناميكية من شاشة الإضافة هنا عشان نربطهم ببعض!
  final List<String> userAllergies;

  const ConfirmScreen({
    Key? key,
    required this.userAllergies, // إجباري نمرر القائمة عند فتح الشاشة
  }) : super(key: key);

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
          // منحنى أو تمدد بسيط ممتد من الـ AppBar متناسق مع شاشاتكِ
          Container(
            height: 20,
            color: const Color(0xFFB2D3C2),
            width: double.infinity,
          ),
          
          // 💡 هنا فحص السيستم الذكي: لو المستخدم ما أضاف ولا شيء يعلمه، ولو أضاف يعرضها فوراً!
          Expanded(
            child: userAllergies.isEmpty
                ? const Center(
                    child: Text(
                      'No allergies added yet.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: userAllergies.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 1,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            // 🟢 استخدمنا لون لارا الأخضر المفضل لخلفية الأيقونة لتناسق الهوية
                            backgroundColor: const Color(0xFFDFFCEA), 
                            child: const Icon(Icons.check, color: Color(0xFF4E9E6C)),
                          ),
                          title: Text(
                            userAllergies[index], // يعرض الاسم المحفوظ من السيستم (مثل: Nut-Free)
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          trailing: const Icon(Icons.check_circle, color: Colors.green, size: 28),
                        ),
                      );
                    },
                  ),
          ),
          
          // زر الحفظ النهائي الملون بالوردي/الأحمر المعتمد للأزرار عندكِ لتوحيد الواجهات
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Allergies Profile Confirmed Successfully!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF52E57), // 🔴 لون أزرارك الموحد
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Confirm', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}