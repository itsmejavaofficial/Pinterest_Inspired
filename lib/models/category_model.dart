import 'package:flutter/material.dart';

/// Model for a category chip item shown in the horizontal filter list.
class CategoryModel {
  final IconData icon;
  final String label;

  const CategoryModel({required this.icon, required this.label});

  static List<CategoryModel> get defaults => const [
    CategoryModel(icon: Icons.auto_awesome_rounded, label: 'For You'),
    CategoryModel(icon: Icons.home_rounded, label: 'Home'),
    CategoryModel(icon: Icons.restaurant_rounded, label: 'Food'),
    CategoryModel(icon: Icons.checkroom_rounded, label: 'Fashion'),
    CategoryModel(icon: Icons.flight_rounded, label: 'Travel'),
    CategoryModel(icon: Icons.build_rounded, label: 'DIY'),
    CategoryModel(icon: Icons.palette_rounded, label: 'Aesthetic'),
  ];
}