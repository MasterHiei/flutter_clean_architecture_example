import 'package:flutter_clean_architecture_example/core/infrastructure/exceptions/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppException', () {
    test(
      'Given an exception with a message, When toString is called, Then it should return that message',
      () {
        const exception = NetworkException('Custom message');
        expect(exception.toString(), 'Custom message');
      },
    );

    test(
      'Given an exception without a message, When toString is called, Then it should return a non-empty fallback',
      () {
        const exception = CacheException();
        expect(exception.toString(), isNotEmpty);
      },
    );
  });

  group('NetworkException', () {
    test('Given a custom message, When instantiated, Then it should retain that message', () {
      const exception = NetworkException('Network error');
      expect(exception.message, 'Network error');
    });

    test(
      'Given the timeout factory, When instantiated, Then it should have the correct timeout message',
      () {
        const exception = NetworkException.timeout();
        expect(exception.message, 'Connection timeout');
      },
    );

    test(
      'Given the noInternet factory, When instantiated, Then it should have the correct no-internet message',
      () {
        const exception = NetworkException.noInternet();
        expect(exception.message, 'No internet connection');
      },
    );
  });

  group('ServerException', () {
    test('Given a status code and message, When instantiated, Then it should retain both', () {
      const exception = ServerException(404, 'Not found');
      expect(exception.statusCode, 404);
      expect(exception.message, 'Not found');
    });

    test('Given only a status code, When instantiated, Then the message should be null', () {
      const exception = ServerException(500);
      expect(exception.statusCode, 500);
      expect(exception.message, isNull);
    });
  });

  group('CacheException', () {
    test('Given a message, When instantiated, Then it should retain that message', () {
      const exception = CacheException('Cache miss');
      expect(exception.message, 'Cache miss');
    });
  });
}
