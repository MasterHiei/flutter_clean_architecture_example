import 'package:flutter_clean_architecture_example/core/domain/failures/failure.dart';
import 'package:flutter_clean_architecture_example/features/auth/domain/entities/user.dart';
import 'package:flutter_clean_architecture_example/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_clean_architecture_example/features/auth/domain/usecases/login_with_credentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginWithCredentials useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginWithCredentials(mockRepository);
  });

  group('LoginWithCredentials', () {
    const testEmail = 'eve.holt@reqres.in';
    const testPassword = 'cityslicka';
    const testUser = User(id: 'eve.holt@reqres.in', email: testEmail, token: 'QpwL5tke4Pnpja7X4');

    test(
      'Given valid user inputs, When executed, Then it should return the authenticated User from the repository',
      () async {
        when(
          () => mockRepository.loginWithCredentials(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => right(testUser));

        final Either<Failure, User> result = await useCase(
          const LoginCredentials(email: testEmail, password: testPassword),
        );

        expect(result.isRight(), true);
        result.fold((failure) => fail('Expected Right'), (user) {
          expect(user.email, testEmail);
          expect(user.token, 'QpwL5tke4Pnpja7X4');
        });
        verify(
          () => mockRepository.loginWithCredentials(email: testEmail, password: testPassword),
        ).called(1);
      },
    );

    test(
      'Given invalid credentials, When executed, Then it should propagate the repository Failure',
      () async {
        when(
          () => mockRepository.loginWithCredentials(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => left(const Failure.unauthorized(message: 'Invalid credentials')));

        final Either<Failure, User> result = await useCase(
          const LoginCredentials(email: 'wrong@email.com', password: 'wrong'),
        );

        expect(result.isLeft(), true);
      },
    );
  });
}
