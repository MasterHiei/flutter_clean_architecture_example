import 'package:flutter_clean_architecture_example/core/domain/failures/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failure', () {
    test('NetworkFailure should contain message', () {
      const failure = Failure.network(message: 'No connection');
      expect(failure, isA<NetworkFailure>());
      expect((failure as NetworkFailure).message, 'No connection');
    });

    test('ServerFailure should contain status code', () {
      const failure = Failure.server(code: 500, message: 'Internal error');
      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).code, 500);
    });

    test('NotFoundFailure should contain resource name', () {
      const failure = Failure.notFound(resource: 'User');
      expect(failure, isA<NotFoundFailure>());
      expect((failure as NotFoundFailure).resource, 'User');
    });

    test('UnauthorizedFailure should be created', () {
      const failure = Failure.unauthorized();
      expect(failure, isA<UnauthorizedFailure>());
    });

    test('DeviceFailure should contain reason', () {
      const failure = Failure.device(reason: 'Biometrics unavailable');
      expect(failure, isA<DeviceFailure>());
      expect((failure as DeviceFailure).reason, 'Biometrics unavailable');
    });
  });

  group('ValidationFailure', () {
    test('EmptyFieldFailure should contain field name', () {
      const failure = ValidationFailure.emptyField('email');
      expect(failure, isA<EmptyFieldFailure>());
      expect((failure as EmptyFieldFailure).field, 'email');
    });

    test('InvalidFormatFailure should contain field name', () {
      const failure = ValidationFailure.invalidFormat('phone');
      expect(failure, isA<InvalidFormatFailure>());
    });

    test('TooShortFailure should contain min length', () {
      const failure = ValidationFailure.tooShort('password', min: 8);
      expect(failure, isA<TooShortFailure>());
      expect((failure as TooShortFailure).min, 8);
    });

    test('TooLongFailure should contain max length', () {
      const failure = ValidationFailure.tooLong('name', max: 50);
      expect(failure, isA<TooLongFailure>());
      expect((failure as TooLongFailure).max, 50);
    });
  });
}
