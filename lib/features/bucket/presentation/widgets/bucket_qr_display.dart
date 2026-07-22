import '../../../../core/widgets/app_icon.dart';
import '../../../../core/constants/app_assets.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_messenger.dart';
import '../../../../core/theme/theme_extension.dart';

class BucketQrDisplay extends StatefulWidget {
  const BucketQrDisplay({super.key, required this.joinCode, this.bucketName});

  final String joinCode;
  final String? bucketName;

  @override
  State<BucketQrDisplay> createState() => _BucketQrDisplayState();
}

class _BucketQrDisplayState extends State<BucketQrDisplay> {
  final GlobalKey _qrKey = GlobalKey();
  bool _copied = false;
  bool _sharing = false;
  Timer? _resetTimer;

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  void _copy() {
    Clipboard.setData(ClipboardData(text: widget.joinCode));
    setState(() => _copied = true);
    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  String get _shareText {
    final name = widget.bucketName;
    final intro = name == null
        ? 'Join my bucket on Month End!'
        : 'Join my “$name” bucket on Month End!';
    return '$intro\n\nJoin code: ${widget.joinCode}\n\n'
        'Open Month End → Join with a code, or scan the QR.';
  }

  Future<void> _share() async {
    if (_sharing) return;
    setState(() => _sharing = true);
    try {
      final boundary =
          _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      final files = <XFile>[];
      if (boundary != null) {
        final image = await boundary.toImage(pixelRatio: 3);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        if (bytes != null) {
          files.add(
            XFile.fromData(
              bytes.buffer.asUint8List(),
              mimeType: 'image/png',
              name: 'month-end-${widget.joinCode}.png',
            ),
          );
        }
      }
      await SharePlus.instance.share(
        ShareParams(
          text: _shareText,
          subject: 'Join my Month End bucket',
          files: files,
        ),
      );
    } catch (_) {
      if (mounted) showAppSnack('Could not open the share sheet.');
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RepaintBoundary(
          key: _qrKey,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: QrImageView(
              data: widget.joinCode,
              size: 200,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: AppColors.lightTextPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _copy,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: _copied
                      ? AppColors.success.withValues(alpha: 0.14)
                      : context.brand.surfaceAlt,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  border: Border.all(
                    color: _copied ? AppColors.success : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.joinCode,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 6,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: AppIcon(
                        _copied ? AppAssets.checkCircle : AppAssets.contentCopy,
                        key: ValueKey(_copied),
                        size: 18,
                        color: _copied ? AppColors.success : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            IconButton.filledTonal(
              onPressed: _sharing ? null : _share,
              tooltip: 'Share invite',
              icon: _sharing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const AppIcon(AppAssets.iosShare),
            ),
          ],
        ),
      ],
    );
  }
}
