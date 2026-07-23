import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_icon.dart';
import '../providers/auth_providers.dart';

Future<bool> ensureAuthenticated(
  BuildContext context,
  WidgetRef ref, {
  required String action,
}) async {
  if (ref.read(isAuthenticatedProvider)) return true;
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) => _SignInPrompt(action: action),
  );
  return false;
}

class _SignInPrompt extends StatelessWidget {
  const _SignInPrompt({required this.action});

  final String action;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: AppIcon(
                AppAssets.shield,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Sign in to $action',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Sharing and joining buckets needs a permanent account. Secure '
              'yours and your current bucket comes with you.',
              textAlign: TextAlign.center,
              style: TextStyle(color: context.brand.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Secure my account',
              onPressed: () {
                Navigator.of(context).pop();
                context.push(RouteNames.optionalAuth);
              },
            ),
          ],
        ),
      ),
    );
  }
}
