import '../../../../core/widgets/app_icon.dart';
import '../../../../core/constants/app_assets.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/widgets/app_messenger.dart';

class ReceiptImagePicker extends StatelessWidget {
  const ReceiptImagePicker({
    super.key,
    required this.localPath,
    required this.onPicked,
    required this.onCleared,
  });

  final String? localPath;
  final ValueChanged<String> onPicked;
  final VoidCallback onCleared;

  Future<void> _pick(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 80,
      );
      if (file != null) onPicked(file.path);
    } catch (_) {
      showAppSnack('Could not access the image. Check app permissions.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (localPath != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: Image.file(
              File(localPath!),
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: AppSpacing.xs,
            right: AppSpacing.xs,
            child: GestureDetector(
              onTap: onCleared,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.black54,
                child: const AppIcon(
                  AppAssets.close,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _PickTile(
            icon: AppAssets.photoCamera,
            label: 'Camera',
            onTap: () => _pick(ImageSource.camera),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _PickTile(
            icon: AppAssets.photoLibrary,
            label: 'Gallery',
            onTap: () => _pick(ImageSource.gallery),
          ),
        ),
      ],
    );
  }
}

class _PickTile extends StatelessWidget {
  const _PickTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: context.brand.surfaceAlt,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: context.brand.border),
        ),
        child: Column(
          children: [
            AppIcon(icon, color: context.brand.textSecondary),
            const SizedBox(height: AppSpacing.xxs),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
