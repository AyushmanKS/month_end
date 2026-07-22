import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'app_exception.dart';
import '../logging/app_logger.dart';

class ErrorHandler {
  const ErrorHandler._();

  static AppException map(Object error, [StackTrace? stackTrace]) {
    if (error is CanceledException) return error;
    if (error is GoogleSignInException &&
        error.code == GoogleSignInExceptionCode.canceled) {
      return const CanceledException();
    }

    AppLogger.instance.e('Handled error', error, stackTrace);

    if (error is AppException) return error;

    if (error is sb.AuthException) {
      final code = error.code ?? '';
      if (code.contains('identity_already_exists') ||
          error.message.toLowerCase().contains('already')) {
        return IdentityCollisionException(error.message, cause: error);
      }
      return AuthException(error.message, cause: error);
    }

    if (error is sb.PostgrestException) {
      if (error.code == '42501' ||
          error.message.toLowerCase().contains('row-level security')) {
        return PermissionDeniedException(
          'You do not have permission for this action.',
          cause: error,
        );
      }
      if (error.code == 'PGRST116') {
        return NotFoundException(
          'The requested item was not found.',
          cause: error,
        );
      }
      return UnknownException(error.message, cause: error);
    }

    return UnknownException(error.toString(), cause: error);
  }

  static String userMessage(Object error) {
    if (error is AppException) return error.message;
    return 'Something went wrong. Please try again.';
  }
}

typedef ErrorReporter = void Function(Object error, StackTrace stackTrace);

void logFlutterError(FlutterErrorDetails details) {
  AppLogger.instance.e('FlutterError', details.exception, details.stack);
}
