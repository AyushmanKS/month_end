import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';
import '../network/connectivity_providers.dart';

class OfflineBackground extends ConsumerWidget {
  const OfflineBackground({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final online = ref.watch(isOnlineProvider).value ?? true;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;

    return Stack(
      children: [
        Positioned.fill(child: ColoredBox(color: baseColor)),
        Positioned.fill(
          child: AnimatedOpacity(
            opacity: online ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOut,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x59D62828),
                    Color(0x24E63946),
                    Color(0x00E63946),
                  ],
                  stops: [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OfflineOverlay extends ConsumerStatefulWidget {
  const OfflineOverlay({super.key});

  @override
  ConsumerState<OfflineOverlay> createState() => _OfflineOverlayState();
}

class _OfflineOverlayState extends ConsumerState<OfflineOverlay> {
  bool _showText = true;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onOffline() {
    _timer?.cancel();
    setState(() => _showText = true);
    _timer = Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _showText = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<bool>>(isOnlineProvider, (previous, next) {
      final online = next.value ?? true;
      if (!online) {
        _onOffline();
      } else {
        _timer?.cancel();
      }
    });

    final online = ref.watch(isOnlineProvider).value ?? true;
    final topInset = MediaQuery.paddingOf(context).top;
    final visible = !online && _showText;

    return IgnorePointer(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: topInset + 12),
          child: AnimatedOpacity(
            opacity: visible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD62828),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.cloud_off_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "You're Offline",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
