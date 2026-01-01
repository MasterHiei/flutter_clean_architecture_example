import 'package:flutter_clean_architecture_example/core/infrastructure/exceptions/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppException', () {
    test('toString should return message when provided', () {
      const exception = NetworkException('Custom message');
      expect(exception.toString(), 'Custom message');
    });

    test('toString should return fallback when no message', () {
      const exception = CacheException();
      expect(exception.toString(), isNotEmpty);
    });
  });

  group('NetworkException', () {
    test('should create with message', () {
      const exception = NetworkException('Network error');
      expect(exception.message, 'Network error');
    });

    test('timeout factory should have correct message', () {
      const exception = NetworkException.timeout();
      expect(exception.message, 'Connection timeout');
    });

    test('noInternet factory should have correct message', () {
      const exception = NetworkException.noInternet();
      expect(exception.message, 'No internet connection');
    });
  });

  group('ServerException', () {
    test('should contain status code', () {
      const exception = ServerException(404, 'Not found');
      expect(exception.statusCode, 404);
      expect(exception.message, 'Not found');
    });

    test('should work without message', () {
      const exception = ServerException(500);
      expect(exception.statusCode, 500);
      expect(exception.message, isNull);
    });
  });

  group('CacheException', () {
    test('should create with optional message', () {
      const exception = CacheException('Cache miss');
      expect(exception.message, 'Cache miss');
    });
  });
}
