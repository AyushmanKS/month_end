import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/auth_providers.dart';

class OptionalAuthScreen extends ConsumerWidget {
  const OptionalAuthScreen({super.key});

  Future<void> _handle(
    BuildContext context,
    WidgetRef ref,
    Future<bool> Function() action,
  ) async {
    final ok = await action();
    if (!context.mounted) return;
    if (ok) {
      context.go(RouteNames.home);
      return;
    }
    final error = ref.read(authControllerProvider).error;
    if (error is IdentityCollisionException) {
      await _showCollisionDialog(context);
    } else if (error is AppException) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  Future<void> _showCollisionDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Account already exists'),
        content: const Text(
          'This login is already linked to another account. Sign in to that '
          'account instead? Data from this device will not be merged '
          'automatically.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Sign in to existing'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);
    final busy = state.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Secure your account')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.md),
              Text(
                'Back up your data',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Link a permanent login so you never lose your buckets or '
                'expenses when you change devices. This is optional.',
                style: TextStyle(color: context.brand.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Continue with Google',
                icon: Icons.g_mobiledata_rounded,
                isLoading: busy,
                onPressed: busy
                    ? null
                    : () => _handle(context, ref,
                        () => ref.read(authControllerProvider.notifier).upgradeWithGoogle()),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: 'Continue with Apple',
                icon: Icons.apple_rounded,
                variant: AppButtonVariant.secondary,
                isLoading: busy,
                onPressed: busy
                    ? null
                    : () => _handle(context, ref,
                        () => ref.read(authControllerProvider.notifier).upgradeWithApple()),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: 'Use email & password',
                icon: Icons.email_outlined,
                variant: AppButtonVariant.ghost,
                onPressed:
                    busy ? null : () => context.push(RouteNames.signup),
              ),
              const Spacer(),
              TextButton(
                onPressed: busy ? null : () => context.go(RouteNames.home),
                child: const Text('Maybe later'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
