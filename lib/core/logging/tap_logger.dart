import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'app_logger.dart';

class TapLogger extends StatelessWidget {
  const TapLogger({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (kReleaseMode) return child;
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _onPointerDown,
      child: child,
    );
  }

  void _onPointerDown(PointerDownEvent event) {
    final target = _describeHit(event.position);
    final pos =
        '(${event.position.dx.toStringAsFixed(0)}, ${event.position.dy.toStringAsFixed(0)})';
    AppLogger.instance.d('👆 TAP $pos${target.isEmpty ? '' : ' → $target'}');
  }

  String _describeHit(Offset position) {
    final view = WidgetsBinding.instance.platformDispatcher.views.firstOrNull;
    if (view == null) return '';
    final result = HitTestResult();
    WidgetsBinding.instance.hitTestInView(result, position, view.viewId);

    String? fallbackType;
    for (final entry in result.path) {
      final target = entry.target;
      if (target is RenderObject) {
        final label = _labelOf(target);
        if (label != null && label.trim().isNotEmpty) return label.trim();
        fallbackType ??= target.runtimeType.toString();
      }
    }
    return fallbackType ?? '';
  }

  String? _labelOf(RenderObject object) {
    final config = object.debugSemantics;
    if (config != null) {
      final label = config.label;
      if (label.isNotEmpty) return label;
    }
    if (object is RenderParagraph) {
      return object.text.toPlainText();
    }
    return null;
  }
}
