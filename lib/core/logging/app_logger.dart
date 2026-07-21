import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._internal()
    : _logger = Logger(
        level: kReleaseMode ? Level.warning : Level.debug,
        printer: PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 6,
          lineLength: 90,
          colors: !kReleaseMode,
          printEmojis: !kReleaseMode,
        ),
      );

  static final AppLogger instance = AppLogger._internal();

  final Logger _logger;

  void d(String message) => _logger.d(message);
  void i(String message) => _logger.i(message);
  void w(String message, [Object? error]) => _logger.w(message, error: error);

  void e(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}

final loggerProvider = Provider<AppLogger>((ref) => AppLogger.instance);
