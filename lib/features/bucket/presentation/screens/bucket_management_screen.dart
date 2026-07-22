import '../../../../core/widgets/app_icon.dart';
import '../../../../core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/app_skeletons.dart';
import '../../../../core/widgets/app_messenger.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../shared_providers/supabase_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/bucket.dart';
import '../providers/bucket_providers.dart';

class BucketManagementScreen extends ConsumerWidget {
  const BucketManagementScreen({super.key, this.forAccountDeletion = false});

  final bool forAccountDeletion;

  Future<void> _transfer(
    BuildContext context,
    WidgetRef ref,
    Bucket bucket,
  ) async {
    final newOwnerId = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => _MemberPicker(bucketId: bucket.id),
    );
    if (newOwnerId == null || !context.mounted) return;
    final ok = await ref
        .read(bucketControllerProvider.notifier)
        .transferOwnership(bucketId: bucket.id, newOwnerId: newOwnerId);
    showAppSnack(
      ok
          ? 'Ownership of “${bucket.name}” transferred.'
          : 'Could not transfer ownership.',
      success: ok,
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    Bucket bucket,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete “${bucket.name}”?',
      message:
          'This permanently deletes the bucket, its weeks, expenses and '
          'members for everyone. This cannot be undone.',
      confirmLabel: 'Delete bucket',
      destructive: true,
      icon: AppAssets.delete,
    );
    if (!confirmed) return;
    final ok = await ref
        .read(bucketControllerProvider.notifier)
        .deleteBucket(bucket.id);
    showAppSnack(
      ok ? 'Bucket deleted.' : 'Could not delete the bucket.',
      success: ok,
    );
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete your account?',
      message:
          'Your account and anonymous session will be permanently deleted. '
          'Your past expenses stay in shared buckets, attributed to a '
          'deleted user.',
      confirmLabel: 'Delete account',
      destructive: true,
      icon: AppAssets.personOff,
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
    final owned = ref.watch(ownedBucketsProvider);
    final busy = ref.watch(bucketControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(forAccountDeletion ? 'Resolve your buckets' : 'My buckets'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: owned.isEmpty
                  ? AppEmptyState(
                      title: forAccountDeletion
                          ? 'All buckets resolved'
                          : 'You don\'t own any buckets',
                      subtitle: forAccountDeletion
                          ? 'You can now delete your account.'
                          : 'Buckets you create show up here to manage.',
                      icon: AppAssets.folderOpen,
                    )
                  : ListView(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      children: [
                        if (forAccountDeletion)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            child: Text(
                              'You are the admin of these buckets. Transfer '
                              'each to another member or delete it before '
                              'deleting your account.',
                              style: TextStyle(
                                color: context.brand.textSecondary,
                              ),
                            ),
                          ),
                        for (final bucket in owned)
                          _OwnedBucketCard(
                            bucket: bucket,
                            busy: busy,
                            onTransfer: () => _transfer(context, ref, bucket),
                            onDelete: () => _delete(context, ref, bucket),
                          ),
                      ],
                    ),
            ),
            if (forAccountDeletion)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: AppButton(
                  label: 'Delete my account',
                  variant: AppButtonVariant.secondary,
                  isLoading: busy,
                  onPressed: owned.isEmpty && !busy
                      ? () => _deleteAccount(context, ref)
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _OwnedBucketCard extends StatelessWidget {
  const _OwnedBucketCard({
    required this.bucket,
    required this.busy,
    required this.onTransfer,
    required this.onDelete,
  });

  final Bucket bucket;
  final bool busy;
  final VoidCallback onTransfer;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(bucket.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: busy ? null : onTransfer,
                    icon: const AppIcon(AppAssets.swapHorizontal, size: 18),
                    label: const Text('Transfer'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: busy ? null : onDelete,
                    icon: const AppIcon(AppAssets.delete, size: 18),
                    label: const Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberPicker extends ConsumerWidget {
  const _MemberPicker({required this.bucketId});

  final String bucketId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(bucketMembersFamilyProvider(bucketId));
    final selfId = ref.watch(currentUserIdProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Choose the new admin',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            membersAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: MembersSkeleton(),
              ),
              error: (e, _) => const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Text('Could not load members.'),
              ),
              data: (members) {
                final others = members
                    .where((m) => m.userId != selfId)
                    .toList();
                if (others.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Text(
                      'No other members to transfer to. Invite someone first, '
                      'or delete the bucket instead.',
                    ),
                  );
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final member in others)
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: member.photoUrl != null
                              ? NetworkImage(member.photoUrl!)
                              : null,
                          child: member.photoUrl == null
                              ? const AppIcon(AppAssets.profile)
                              : null,
                        ),
                        title: Text(member.name ?? 'Member'),
                        onTap: () => Navigator.of(context).pop(member.userId),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
