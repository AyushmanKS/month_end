import '../../../../core/widgets/app_icon.dart';
import '../../../../core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../bucket/presentation/providers/bucket_providers.dart';
import '../providers/expense_providers.dart';

class BigExpenseScreen extends ConsumerStatefulWidget {
  const BigExpenseScreen({super.key});

  @override
  ConsumerState<BigExpenseScreen> createState() => _BigExpenseScreenState();
}

class _BigExpenseScreenState extends ConsumerState<BigExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _amount = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _submit(String bucketId) async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref
        .read(expenseControllerProvider.notifier)
        .addBigExpense(
          bucketId: bucketId,
          title: _title.text.trim(),
          amount: double.parse(_amount.text),
        );
    if (!mounted) return;
    if (ok) {
      context.pop();
    } else {
      final error = ref.read(expenseControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is AppException
                ? error.message
                : 'Could not add big expense.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bucketId = ref.watch(activeBucketIdProvider);
    final busy = ref.watch(expenseControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Big expense')),
      body: SafeArea(
        child: bucketId == null
            ? const Center(child: Text('No active bucket'))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: context.brand.accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMd,
                          ),
                        ),
                        child: Row(
                          children: [
                            AppIcon(
                              AppAssets.bolt,
                              color: context.brand.accent,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: Text(
                                'A big expense is deducted from the whole '
                                'budget and rebalances every remaining week.',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: _title,
                        label: 'Title',
                        hint: 'e.g. Goa Trip',
                        prefixIcon: AppAssets.title,
                        textCapitalization: TextCapitalization.words,
                        validator: (v) =>
                            Validators.required(v, field: 'Title'),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        controller: _amount,
                        label: 'Amount',
                        hint: '0',
                        prefixIcon: AppAssets.currencyRupeeCircle,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        validator: Validators.amount,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      AppButton(
                        label: 'Add & rebalance',
                        variant: AppButtonVariant.secondary,
                        isLoading: busy,
                        onPressed: busy ? null : () => _submit(bucketId),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
