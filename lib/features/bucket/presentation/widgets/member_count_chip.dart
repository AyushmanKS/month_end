import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../shared_providers/supabase_providers.dart';
import '../../domain/entities/bucket_member.dart';
import '../providers/bucket_providers.dart';

class MemberCountChip extends ConsumerWidget {
  const MemberCountChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(bucketMembersProvider).value ?? const [];
    if (members.isEmpty) return const SizedBox.shrink();
    final ownerId = ref.watch(activeBucketProvider).value?.ownerId;
    final currentUid = ref.watch(currentUserIdProvider);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        onTap: () => _showMembers(context, members, ownerId, currentUid),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppIcon(
                AppAssets.profile,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                '${members.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMembers(
    BuildContext context,
    List<BucketMember> members,
    String? ownerId,
    String? currentUid,
  ) {
    final ordered = [...members]
      ..sort((a, b) {
        final aOwner = a.userId == ownerId;
        final bOwner = b.userId == ownerId;
        if (aOwner != bOwner) return aOwner ? -1 : 1;
        return a.joinedAt.compareTo(b.joinedAt);
      });
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Text(
                  '${members.length} '
                  '${members.length == 1 ? 'member' : 'members'}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: ordered.length,
                  itemBuilder: (context, index) {
                    final member = ordered[index];
                    final isOwner = member.userId == ownerId;
                    final isYou = member.userId == currentUid;
                    final name = member.name ?? 'Member';
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.12,
                        ),
                        backgroundImage: member.photoUrl != null
                            ? NetworkImage(member.photoUrl!)
                            : null,
                        child: member.photoUrl == null
                            ? const AppIcon(
                                AppAssets.profile,
                                color: AppColors.primary,
                              )
                            : null,
                      ),
                      title: Text(isYou ? '$name (You)' : name),
                      trailing: isOwner
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusSm,
                                ),
                              ),
                              child: const Text(
                                'Owner',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : Text(
                              'Joined ${_joinedLabel(member.joinedAt)}',
                              style: TextStyle(
                                color: context.brand.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        );
      },
    );
  }

  String _joinedLabel(DateTime date) {
    final local = date.toLocal();
    return '${local.day}/${local.month}/${local.year}';
  }
}
