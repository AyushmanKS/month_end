sealed class AppException implements Exception {
  const AppException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => '$runtimeType: $message';
}

class AuthException extends AppException {
  const AuthException(super.message, {super.cause});
}

class IdentityCollisionException extends AppException {
  const IdentityCollisionException(super.message, {super.cause});
}

class PermissionDeniedException extends AppException {
  const PermissionDeniedException(super.message, {super.cause});
}

class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.cause});
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.cause});
}

class ValidationException extends AppException {
  const ValidationException(super.message, {super.cause});
}

class UnknownException extends AppException {
  const UnknownException(super.message, {super.cause});
}

class CanceledException extends AppException {
  const CanceledException() : super('Cancelled');
}
