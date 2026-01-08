import 'package:flutter/material.dart';

/// Category model
class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final List<String> subcategories;
  final bool isCustom;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.subcategories = const [],
    this.isCustom = false,
  });
}
