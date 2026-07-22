import '../../core/constants/app_assets.dart';
import '../../core/widgets/app_icon.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void showAppSnack(String message, {bool success = false}) {
  final messenger = rootScaffoldMessengerKey.currentState;
  if (messenger == null) return;
  messenger
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: success ? AppColors.success : null,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        content: Row(
          children: [
            if (success)
              const Padding(
                padding: EdgeInsets.only(right: AppSpacing.sm),
                child: AppIcon(
                  AppAssets.checkCircle,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
}
