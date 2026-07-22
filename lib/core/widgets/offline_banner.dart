import '../../core/constants/app_assets.dart';
import '../../core/widgets/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_spacing.dart';
import '../network/connectivity_providers.dart';

class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final online = ref.watch(isOnlineProvider).value ?? true;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) => SizeTransition(
        sizeFactor: animation,
        alignment: const Alignment(0, -1),
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: online
          ? const SizedBox(key: ValueKey('online'), width: double.infinity)
          : const _OfflineBar(key: ValueKey('offline')),
    );
  }
}

class _OfflineBar extends StatelessWidget {
  const _OfflineBar({super.key});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          topInset + AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [Color(0xFFB3261E), Color(0xFF8C1D18)]
                : const [Color(0xFFE63946), Color(0xFFC1121F)],
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(AppAssets.cloudOff, color: Colors.white, size: 18),
            SizedBox(width: AppSpacing.xs),
            Text(
              "You're Offline",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
