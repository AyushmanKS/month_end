import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../categories/presentation/providers/category_providers.dart';
import '../../domain/entities/spend_suggestion.dart';

class SuggestionCard extends ConsumerWidget {
  const SuggestionCard({super.key, required this.suggestion});

  final SpendSuggestion suggestion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brand = context.brand;
    final category = ref.watch(categoryByIdProvider(suggestion.categoryId));
    final color = suggestion.isIncrease ? brand.warning : brand.success;
    final icon = suggestion.isIncrease
        ? Icons.trending_up_rounded
        : Icons.trending_down_rounded;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (category != null)
                    Text(
                      category.name,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  Text(
                    suggestion.message,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '${suggestion.percentChange >= 0 ? '+' : ''}'
              '${suggestion.percentChange.toStringAsFixed(0)}%',
              style: TextStyle(color: color, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
