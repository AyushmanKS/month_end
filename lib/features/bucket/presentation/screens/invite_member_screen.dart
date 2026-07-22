import '../../../../core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/utils/validators.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/bucket_providers.dart';
import '../widgets/bucket_qr_display.dart';

class InviteMemberScreen extends ConsumerStatefulWidget {
  const InviteMemberScreen({super.key});

  @override
  ConsumerState<InviteMemberScreen> createState() => _InviteMemberScreenState();
}

class _InviteMemberScreenState extends ConsumerState<InviteMemberScreen> {
  final _username = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _username.dispose();
    super.dispose();
  }

  Future<void> _invite(String bucketId) async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref
        .read(bucketControllerProvider.notifier)
        .inviteByUsername(
          bucketId: bucketId,
          username: _username.text.trim().toLowerCase(),
        );
    if (!mounted) return;
    final error = ref.read(bucketControllerProvider).error;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Invite sent'
              : (error is AppException ? error.message : 'Could not invite.'),
        ),
      ),
    );
    if (ok) _username.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bucketAsync = ref.watch(activeBucketProvider);
    final user = ref.watch(currentAppUserProvider);
    final busy = ref.watch(bucketControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Invite members')),
      body: bucketAsync.when(
        loading: () => Skeletonizer.zone(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: const [
                Bone.text(width: 180, fontSize: 18),
                SizedBox(height: AppSpacing.lg),
                Bone.square(size: 220, uniRadius: AppSpacing.radiusMd),
                SizedBox(height: AppSpacing.lg),
                Bone.text(width: 140),
                SizedBox(height: AppSpacing.md),
                Bone(
                  width: double.infinity,
                  height: 52,
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppSpacing.radiusMd),
                  ),
                ),
              ],
            ),
          ),
        ),
        error: (e, _) => AppErrorView(message: ErrorHandler.userMessage(e)),
        data: (bucket) {
          if (bucket == null) {
            return const AppEmptyState(title: 'No active bucket');
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Text(
                  'Share this code or QR',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                BucketQrDisplay(
                  joinCode: bucket.joinCode,
                  bucketName: bucket.name,
                ),
                const SizedBox(height: AppSpacing.xl),
                const Divider(),
                const SizedBox(height: AppSpacing.md),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Or invite by username',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'The person must have a secured account with a username.',
                    style: TextStyle(color: context.brand.textSecondary),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Form(
                  key: _formKey,
                  child: AppTextField(
                    controller: _username,
                    label: 'Username',
                    hint: 'alex_flat402',
                    prefixIcon: AppAssets.alternateEmail,
                    validator: Validators.username,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (user != null && bucket.isOwnedBy(user.id))
                  AppButton(
                    label: 'Send invite',
                    isLoading: busy,
                    onPressed: busy ? null : () => _invite(bucket.id),
                  )
                else
                  Text(
                    'Only the bucket owner can invite by username.',
                    style: TextStyle(color: context.brand.textSecondary),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
