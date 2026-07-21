import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_loader.dart';
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

  @override
  void dispose() {
    _name.dispose();
    _budget.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final bucket = await ref
        .read(bucketControllerProvider.notifier)
        .createBucket(
          name: _name.text.trim(),
          monthlyBudget: double.parse(_budget.text),
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
    final user = userAsync.valueOrNull;
    final busy = ref.watch(bucketControllerProvider).isLoading;
    final resolvingUser = userAsync.isLoading && !userAsync.hasValue;
    final canCreate = user?.canCreateBucket ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('New bucket')),
      body: SafeArea(
        child: resolvingUser
            ? const AppLoader()
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
                              prefixIcon: Icons.home_outlined,
                              textCapitalization: TextCapitalization.words,
                              validator: (v) =>
                                  Validators.required(v, field: 'Name'),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            AppTextField(
                              controller: _budget,
                              label: 'Monthly budget',
                              hint: '0',
                              prefixIcon: Icons.currency_rupee_rounded,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]'),
                                ),
                              ],
                              validator: Validators.amount,
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
        Icon(
          Icons.lock_outline_rounded,
          size: 56,
          color: context.brand.textSecondary,
        ),
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
