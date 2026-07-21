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
import '../../../categories/domain/entities/expense_category.dart';
import '../../../categories/presentation/widgets/category_picker.dart';
import '../providers/expense_providers.dart';
import '../widgets/receipt_image_picker.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _note = TextEditingController();
  ExpenseCategory? _category;
  String? _receiptLocalPath;
  bool _uploading = false;

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _submit(String bucketId) async {
    if (!_formKey.currentState!.validate()) return;
    if (_category == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pick a category')));
      return;
    }

    final controller = ref.read(expenseControllerProvider.notifier);
    String? receiptUrl;
    if (_receiptLocalPath != null) {
      setState(() => _uploading = true);
      try {
        receiptUrl = await controller.uploadReceipt(_receiptLocalPath!);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e is AppException ? e.message : 'Receipt upload failed',
              ),
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _uploading = false);
      }
    }

    final categoryId = _category!.persistableId;
    final ok = await controller.addExpense(
      bucketId: bucketId,
      amount: double.parse(_amount.text),
      categoryId: categoryId,
      note: _note.text.trim().isEmpty ? null : _note.text.trim(),
      receiptImageUrl: receiptUrl,
    );

    if (!mounted) return;
    if (ok) {
      context.pop();
    } else {
      final error = ref.read(expenseControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is AppException ? error.message : 'Could not add expense.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bucketId = ref.watch(activeBucketIdProvider);
    final busy = ref.watch(expenseControllerProvider).isLoading || _uploading;

    return Scaffold(
      appBar: AppBar(title: const Text('Add expense')),
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
                      AppTextField(
                        controller: _amount,
                        label: 'Amount',
                        hint: '0',
                        prefixIcon: Icons.currency_rupee_rounded,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        validator: Validators.amount,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Category',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      CategoryPicker(
                        selectedId: _category?.id,
                        onSelected: (c) => setState(() => _category = c),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: _note,
                        label: 'Note (optional)',
                        hint: 'What was it for?',
                        prefixIcon: Icons.notes_rounded,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Receipt (optional)',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      ReceiptImagePicker(
                        localPath: _receiptLocalPath,
                        onPicked: (p) => setState(() => _receiptLocalPath = p),
                        onCleared: () =>
                            setState(() => _receiptLocalPath = null),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      AppButton(
                        label: _uploading ? 'Uploading…' : 'Save expense',
                        isLoading: busy,
                        onPressed: busy ? null : () => _submit(bucketId),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'The amount is deducted from the current active week.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: context.brand.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
