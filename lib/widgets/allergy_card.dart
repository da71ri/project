import 'package:flutter/material.dart';
import '../models/allergy_model.dart';

class AllergyCard extends StatelessWidget {
  final AllergyModel allergy;
  final VoidCallback onDelete;

  const AllergyCard({
    super.key,
    required this.allergy,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE8F5E9), // خلفية خضراء فاتحة للأيقونة
          child: Icon(allergy.icon, color: const Color(0xFF4CAF50)),
        ),
        title: Text(
          allergy.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          'Severity: ${allergy.severity}',
          style: TextStyle(color: allergy.severity == 'Severe' ? Colors.red : Colors.blue),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: onDelete, // دالة الحذف التي تفتح البوب أب
        ),
      ),
    );
  }
}