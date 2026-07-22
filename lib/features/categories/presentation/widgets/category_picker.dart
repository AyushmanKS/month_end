import '../../../../core/widgets/app_icon.dart';
import '../../../../core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../domain/entities/expense_category.dart';
import '../providers/category_providers.dart';

class CategoryPicker extends ConsumerWidget {
  const CategoryPicker({
    super.key,
    required this.selectedId,
    required this.onSelected,
  });

  final String? selectedId;
  final ValueChanged<ExpenseCategory> onSelected;

  Future<void> _addCategory(BuildContext context, WidgetRef ref) async {
    final created = await showDialog<ExpenseCategory>(
      context: context,
      builder: (context) => const _AddCategoryDialog(),
    );
    if (created != null) onSelected(created);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final categories = categoriesAsync.value ?? presetCategories;

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        for (var i = 0; i < categories.length; i++)
          _CategoryChip(
            category: categories[i],
            color:
                AppColors.categorySwatch[i % AppColors.categorySwatch.length],
            selected: categories[i].id == selectedId,
            onTap: () => onSelected(categories[i]),
          ),
        _NewCategoryChip(onTap: () => _addCategory(context, ref)),
      ],
    );
  }
}

class _NewCategoryChip extends StatelessWidget {
  const _NewCategoryChip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: context.brand.surfaceAlt,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(AppAssets.add, size: 16, color: AppColors.primary),
            SizedBox(width: AppSpacing.xxs),
            Text(
              'New',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddCategoryDialog extends ConsumerStatefulWidget {
  const _AddCategoryDialog();

  @override
  ConsumerState<_AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends ConsumerState<_AddCategoryDialog> {
  final _name = TextEditingController();
  String _iconKey = categoryIcons.keys.first;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    setState(() => _saving = true);
    final created = await ref
        .read(categoryControllerProvider.notifier)
        .addCustomCategory(name: name, iconKey: _iconKey);
    if (!mounted) return;
    if (created != null) {
      Navigator.of(context).pop(created);
    } else {
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not add category.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final keys = categoryIcons.keys.toList();
    return AlertDialog(
      title: const Text('New category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _name,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'e.g. Fuel',
            ),
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Icon',
              style: TextStyle(color: context.brand.textSecondary),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final key in keys)
                GestureDetector(
                  onTap: () => setState(() => _iconKey = key),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _iconKey == key
                          ? AppColors.primary.withValues(alpha: 0.18)
                          : context.brand.surfaceAlt,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      border: Border.all(
                        color: _iconKey == key
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: AppIcon(
                      categoryIcons[key]!,
                      size: 20,
                      color: _iconKey == key ? AppColors.primary : null,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Add'),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final ExpenseCategory category;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.18)
              : context.brand.surfaceAlt,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(
            color: selected ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(category.icon, size: 16, color: selected ? color : null),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              category.name,
              style: TextStyle(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? color : null,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
