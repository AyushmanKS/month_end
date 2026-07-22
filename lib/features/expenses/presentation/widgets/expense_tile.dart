import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../bucket/presentation/providers/bucket_providers.dart';
import '../../../categories/presentation/providers/category_providers.dart';
import '../../domain/entities/expense.dart';

class ExpenseTile extends ConsumerWidget {
  const ExpenseTile({
    super.key,
    required this.expense,
    this.onTap,
    this.onImageTap,
  });

  final Expense expense;
  final VoidCallback? onTap;
  final VoidCallback? onImageTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(categoryByIdProvider(expense.categoryId));
    final brand = context.brand;
    final currency = ref.watch(activeCurrencyProvider);
    final members = ref.watch(bucketMembersProvider).value ?? const [];
    String? creatorName;
    if (expense.addedByUid.isEmpty) {
      creatorName = 'Deleted User';
    } else {
      for (final member in members) {
        if (member.userId == expense.addedByUid) {
          creatorName = member.name;
          break;
        }
      }
    }

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(
                  category?.icon ?? Icons.category_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category?.name ?? 'Uncategorised',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      [
                        if (expense.note != null && expense.note!.isNotEmpty)
                          expense.note!,
                        if (creatorName != null) 'by $creatorName',
                        AppDateUtils.day(expense.createdAt.toLocal()),
                      ].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: brand.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (expense.hasReceipt) ...[
                GestureDetector(
                  onTap: onImageTap,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    child: Image.network(
                      expense.receiptImageUrl!,
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Icon(
                        Icons.broken_image_outlined,
                        color: brand.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(
                CurrencyFormatter.format(expense.amount, code: currency),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
