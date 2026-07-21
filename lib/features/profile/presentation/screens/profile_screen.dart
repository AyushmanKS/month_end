import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_skeletons.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/app_messenger.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../bucket/presentation/providers/bucket_providers.dart';
import '../widgets/theme_toggle_tile.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Sign out?',
      message:
          'You will need to sign in again to access your buckets and expenses '
          'on this device.',
      confirmLabel: 'Sign out',
      destructive: true,
      icon: Icons.logout_rounded,
    );
    if (!confirmed) return;
    try {
      await ref.read(authControllerProvider.notifier).signOut();
    } catch (_) {
      showAppSnack('Could not sign out. Please try again.');
    }
  }

  Future<void> _deleteAccount(
    BuildContext context,
    WidgetRef ref,
    bool ownsBuckets,
  ) async {
    if (ownsBuckets) {
      context.push(RouteNames.manageBuckets, extra: true);
      return;
    }
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete your account?',
      message:
          'Your account will be permanently deleted. Your past expenses stay '
          'in shared buckets, attributed to a deleted user. This cannot be '
          'undone.',
      confirmLabel: 'Delete account',
      destructive: true,
      icon: Icons.person_off_outlined,
    );
    if (!confirmed) return;
    final ok = await ref.read(authControllerProvider.notifier).deleteAccount();
    showAppSnack(
      ok ? 'Your account has been deleted.' : 'Could not delete your account.',
      success: ok,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(appUserStreamProvider);
    final user = userAsync.value;
    final ownsBuckets = ref.watch(ownedBucketsProvider).isNotEmpty;
    final isRegistered = user != null && !user.isAnonymous;
    final hasAccountActions = ownsBuckets || isRegistered;
    final resolvingUser = userAsync.isLoading && !userAsync.hasValue;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: resolvingUser
            ? const ProfileSkeleton()
            : ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  120,
                ),
                children: [
                  _ProfileHeader(user: user),
                  const SizedBox(height: AppSpacing.lg),
                  if (user != null && user.isAnonymous) ...[
                    _BackupPrompt(),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  Text(
                    'Appearance',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const ThemeToggleTile(),
                  const SizedBox(height: AppSpacing.lg),
                  if (hasAccountActions) ...[
                    Text(
                      'Account',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    if (ownsBuckets) ...[
                      AppButton(
                        label: 'Manage my buckets',
                        variant: AppButtonVariant.ghost,
                        icon: Icons.folder_outlined,
                        onPressed: () => context.push(RouteNames.manageBuckets),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    if (isRegistered) ...[
                      AppButton(
                        label: 'Sign out',
                        variant: AppButtonVariant.ghost,
                        icon: Icons.logout_rounded,
                        onPressed: () => _signOut(context, ref),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppButton(
                        label: 'Delete account',
                        variant: AppButtonVariant.ghost,
                        icon: Icons.person_off_outlined,
                        onPressed: () =>
                            _deleteAccount(context, ref, ownsBuckets),
                      ),
                    ],
                  ],
                ],
              ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});

  final AppUser? user;

  @override
  Widget build(BuildContext context) {
    final name = user?.name ?? 'Guest';
    final subtitle = switch (user?.authType) {
      AuthType.anonymous => 'Anonymous session',
      AuthType.google => 'Google account',
      AuthType.apple => 'Apple account',
      AuthType.email => user?.email ?? 'Email account',
      null => 'Not signed in',
    };
    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: AppColors.primary.withValues(alpha: 0.14),
          backgroundImage: user?.photoUrl != null
              ? NetworkImage(user!.photoUrl!)
              : null,
          child: user?.photoUrl == null
              ? const Icon(
                  Icons.person_rounded,
                  color: AppColors.primary,
                  size: 32,
                )
              : null,
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: Theme.of(context).textTheme.titleLarge),
            Text(
              subtitle,
              style: TextStyle(color: context.brand.textSecondary),
            ),
            if (user?.hasUsername ?? false)
              Text(
                '@${user!.username}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _BackupPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.shield_outlined, color: AppColors.accent),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Back up your account',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'You are using an anonymous session. Secure it to keep your data '
              'when you switch devices, and to create your own buckets.',
              style: TextStyle(color: context.brand.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Secure my account',
              onPressed: () => context.push(RouteNames.optionalAuth),
            ),
          ],
        ),
      ),
    );
  }
}
