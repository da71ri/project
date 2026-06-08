import 'package:flutter/material.dart';
import 'add_allergy_screen.dart'; // الانتقال لشاشة إضافة الحساسية

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,    
            end: Alignment.bottomCenter, 
            colors: [
              Color(0xFFDFFCEA), 
              Color(0xFF4E9E6C), 
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 40),
              
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.spa_outlined,
                      size: 60,
                      color: Color(0xFF4E9E6C), 
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  const Text(
                    'Welcome to\nAllergy Guide',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      'Welcome to Allergy Guide, designing your perfect menu options and managing preferences more effectively. Learn how we can help you stay safe.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(32.0),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddAllergyScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 54),
                    side: const BorderSide(color: Colors.black, width: 1.5), // الإطار الأسود النحيف
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25), // حواف دائرية انسيابية مثل تصميمكِ
                    ),
                  ),
                  child: const Text(
                    'next',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}