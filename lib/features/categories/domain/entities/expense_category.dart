import 'package:flutter/material.dart';

class ExpenseCategory {
  const ExpenseCategory({
    required this.id,
    required this.name,
    required this.iconKey,
    this.isPreset = true,
  });

  final String id;
  final String name;
  final String iconKey;
  final bool isPreset;

  IconData get icon => categoryIcons[iconKey] ?? Icons.category_outlined;

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      iconKey: json['icon'] as String? ?? 'other',
      isPreset: json['is_preset'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': iconKey,
        'is_preset': isPreset,
      };
}

const Map<String, IconData> categoryIcons = {
  'groceries': Icons.local_grocery_store_outlined,
  'bus': Icons.directions_bus_outlined,
  'erickshaw': Icons.electric_rickshaw_outlined,
  'auto': Icons.local_taxi_outlined,
  'food': Icons.restaurant_outlined,
  'rent': Icons.home_outlined,
  'utilities': Icons.bolt_outlined,
  'shopping': Icons.shopping_bag_outlined,
  'entertainment': Icons.movie_outlined,
  'other': Icons.category_outlined,
};

const List<ExpenseCategory> presetCategories = [
  ExpenseCategory(id: 'preset_groceries', name: 'Groceries', iconKey: 'groceries'),
  ExpenseCategory(id: 'preset_bus', name: 'Bus', iconKey: 'bus'),
  ExpenseCategory(id: 'preset_erickshaw', name: 'E-Rickshaw', iconKey: 'erickshaw'),
  ExpenseCategory(id: 'preset_auto', name: 'Auto', iconKey: 'auto'),
  ExpenseCategory(id: 'preset_food', name: 'Food', iconKey: 'food'),
  ExpenseCategory(id: 'preset_rent', name: 'Rent', iconKey: 'rent'),
  ExpenseCategory(id: 'preset_utilities', name: 'Utilities', iconKey: 'utilities'),
  ExpenseCategory(id: 'preset_shopping', name: 'Shopping', iconKey: 'shopping'),
  ExpenseCategory(
      id: 'preset_entertainment', name: 'Entertainment', iconKey: 'entertainment'),
  ExpenseCategory(id: 'preset_other', name: 'Other', iconKey: 'other'),
];
