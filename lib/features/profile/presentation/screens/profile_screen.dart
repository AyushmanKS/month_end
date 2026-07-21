import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../widgets/theme_toggle_tile.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentAppUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: ListView(
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
            Text('Appearance',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            const ThemeToggleTile(),
            const SizedBox(height: AppSpacing.lg),
            Text('Account', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            AppButton(
              label: 'Sign out',
              variant: AppButtonVariant.ghost,
              icon: Icons.logout_rounded,
              onPressed: () async {
                final anonymous = user?.isAnonymous ?? false;
                final confirmed = await showConfirmDialog(
                  context,
                  title: 'Sign out?',
                  message: anonymous
                      ? 'You are on an anonymous session. Signing out will '
                          'permanently delete this session and its data. '
                          'Secure your account first to keep it.'
                      : 'You will need to sign in again to access your buckets '
                          'and expenses on this device.',
                  confirmLabel: 'Sign out',
                  destructive: true,
                  icon: Icons.logout_rounded,
                );
                if (!confirmed) return;
                await ref.read(authControllerProvider.notifier).signOut();
              },
            ),
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
          backgroundImage:
              user?.photoUrl != null ? NetworkImage(user!.photoUrl!) : null,
          child: user?.photoUrl == null
              ? const Icon(Icons.person_rounded,
                  color: AppColors.primary, size: 32)
              : null,
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: Theme.of(context).textTheme.titleLarge),
            Text(subtitle,
                style: TextStyle(color: context.brand.textSecondary)),
            if (user?.hasUsername ?? false)
              Text('@${user!.username}',
                  style: const TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.w600)),
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
                Text('Back up your account',
                    style: Theme.of(context).textTheme.titleLarge),
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
