import 'package:flutter_clean_architecture_example/core/domain/failures/failure.dart';
import 'package:flutter_clean_architecture_example/core/domain/value_objects/email_address.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  group('EmailAddress', () {
    group('create', () {
      test('should return Right with valid email', () {
        final Either<ValidationFailure, EmailAddress> result = EmailAddress.create(
          'test@example.com',
        );

        expect(result.isRight(), true);
        result.fold((failure) => fail('Expected Right'), (email) {
          expect(email.value, 'test@example.com');
          expect(email.domain, 'example.com');
        });
      });

      test('should normalize email to lowercase', () {
        final Either<ValidationFailure, EmailAddress> result = EmailAddress.create(
          'TEST@EXAMPLE.COM',
        );

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected Right'),
          (email) => expect(email.value, 'test@example.com'),
        );
      });

      test('should trim whitespace', () {
        final Either<ValidationFailure, EmailAddress> result = EmailAddress.create(
          '  test@example.com  ',
        );

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected Right'),
          (email) => expect(email.value, 'test@example.com'),
        );
      });

      test('should return EmptyFieldFailure for empty string', () {
        final Either<ValidationFailure, EmailAddress> result = EmailAddress.create('');

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<EmptyFieldFailure>()),
          (email) => fail('Expected Left'),
        );
      });

      test('should return EmptyFieldFailure for whitespace only', () {
        final Either<ValidationFailure, EmailAddress> result = EmailAddress.create('   ');

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<EmptyFieldFailure>()),
          (email) => fail('Expected Left'),
        );
      });

      test('should return InvalidFormatFailure for invalid email', () {
        final Either<ValidationFailure, EmailAddress> result = EmailAddress.create('invalid-email');

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<InvalidFormatFailure>()),
          (email) => fail('Expected Left'),
        );
      });

      test('should return InvalidFormatFailure for email without domain', () {
        final Either<ValidationFailure, EmailAddress> result = EmailAddress.create('test@');

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<InvalidFormatFailure>()),
          (email) => fail('Expected Left'),
        );
      });
    });

    group('fromTrusted', () {
      test('should create EmailAddress without validation', () {
        final email = EmailAddress.fromTrusted('any-value');
        expect(email.value, 'any-value');
      });
    });

    group('equality', () {
      test('should be equal for same value', () {
        final email1 = EmailAddress.fromTrusted('test@example.com');
        final email2 = EmailAddress.fromTrusted('test@example.com');
        expect(email1, email2);
      });

      test('should not be equal for different values', () {
        final email1 = EmailAddress.fromTrusted('test1@example.com');
        final email2 = EmailAddress.fromTrusted('test2@example.com');
        expect(email1, isNot(email2));
      });
    });
  });
}
