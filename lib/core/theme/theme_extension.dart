import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppBrandColors extends ThemeExtension<AppBrandColors> {
  const AppBrandColors({
    required this.accent,
    required this.success,
    required this.warning,
    required this.danger,
    required this.surfaceAlt,
    required this.border,
    required this.textSecondary,
  });

  final Color accent;
  final Color success;
  final Color warning;
  final Color danger;
  final Color surfaceAlt;
  final Color border;
  final Color textSecondary;

  static const AppBrandColors light = AppBrandColors(
    accent: AppColors.accent,
    success: AppColors.success,
    warning: AppColors.warning,
    danger: AppColors.danger,
    surfaceAlt: AppColors.lightSurfaceAlt,
    border: AppColors.lightBorder,
    textSecondary: AppColors.lightTextSecondary,
  );

  static const AppBrandColors dark = AppBrandColors(
    accent: AppColors.accent,
    success: AppColors.success,
    warning: AppColors.warning,
    danger: AppColors.danger,
    surfaceAlt: AppColors.darkSurfaceAlt,
    border: AppColors.darkBorder,
    textSecondary: AppColors.darkTextSecondary,
  );

  @override
  AppBrandColors copyWith({
    Color? accent,
    Color? success,
    Color? warning,
    Color? danger,
    Color? surfaceAlt,
    Color? border,
    Color? textSecondary,
  }) {
    return AppBrandColors(
      accent: accent ?? this.accent,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      border: border ?? this.border,
      textSecondary: textSecondary ?? this.textSecondary,
    );
  }

  @override
  AppBrandColors lerp(ThemeExtension<AppBrandColors>? other, double t) {
    if (other is! AppBrandColors) return this;
    return AppBrandColors(
      accent: Color.lerp(accent, other.accent, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      border: Color.lerp(border, other.border, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
    );
  }
}

extension AppBrandColorsX on BuildContext {
  AppBrandColors get brand => Theme.of(this).extension<AppBrandColors>()!;
}
