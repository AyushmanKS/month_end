import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

class BucketQrScanner extends StatefulWidget {
  const BucketQrScanner({super.key, required this.onDetected});

  final ValueChanged<String> onDetected;

  @override
  State<BucketQrScanner> createState() => _BucketQrScannerState();
}

class _BucketQrScannerState extends State<BucketQrScanner> {
  MobileScannerController? _controller;
  bool _resolving = true;
  bool _handled = false;

  @override
  void initState() {
    super.initState();
    _resolveCamera();
  }

  Future<void> _resolveCamera() async {
    var available = true;
    try {
      if (Platform.isIOS) {
        final info = await DeviceInfoPlugin().iosInfo;
        available = info.isPhysicalDevice;
      }
    } catch (_) {
      available = true;
    }
    if (!mounted) return;
    setState(() {
      _resolving = false;
      if (available) _controller = MobileScannerController();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    final code = capture.barcodes.firstOrNull?.rawValue;
    if (code == null || code.isEmpty) return;
    _handled = true;
    widget.onDetected(code.trim().toUpperCase());
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: AspectRatio(
        aspectRatio: 1,
        child: _resolving
            ? _buildResolving(context)
            : controller == null
                ? _buildUnavailable(context)
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      MobileScanner(
                          controller: controller, onDetect: _onDetect),
                      IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.primary, width: 3),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildResolving(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildUnavailable(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: scheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.no_photography_outlined,
              size: 48, color: scheme.onSurfaceVariant),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Camera scanning is not available on the iOS Simulator.\n'
            'Run on a real device, or enter the code manually below.',
            textAlign: TextAlign.center,
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
