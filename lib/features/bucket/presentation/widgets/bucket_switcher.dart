import '../../../../core/widgets/app_icon.dart';
import '../../../../core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../auth/presentation/widgets/auth_gate.dart';
import '../../domain/entities/bucket.dart';
import '../providers/bucket_providers.dart';

class BucketSwitcher extends ConsumerWidget {
  const BucketSwitcher({super.key});

  Future<void> _open(
    BuildContext context,
    WidgetRef ref,
    List<Bucket> buckets,
    String? activeId,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => _BucketSheet(buckets: buckets, activeId: activeId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buckets = ref.watch(myBucketsProvider).value ?? const [];
    final activeId = ref.watch(activeBucketIdProvider);
    final active = buckets.where((b) => b.id == activeId).firstOrNull;
    final title = active?.name ?? 'This month';

    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      onTap: () => _open(context, ref, buckets, activeId),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(width: AppSpacing.xxs),
            const AppIcon(AppAssets.keyboardArrowDown),
          ],
        ),
      ),
    );
  }
}

class _BucketSheet extends ConsumerWidget {
  const _BucketSheet({required this.buckets, required this.activeId});

  final List<Bucket> buckets;
  final String? activeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Text(
                'Your buckets',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final bucket in buckets)
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.12,
                        ),
                        child: const AppIcon(
                          AppAssets.savings,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(bucket.name),
                      trailing: bucket.id == activeId
                          ? const AppIcon(
                              AppAssets.checkCircle,
                              color: AppColors.primary,
                            )
                          : null,
                      onTap: () {
                        ref.read(selectedBucketIdProvider.notifier).state =
                            bucket.id;
                        Navigator.of(context).pop();
                      },
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const AppIcon(AppAssets.addHome),
              title: const Text('Create new bucket'),
              onTap: () {
                Navigator.of(context).pop();
                context.push(RouteNames.createBucket);
              },
            ),
            ListTile(
              leading: const AppIcon(AppAssets.qrCodeScanner),
              title: const Text('Join with a code'),
              onTap: () async {
                Navigator.of(context).pop();
                if (await ensureAuthenticated(
                  context,
                  ref,
                  action: 'join a bucket',
                )) {
                  if (context.mounted) context.push(RouteNames.joinBucket);
                }
              },
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}
