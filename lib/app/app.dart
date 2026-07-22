import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_provider.dart';
import '../core/sync/sync_scope.dart';
import '../core/widgets/app_messenger.dart';
import '../core/widgets/offline_banner.dart';
import 'router/app_router.dart';

class MonthEndApp extends ConsumerWidget {
  const MonthEndApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Month End',
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return SkeletonizerConfig(
          data: SkeletonizerConfigData(
            effect: ShimmerEffect(
              baseColor: isDark
                  ? const Color(0xFF1F2C38)
                  : const Color(0xFFE6ECF1),
              highlightColor: isDark
                  ? const Color(0xFF33475A)
                  : const Color(0xFFF9FBFC),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              duration: const Duration(milliseconds: 1300),
            ),
          ),
          child: SyncScope(
            child: Column(
              children: [
                const OfflineBanner(),
                Expanded(child: child ?? const SizedBox.shrink()),
              ],
            ),
          ),
        );
      },
    );
  }
}
