import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/connectivity_providers.dart';

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

    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: online ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xE6D62828), Color(0x99E63946), Color(0x00E63946)],
              stops: [0.0, 0.35, 1.0],
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: topInset + 12),
              AnimatedOpacity(
                opacity: _showText ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_off_rounded,
                      color: Colors.white,
                      size: 18,
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
            ],
          ),
        ),
      ),
    );
  }
}
