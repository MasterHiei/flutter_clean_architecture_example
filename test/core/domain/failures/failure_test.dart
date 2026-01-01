import 'package:flutter_clean_architecture_example/core/domain/failures/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failure', () {
    test(
      'Given a NetworkFailure with a message, When instantiated, Then it should contain that exact message',
      () {
        const failure = Failure.network(message: 'No connection');
        expect(failure, isA<NetworkFailure>());
        expect((failure as NetworkFailure).message, 'No connection');
      },
    );

    test(
      'Given a ServerFailure, When instantiated with 500, Then it should retain the status code',
      () {
        const failure = Failure.server(code: 500, message: 'Internal error');
        expect(failure, isA<ServerFailure>());
        expect((failure as ServerFailure).code, 500);
      },
    );

    test(
      'Given a NotFoundFailure, When instantiated, Then it should identify the missing resource',
      () {
        const failure = Failure.notFound(resource: 'User');
        expect(failure, isA<NotFoundFailure>());
        expect((failure as NotFoundFailure).resource, 'User');
      },
    );

    test(
      'Given an UnauthorizedFailure, When instantiated, Then it should be of the correct type',
      () {
        const failure = Failure.unauthorized();
        expect(failure, isA<UnauthorizedFailure>());
      },
    );

    test('Given a DeviceFailure, When instantiated, Then it should contain the reason', () {
      const device = Failure.device(reason: DeviceFailureReason.unavailable);
      expect(device, isA<DeviceFailure>());
      expect((device as DeviceFailure).reason, DeviceFailureReason.unavailable);
    });
  });

  group('ValidationFailure', () {
    test('Given an EmptyFieldFailure, When instantiated, Then it should identify the field', () {
      const failure = ValidationFailure.emptyField('email');
      expect(failure, isA<EmptyFieldFailure>());
      expect((failure as EmptyFieldFailure).field, 'email');
    });

    test('Given an InvalidFormatFailure, When instantiated, Then it should identify the field', () {
      const failure = ValidationFailure.invalidFormat('phone');
      expect(failure, isA<InvalidFormatFailure>());
    });

    test('Given a TooShortFailure, When instantiated, Then it should contain the min length', () {
      const failure = ValidationFailure.tooShort('password', min: 8);
      expect(failure, isA<TooShortFailure>());
      expect((failure as TooShortFailure).min, 8);
    });

    test('Given a TooLongFailure, When instantiated, Then it should contain the max length', () {
      const failure = ValidationFailure.tooLong('name', max: 50);
      expect(failure, isA<TooLongFailure>());
      expect((failure as TooLongFailure).max, 50);
    });
  });
}
