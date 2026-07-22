import '../../../../core/constants/app_assets.dart';


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

  String get icon => categoryIcons[iconKey] ?? AppAssets.category;

  bool get isLocalFallback => id.startsWith('preset_');

  String? get persistableId => isLocalFallback ? null : id;

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

const Map<String, String> categoryIcons = {
  'groceries': AppAssets.store,
  'bus': AppAssets.directionsBus,
  'erickshaw': AppAssets.electricRickshaw,
  'auto': AppAssets.localTaxi,
  'food': AppAssets.restaurant,
  'rent': AppAssets.home,
  'utilities': AppAssets.bolt,
  'shopping': AppAssets.shoppingBag,
  'entertainment': AppAssets.movie,
  'other': AppAssets.category,
};

const List<ExpenseCategory> presetCategories = [
  ExpenseCategory(
    id: 'preset_groceries',
    name: 'Groceries',
    iconKey: 'groceries',
  ),
  ExpenseCategory(id: 'preset_bus', name: 'Bus', iconKey: 'bus'),
  ExpenseCategory(
    id: 'preset_erickshaw',
    name: 'E-Rickshaw',
    iconKey: 'erickshaw',
  ),
  ExpenseCategory(id: 'preset_auto', name: 'Auto', iconKey: 'auto'),
  ExpenseCategory(id: 'preset_food', name: 'Food', iconKey: 'food'),
  ExpenseCategory(id: 'preset_rent', name: 'Rent', iconKey: 'rent'),
  ExpenseCategory(
    id: 'preset_utilities',
    name: 'Utilities',
    iconKey: 'utilities',
  ),
  ExpenseCategory(id: 'preset_shopping', name: 'Shopping', iconKey: 'shopping'),
  ExpenseCategory(
    id: 'preset_entertainment',
    name: 'Entertainment',
    iconKey: 'entertainment',
  ),
  ExpenseCategory(id: 'preset_other', name: 'Other', iconKey: 'other'),
];
