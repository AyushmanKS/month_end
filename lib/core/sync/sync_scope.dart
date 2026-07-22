import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sync_providers.dart';

class SyncScope extends ConsumerStatefulWidget {
  const SyncScope({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<SyncScope> createState() => _SyncScopeState();
}

class _SyncScopeState extends ConsumerState<SyncScope> {
  AppLifecycleListener? _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(onResume: _trigger);
    WidgetsBinding.instance.addPostFrameCallback((_) => _trigger());
  }

  void _trigger() => unawaited(ref.read(syncEngineProvider).sync());

  @override
  void dispose() {
    _listener?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
