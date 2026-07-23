import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/app_info/app_info_providers.dart';
import '../core/error/error_handler.dart';
import '../core/logging/app_logger.dart';
import '../core/logging/logging_observers.dart';
import '../core/logging/tap_logger.dart';
import '../core/sync/sync_status.dart';
import '../features/notifications/presentation/providers/notification_providers.dart';
import '../shared_providers/supabase_providers.dart';

Future<void> bootstrap(Widget Function() rootBuilder) async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await _loadEnv();
      await _initSupabase();
      if (await _recoverWebOAuthRedirect()) return;
      _installErrorHandlers();

      final packageInfo = await _loadPackageInfo();
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        observers: [LoggingProviderObserver()],
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          if (packageInfo != null)
            packageInfoProvider.overrideWith((ref) async => packageInfo),
        ],
      );
      try {
        final notifications = container.read(localNotificationServiceProvider);
        await notifications.init();
        await notifications.requestPermissions();
      } catch (e, s) {
        AppLogger.instance.w('Local notifications init failed', e);
        unawaited(Sentry.captureException(e, stackTrace: s));
      }

      container.listen<SyncStatus>(syncStatusProvider, (previous, next) {
        Sentry.configureScope((scope) {
          scope.setContexts('sync', {
            'phase': next.phase.name,
            'completed': next.completed,
            'total': next.total,
            'failed': next.failed,
          });
        });
      });

      Widget appRoot() => UncontrolledProviderScope(
        container: container,
        child: TapLogger(child: rootBuilder()),
      );

      final sentryDsn = dotenv.maybeGet('SENTRY_DSN') ?? '';
      if (sentryDsn.isNotEmpty && kReleaseMode) {
        await SentryFlutter.init((options) {
          options.dsn = sentryDsn;
          options.tracesSampleRate = 0.2;
          options.environment = kReleaseMode ? 'production' : 'development';
          if (packageInfo != null) {
            options.release =
                'month_end@${packageInfo.version}+${packageInfo.buildNumber}';
          }
        }, appRunner: () => runApp(appRoot()));
      } else {
        runApp(appRoot());
      }
    },
    (error, stack) {
      AppLogger.instance.e('Uncaught zone error', error, stack);
      unawaited(Sentry.captureException(error, stackTrace: stack));
    },
  );
}

Future<void> _loadEnv() async {
  try {
    await dotenv.load(fileName: '.env');
    AppLogger.instance.i('Environment loaded');
  } catch (e) {
    AppLogger.instance.w('No .env file found; using placeholders', e);
  }
}

Future<PackageInfo?> _loadPackageInfo() async {
  try {
    final info = await PackageInfo.fromPlatform();
    AppLogger.instance.i('App version ${info.version}+${info.buildNumber}');
    return info;
  } catch (e, s) {
    AppLogger.instance.w('Failed to read package info', e);
    unawaited(Sentry.captureException(e, stackTrace: s));
    return null;
  }
}

Future<bool> _recoverWebOAuthRedirect() async {
  if (!kIsWeb) return false;
  final uri = Uri.base;
  final params = <String, String>{...uri.queryParameters};
  if (uri.fragment.isNotEmpty) {
    params.addAll(Uri.splitQueryString(uri.fragment));
  }
  if (params['error_code'] != 'identity_already_exists') return false;
  final redirect = '${uri.origin}${uri.path}';
  AppLogger.instance.i(
    'Web OAuth: identity already linked, signing into existing account',
  );
  try {
    await Supabase.instance.client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: redirect,
    );
    return true;
  } catch (e, s) {
    AppLogger.instance.w('Web OAuth recovery failed', e);
    unawaited(Sentry.captureException(e, stackTrace: s));
    return false;
  }
}

Future<void> _initSupabase() async {
  final url = dotenv.maybeGet('SUPABASE_URL') ?? '';
  final anonKey = dotenv.maybeGet('SUPABASE_ANON_KEY') ?? '';
  if (url.isEmpty || anonKey.isEmpty) {
    AppLogger.instance.w(
      'Supabase credentials missing; app runs in disconnected mode',
    );
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
    unawaited(
      Sentry.captureException(details.exception, stackTrace: details.stack),
    );
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.instance.e('PlatformDispatcher error', error, stack);
    unawaited(Sentry.captureException(error, stackTrace: stack));
    return true;
  };
}
