/// Technical exceptions in Infrastructure layer.
///
/// These are caught and converted to [Failure] before crossing layer boundaries.
sealed class AppException implements Exception {
  const AppException([this.message]);
  final String? message;

  @override
  String toString() => message ?? runtimeType.toString();
}

/// Network-related technical errors.
final class NetworkException extends AppException {
  const NetworkException([super.message]);
  const NetworkException.timeout() : super('Connection timeout');
  const NetworkException.noInternet() : super('No internet connection');
}

/// Server response errors (4xx, 5xx).
final class ServerException extends AppException {
  const ServerException(this.statusCode, [super.message]);
  final int statusCode;
}

/// Local cache/storage errors.
final class CacheException extends AppException {
  const CacheException([super.message]);
}
