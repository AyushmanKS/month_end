import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../bucket/presentation/providers/bucket_providers.dart';
import '../../domain/entities/expense.dart';
import '../providers/expense_providers.dart';
import '../widgets/expense_tile.dart';

class ExpenseHistoryScreen extends ConsumerWidget {
  const ExpenseHistoryScreen({super.key});

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Expense expense,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete expense?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final ok = await ref
        .read(expenseControllerProvider.notifier)
        .deleteExpense(expense.id);
    if (!context.mounted) return;
    if (!ok) {
      final error = ref.read(expenseControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              error is AppException ? error.message : 'Delete failed.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expensesProvider);
    final userId = ref.watch(currentAppUserProvider)?.id;
    final ownerId = ref.watch(activeBucketProvider).valueOrNull?.ownerId;

    return Scaffold(
      appBar: AppBar(title: const Text('Expenses')),
      body: SafeArea(
        child: expensesAsync.when(
          loading: () => const AppLoader(),
          error: (e, _) => AppErrorView(message: e.toString()),
          data: (expenses) {
            if (expenses.isEmpty) {
              return const AppEmptyState(
                title: 'No expenses yet',
                subtitle: 'Tap the + button on Home to add your first one.',
                icon: Icons.receipt_long_outlined,
              );
            }
            final sorted = [...expenses]
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                120,
              ),
              itemCount: sorted.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.xs),
              itemBuilder: (context, index) {
                final expense = sorted[index];
                final canEdit = userId != null &&
                    ownerId != null &&
                    expense.canEdit(userId: userId, ownerId: ownerId);
                return Dismissible(
                  key: ValueKey(expense.id),
                  direction: canEdit
                      ? DismissDirection.endToStart
                      : DismissDirection.none,
                  background: _deleteBackground(context),
                  confirmDismiss: (_) async {
                    await _confirmDelete(context, ref, expense);
                    return false;
                  },
                  child: ExpenseTile(
                    expense: expense,
                    onTap: canEdit
                        ? () => context.push(RouteNames.addExpense)
                        : null,
                  ),
                ).animate().fadeIn(
                      delay: AppDurations.listStagger * (index % 8),
                      duration: AppDurations.fast,
                    );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _deleteBackground(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Icon(Icons.delete_outline,
          color: Theme.of(context).colorScheme.error),
    );
  }
}
