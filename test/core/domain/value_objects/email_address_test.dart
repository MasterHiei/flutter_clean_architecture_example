import 'package:flutter_clean_architecture_example/core/domain/failures/failure.dart';
import 'package:flutter_clean_architecture_example/core/domain/value_objects/email_address.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  group('EmailAddress', () {
    group('create', () {
      test(
        'Given a valid email string, When create is called, Then it should return Right containing the email',
        () {
          final Either<ValidationFailure, EmailAddress> result = EmailAddress.create(
            'test@example.com',
          );

          expect(result.isRight(), true);
          result.fold((failure) => fail('Expected Right'), (email) {
            expect(email.value, 'test@example.com');
            expect(email.domain, 'example.com');
          });
        },
      );

      test(
        'Given an email with uppercase letters, When create is called, Then it should normalize to lowercase',
        () {
          final Either<ValidationFailure, EmailAddress> result = EmailAddress.create(
            'TEST@EXAMPLE.COM',
          );

          expect(result.isRight(), true);
          result.fold(
            (failure) => fail('Expected Right'),
            (email) => expect(email.value, 'test@example.com'),
          );
        },
      );

      test(
        'Given an email with whitespace padding, When create is called, Then it should trim the whitespace',
        () {
          final Either<ValidationFailure, EmailAddress> result = EmailAddress.create(
            '  test@example.com  ',
          );

          expect(result.isRight(), true);
          result.fold(
            (failure) => fail('Expected Right'),
            (email) => expect(email.value, 'test@example.com'),
          );
        },
      );

      test(
        'Given an empty string, When create is called, Then it should return Left with EmptyFieldFailure',
        () {
          final Either<ValidationFailure, EmailAddress> result = EmailAddress.create('');

          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<EmptyFieldFailure>()),
            (email) => fail('Expected Left'),
          );
        },
      );

      test(
        'Given a generic whitespace string, When create is called, Then it should return Left with EmptyFieldFailure',
        () {
          final Either<ValidationFailure, EmailAddress> result = EmailAddress.create('   ');

          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<EmptyFieldFailure>()),
            (email) => fail('Expected Left'),
          );
        },
      );

      test(
        'Given an invalid email format (no @), When create is called, Then it should return Left with InvalidFormatFailure',
        () {
          final Either<ValidationFailure, EmailAddress> result = EmailAddress.create(
            'invalid-email',
          );

          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<InvalidFormatFailure>()),
            (email) => fail('Expected Left'),
          );
        },
      );

      test(
        'Given an email missing the domain part, When create is called, Then it should return Left with InvalidFormatFailure',
        () {
          final Either<ValidationFailure, EmailAddress> result = EmailAddress.create('test@');

          expect(result.isLeft(), true);
          result.fold(
            (failure) => expect(failure, isA<InvalidFormatFailure>()),
            (email) => fail('Expected Left'),
          );
        },
      );
    });

    group('fromTrusted', () {
      test(
        'Given any string, When fromTrusted is used, Then it should bubble the value without validation',
        () {
          final email = EmailAddress.fromTrusted('any-value');
          expect(email.value, 'any-value');
        },
      );
    });

    group('equality', () {
      test('Given two EmailAddresses with equal values, Then they should be considered equal', () {
        final email1 = EmailAddress.fromTrusted('test@example.com');
        final email2 = EmailAddress.fromTrusted('test@example.com');
        expect(email1, email2);
      });

      test('Given two EmailAddresses with different values, Then they should NOT be equal', () {
        final email1 = EmailAddress.fromTrusted('test1@example.com');
        final email2 = EmailAddress.fromTrusted('test2@example.com');
        expect(email1, isNot(email2));
      });
    });
  });
}
