import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_logger.dart';

class LoggingNavigatorObserver extends NavigatorObserver {
  String _name(Route<dynamic>? route) {
    final name = route?.settings.name;
    if (name != null && name.isNotEmpty) return name;
    return route?.settings.arguments?.toString() ?? '<unnamed>';
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.instance.i(
      '🧭 PUSH    ${_name(previousRoute)} → ${_name(route)}',
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.instance.i(
      '🧭 POP     ${_name(route)} → ${_name(previousRoute)}',
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    AppLogger.instance.i('🧭 REPLACE ${_name(oldRoute)} → ${_name(newRoute)}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.instance.d('🧭 REMOVE  ${_name(route)}');
  }
}

final class LoggingProviderObserver extends ProviderObserver {
  const LoggingProviderObserver();

  static const int _maxLen = 120;

  String _short(Object? value) {
    final text = value?.toString() ?? 'null';
    if (text.length <= _maxLen) return text;
    return '${text.substring(0, _maxLen)}…';
  }

  String _name(ProviderObserverContext context) =>
      context.provider.name ?? context.provider.runtimeType.toString();

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    final name = _name(context);
    if (name.contains('router') || name.contains('logger')) return;
    AppLogger.instance.d(
      '🔄 STATE $name: ${_short(previousValue)} → ${_short(newValue)}',
    );
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    AppLogger.instance.e(
      '🔥 PROVIDER FAILED ${_name(context)}',
      error,
      stackTrace,
    );
  }
}
