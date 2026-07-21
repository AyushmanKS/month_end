import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/error/error_handler.dart';
import '../core/logging/app_logger.dart';
import '../core/logging/logging_observers.dart';
import '../core/logging/tap_logger.dart';
import '../features/notifications/presentation/providers/notification_providers.dart';

Future<void> bootstrap(Widget Function() rootBuilder) async {
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await _loadEnv();
    await _initSupabase();
    _installErrorHandlers();

    final container = ProviderContainer(
      observers: [LoggingProviderObserver()],
    );
    try {
      await container.read(localNotificationServiceProvider).init();
    } catch (e, s) {
      AppLogger.instance.w('Local notifications init failed', e);
      unawaited(Sentry.captureException(e, stackTrace: s));
    }

    Widget appRoot() => UncontrolledProviderScope(
          container: container,
          child: TapLogger(child: rootBuilder()),
        );

    final sentryDsn = dotenv.maybeGet('SENTRY_DSN') ?? '';
    if (sentryDsn.isNotEmpty && kReleaseMode) {
      await SentryFlutter.init(
        (options) {
          options.dsn = sentryDsn;
          options.tracesSampleRate = 0.2;
        },
        appRunner: () => runApp(appRoot()),
      );
    } else {
      runApp(appRoot());
    }
  }, (error, stack) {
    AppLogger.instance.e('Uncaught zone error', error, stack);
    unawaited(Sentry.captureException(error, stackTrace: stack));
  });
}

Future<void> _loadEnv() async {
  try {
    await dotenv.load(fileName: '.env');
    AppLogger.instance.i('Environment loaded');
  } catch (e) {
    AppLogger.instance.w('No .env file found; using placeholders', e);
  }
}

Future<void> _initSupabase() async {
  final url = dotenv.maybeGet('SUPABASE_URL') ?? '';
  final anonKey = dotenv.maybeGet('SUPABASE_ANON_KEY') ?? '';
  if (url.isEmpty || anonKey.isEmpty) {
    AppLogger.instance
        .w('Supabase credentials missing; app runs in disconnected mode');
  }
  await Supabase.initialize(
    url: url.isEmpty ? 'https://placeholder.supabase.co' : url,
    publishableKey: anonKey.isEmpty ? 'placeholder-anon-key' : anonKey,
    debug: !kReleaseMode,
  );
  AppLogger.instance.i('Supabase initialized');
}

void _installErrorHandlers() {
  FlutterError.onError = (details) {
    logFlutterError(details);
    unawaited(Sentry.captureException(details.exception,
        stackTrace: details.stack));
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.instance.e('PlatformDispatcher error', error, stack);
    unawaited(Sentry.captureException(error, stackTrace: stack));
    return true;
  };
}
