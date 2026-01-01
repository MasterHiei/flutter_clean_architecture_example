import 'package:flutter_clean_architecture_example/core/domain/failures/failure.dart';
import 'package:flutter_clean_architecture_example/features/auth/domain/entities/user.dart';
import 'package:flutter_clean_architecture_example/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_clean_architecture_example/features/auth/domain/usecases/login_with_biometrics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginWithBiometrics useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginWithBiometrics(mockRepository);
  });

  group('LoginWithBiometrics', () {
    const testUser = User(id: 'user-1', email: 'test@example.com', token: 'token123');

    test(
      'Given biometrics are configured correctly, When executed, Then it should return the User from repository',
      () async {
        when(() => mockRepository.loginWithBiometrics()).thenAnswer((_) async => right(testUser));

        final Either<Failure, User> result = await useCase();

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected Right'),
          (user) => expect(user.email, testUser.email),
        );
        verify(() => mockRepository.loginWithBiometrics()).called(1);
      },
    );

    test(
      'Given biometrics are unavailable on device, When executed, Then it should return a DeviceFailure',
      () async {
        when(() => mockRepository.loginWithBiometrics()).thenAnswer(
          (_) async => left(const Failure.device(reason: DeviceFailureReason.unavailable)),
        );

        final Either<Failure, User> result = await useCase();

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<DeviceFailure>()),
          (user) => fail('Expected Left'),
        );
      },
    );

    test(
      'Given biometric authentication is rejected, When executed, Then it should return an UnauthorizedFailure',
      () async {
        when(
          () => mockRepository.loginWithBiometrics(),
        ).thenAnswer((_) async => left(const Failure.unauthorized(message: 'Auth failed')));

        final Either<Failure, User> result = await useCase();

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<UnauthorizedFailure>()),
          (user) => fail('Expected Left'),
        );
      },
    );
  });
}
