import 'package:flutter/material.dart';

class AllergyModel {
  final String id;
  final String name;
  final String severity; 
  final IconData icon;   
  bool isSelected;       

  AllergyModel({
    required this.id,
    required this.name,
    required this.severity,
    required this.icon,
    this.isSelected = false,
  });
}
