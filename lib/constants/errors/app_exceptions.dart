
/// Base exception for the application.
class AppException implements Exception {
  final String message;
  final String? code;

  const AppException({
    required this.message,
    this.code,
  });

  @override
  String toString() => message;
}

/// Network or internet connection errors.
class NetworkException extends AppException {
  const NetworkException({
    String message = 'Please check your internet connection.',
    String? code,
  }) : super(message: message, code: code);
}

/// API request timeout.
class TimeoutException extends AppException {
  const TimeoutException({
    String message = 'Request timed out. Please try again.',
    String? code,
  }) : super(message: message, code: code);
}

/// API or server errors.
class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    String message = 'Server error. Please try again later.',
    this.statusCode,
    String? code,
  }) : super(message: message, code: code);
}

/// Authentication errors.
class AuthException extends AppException {
  const AuthException({
    String message = 'Authentication failed.',
    String? code,
  }) : super(message: message, code: code);
}

/// Authorization or permission errors.
class UnauthorizedException extends AppException {
  const UnauthorizedException({
    String message = 'You are not authorized to perform this action.',
    String? code,
  }) : super(message: message, code: code);
}

/// Invalid or unexpected response data.
class DataParsingException extends AppException {
  const DataParsingException({
    String message = 'Unable to process the received data.',
    String? code,
  }) : super(message: message, code: code);
}

/// Input validation errors.
class ValidationException extends AppException {
  const ValidationException({
    String message = 'Please check the entered information.',
    String? code,
  }) : super(message: message, code: code);
}

/// Requested resource was not found.
class NotFoundException extends AppException {
  const NotFoundException({
    String message = 'Requested information was not found.',
    String? code,
  }) : super(message: message, code: code);
}

/// Unexpected application errors.
class UnknownException extends AppException {
  const UnknownException({
    String message = 'Something went wrong. Please try again.',
    String? code,
  }) : super(message: message, code: code);
}
