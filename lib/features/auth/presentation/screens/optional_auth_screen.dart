import '../../../../core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/network/connectivity_providers.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_messenger.dart';
import '../providers/auth_providers.dart';

class OptionalAuthScreen extends ConsumerWidget {
  const OptionalAuthScreen({super.key});

  Future<void> _handleGoogle(BuildContext context, WidgetRef ref) async {
    if (!(ref.read(isOnlineProvider).value ?? true)) {
      showAppSnack('Connect to the internet to secure your account.');
      return;
    }
    final outcome = await ref
        .read(authControllerProvider.notifier)
        .upgradeWithGoogle();
    switch (outcome) {
      case GoogleAuthOutcome.signedIntoExisting:
        if (context.mounted) context.go(RouteNames.home);
        showAppSnack('Welcome back — signed in with Google.', success: true);
      case GoogleAuthOutcome.upgraded:
        if (context.mounted) context.go(RouteNames.home);
        showAppSnack('Your account is now secured with Google.', success: true);
      case GoogleAuthOutcome.failed:
        final error = ref.read(authControllerProvider).error;
        showAppSnack(
          error is AppException
              ? error.message
              : 'Google sign-in failed. Please try again.',
        );
    }
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
                icon: AppAssets.googleIcon,
                isLoading: busy,
                onPressed: busy ? null : () => _handleGoogle(context, ref),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: 'Use email & password',
                icon: AppAssets.email,
                variant: AppButtonVariant.ghost,
                onPressed: busy ? null : () => context.push(RouteNames.signup),
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
