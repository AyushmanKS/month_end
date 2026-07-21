import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/theme_provider.dart';

class ThemeToggleTile extends ConsumerWidget {
  const ThemeToggleTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final isDark =
        mode == ThemeMode.dark ||
        (mode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          children: [
            Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'Dark mode',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Switch(
              value: isDark,
              onChanged: (value) => ref
                  .read(themeModeProvider.notifier)
                  .set(value ? ThemeMode.dark : ThemeMode.light),
            ),
          ],
        ),
      ),
    );
  }
}
