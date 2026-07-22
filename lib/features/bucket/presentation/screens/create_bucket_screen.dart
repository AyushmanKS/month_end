import '../../../../core/widgets/app_icon.dart';
import '../../../../core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/currency/currency.dart';
import '../../../../core/currency/currency_picker.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/validators.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/bucket_providers.dart';

class CreateBucketScreen extends ConsumerStatefulWidget {
  const CreateBucketScreen({super.key});

  @override
  ConsumerState<CreateBucketScreen> createState() => _CreateBucketScreenState();
}

class _CreateBucketScreenState extends ConsumerState<CreateBucketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _budget = TextEditingController();
  String _currency = Currencies.localeDefault();

  @override
  void dispose() {
    _name.dispose();
    _budget.dispose();
    super.dispose();
  }

  Future<void> _pickCurrency() async {
    final code = await showCurrencyPicker(context, selected: _currency);
    if (code != null && mounted) setState(() => _currency = code);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final bucket = await ref
        .read(bucketControllerProvider.notifier)
        .createBucket(
          name: _name.text.trim(),
          monthlyBudget: double.parse(_budget.text),
          currency: _currency,
        );
    if (!mounted) return;
    if (bucket != null) {
      context.go(RouteNames.home);
    } else {
      final error = ref.read(bucketControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is AppException ? error.message : 'Could not create bucket.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(appUserStreamProvider);
    final user = userAsync.value;
    final busy = ref.watch(bucketControllerProvider).isLoading;
    final resolvingUser = userAsync.isLoading && !userAsync.hasValue;
    final canCreate = user?.canCreateBucket ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('New bucket')),
      body: SafeArea(
        child: resolvingUser
            ? Skeletonizer.zone(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      Bone(
                        height: 56,
                        borderRadius: BorderRadius.all(
                          Radius.circular(AppSpacing.radiusMd),
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      Bone(
                        height: 56,
                        borderRadius: BorderRadius.all(
                          Radius.circular(AppSpacing.radiusMd),
                        ),
                      ),
                      SizedBox(height: AppSpacing.xl),
                      Bone.button(width: double.infinity, height: 52),
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: canCreate
                    ? Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppTextField(
                              controller: _name,
                              label: 'Bucket name',
                              hint: 'e.g. Flat 402',
                              prefixIcon: AppAssets.savings,
                              textCapitalization: TextCapitalization.words,
                              validator: (v) =>
                                  Validators.required(v, field: 'Name'),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            AppTextField(
                              controller: _budget,
                              label: 'Monthly budget',
                              hint: '0',
                              prefixIcon: AppAssets.currencyRupeeCircle,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]'),
                                ),
                              ],
                              validator: Validators.amount,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Card(
                              child: ListTile(
                                leading: const AppIcon(AppAssets.payments),
                                title: const Text('Currency'),
                                subtitle: Text(
                                  '${Currencies.byCode(_currency).name} '
                                  '(${Currencies.symbolFor(_currency)})',
                                ),
                                trailing: const AppIcon(AppAssets.chevronRight),
                                onTap: _pickCurrency,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            AppButton(
                              label: 'Create bucket',
                              isLoading: busy,
                              onPressed: busy ? null : _submit,
                            ),
                          ],
                        ),
                      )
                    : _LockedNotice(),
              ),
      ),
    );
  }
}

class _LockedNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xl),
        AppIcon(AppAssets.lock, size: 56, color: context.brand.textSecondary),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Secure your account first',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Creating a bucket makes you its owner, so it needs a permanent '
          'login. This keeps the whole household from being orphaned if a '
          'device is lost.',
          textAlign: TextAlign.center,
          style: TextStyle(color: context.brand.textSecondary),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(
          label: 'Secure my account',
          onPressed: () => context.push(RouteNames.optionalAuth),
        ),
      ],
    );
  }
}
