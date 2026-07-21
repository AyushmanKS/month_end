import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_durations.dart';
import '../constants/app_spacing.dart';

class AnimatedProgressBar extends StatelessWidget {
  const AnimatedProgressBar({
    super.key,
    required this.value,
    this.height = 10,
    this.color,
  });

  final double value;
  final double height;
  final Color? color;

  Color _colorFor(double v) {
    if (color != null) return color!;
    if (v >= 1.0) return AppColors.danger;
    if (v >= 0.8) return AppColors.warning;
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          child: Stack(
            children: [
              Container(
                height: height,
                width: constraints.maxWidth,
                color: AppColors.lightBorder.withValues(alpha: 0.4),
              ),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: clamped),
                duration: AppDurations.slow,
                curve: Curves.easeOutCubic,
                builder: (context, animated, _) {
                  return Container(
                    height: height,
                    width: constraints.maxWidth * animated,
                    decoration: BoxDecoration(
                      color: _colorFor(clamped),
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusPill,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
