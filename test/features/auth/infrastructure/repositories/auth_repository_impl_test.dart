import 'package:flutter_clean_architecture_example/core/domain/entities/auth_tokens.dart';
import 'package:flutter_clean_architecture_example/core/domain/failures/failure.dart';
import 'package:flutter_clean_architecture_example/core/domain/services/biometric_service.dart';
import 'package:flutter_clean_architecture_example/core/infrastructure/network/token_manager.dart';
import 'package:flutter_clean_architecture_example/core/infrastructure/storage/secure_storage.dart';
import 'package:flutter_clean_architecture_example/features/auth/domain/entities/user.dart';
import 'package:flutter_clean_architecture_example/features/auth/infrastructure/datasources/mock_auth_datasource.dart';
import 'package:flutter_clean_architecture_example/features/auth/infrastructure/dtos/login_request_dto.dart';
import 'package:flutter_clean_architecture_example/features/auth/infrastructure/dtos/login_response_dto.dart';
import 'package:flutter_clean_architecture_example/features/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockMockAuthDataSource extends Mock implements MockAuthDataSource {}

class MockSecureStorage extends Mock implements SecureStorage {}

class MockTokenManager extends Mock implements TokenManager {}

class MockBiometricService extends Mock implements BiometricService {}

class FakeLoginRequestDto extends Fake implements LoginRequestDto {}

class FakeAuthTokens extends Fake implements AuthTokens {}

void main() {
  late AuthRepositoryImpl repository;
  late MockMockAuthDataSource mockDataSource;
  late MockSecureStorage mockStorage;
  late MockTokenManager mockTokenManager;
  late MockBiometricService mockBiometric;

  setUpAll(() {
    registerFallbackValue(FakeLoginRequestDto());
    registerFallbackValue(FakeAuthTokens());
  });

  setUp(() {
    mockDataSource = MockMockAuthDataSource();
    mockStorage = MockSecureStorage();
    mockTokenManager = MockTokenManager();
    mockBiometric = MockBiometricService();
    repository = AuthRepositoryImpl(
      mockDataSource: mockDataSource,
      secureStorage: mockStorage,
      tokenManager: mockTokenManager,
      biometricService: mockBiometric,
    );
  });

  group('loginWithCredentials', () {
    const testEmail = 'user@example.com';
    const testPassword = 'password123';
    const testAccessToken = 'mock_access_token';
    const testRefreshToken = 'mock_refresh_token';

    test(
      'Given valid credentials, When loginWithCredentials is called, Then it should return User and persist tokens',
      () async {
        when(() => mockDataSource.login(any())).thenAnswer(
          (_) async => const LoginResponseDto(
            accessToken: testAccessToken,
            refreshToken: testRefreshToken,
            expiresIn: 900,
          ),
        );
        when(() => mockTokenManager.setTokens(any())).thenAnswer((_) async {});
        when(() => mockStorage.write(any(), any())).thenAnswer((_) async => right(unit));

        final Either<Failure, User> result = await repository.loginWithCredentials(
          email: testEmail,
          password: testPassword,
        );

        expect(result.isRight(), true);
        result.fold((f) => fail('Expected Right'), (user) {
          expect(user.email, testEmail);
          expect(user.token, testAccessToken);
        });
        verify(() => mockTokenManager.setTokens(any())).called(1);
        verify(() => mockStorage.write('auth_email', testEmail)).called(1);
      },
    );

    test(
      'Given invalid credentials, When loginWithCredentials is called, Then it should return UnauthorizedFailure',
      () async {
        when(
          () => mockDataSource.login(any()),
        ).thenThrow(const MockAuthException(statusCode: 401, message: 'Invalid credentials'));

        final Either<Failure, User> result = await repository.loginWithCredentials(
          email: testEmail,
          password: 'wrong',
        );

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<UnauthorizedFailure>()),
          (user) => fail('Expected Left'),
        );
      },
    );
  });

  group('loginWithBiometrics', () {
    test(
      'Given biometrics unavailable, When loginWithBiometrics is called, Then it should return DeviceFailure',
      () async {
        when(() => mockBiometric.isAvailable()).thenAnswer((_) async => right(false));

        final Either<Failure, User> result = await repository.loginWithBiometrics();

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<DeviceFailure>()),
          (user) => fail('Expected Left'),
        );
      },
    );

    test(
      'Given biometrics available and valid tokens stored, When loginWithBiometrics is called, Then it should return authenticated User',
      () async {
        when(() => mockBiometric.isAvailable()).thenAnswer((_) async => right(true));
        when(
          () => mockBiometric.authenticate(reason: any(named: 'reason')),
        ).thenAnswer((_) async => right(true));
        when(() => mockTokenManager.getTokens()).thenAnswer(
          (_) async => AuthTokens(
            accessToken: 'saved_token',
            refreshToken: 'saved_refresh',
            expiresAt: DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch,
          ),
        );
        when(
          () => mockStorage.read('auth_email'),
        ).thenAnswer((_) async => right('saved@example.com'));

        final Either<Failure, User> result = await repository.loginWithBiometrics();

        expect(result.isRight(), true);
        result.fold((f) => fail('Expected Right'), (user) {
          expect(user.email, 'saved@example.com');
          expect(user.token, 'saved_token');
        });
      },
    );

    test(
      'Given no saved tokens, When loginWithBiometrics is called, Then it should return UnauthorizedFailure',
      () async {
        when(() => mockBiometric.isAvailable()).thenAnswer((_) async => right(true));
        when(
          () => mockBiometric.authenticate(reason: any(named: 'reason')),
        ).thenAnswer((_) async => right(true));
        when(() => mockTokenManager.getTokens()).thenAnswer((_) async => null);
        when(() => mockStorage.read('auth_email')).thenAnswer((_) async => right(null));

        final Either<Failure, User> result = await repository.loginWithBiometrics();

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<UnauthorizedFailure>()),
          (user) => fail('Expected Left'),
        );
      },
    );
  });

  group('logout', () {
    test('Given logout called, Then it should clear tokens and stored email', () async {
      when(() => mockTokenManager.getTokens()).thenAnswer(
        (_) async => AuthTokens(
          accessToken: 'token',
          refreshToken: 'refresh',
          expiresAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );
      when(() => mockDataSource.logout(any())).thenAnswer((_) async {});
      when(() => mockTokenManager.clearTokens()).thenAnswer((_) async {});
      when(() => mockStorage.delete(any())).thenAnswer((_) async => right(unit));

      final Either<Failure, Unit> result = await repository.logout();

      expect(result.isRight(), true);
      verify(() => mockTokenManager.clearTokens()).called(1);
      verify(() => mockStorage.delete('auth_email')).called(1);
    });
  });

  group('getCurrentUser', () {
    test(
      'Given no tokens saved, When getCurrentUser is called, Then it should return None',
      () async {
        when(() => mockTokenManager.getTokens()).thenAnswer((_) async => null);
        when(() => mockStorage.read('auth_email')).thenAnswer((_) async => right(null));

        final Either<Failure, Option<User>> result = await repository.getCurrentUser();

        expect(result.isRight(), true);
        result.fold((f) => fail('Expected Right'), (option) {
          expect(option.isNone(), true);
        });
      },
    );

    test(
      'Given tokens exist, When getCurrentUser is called, Then it should return Some(User)',
      () async {
        when(() => mockTokenManager.getTokens()).thenAnswer(
          (_) async => AuthTokens(
            accessToken: 'token',
            refreshToken: 'refresh',
            expiresAt: DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch,
          ),
        );
        when(
          () => mockStorage.read('auth_email'),
        ).thenAnswer((_) async => right('user@example.com'));

        final Either<Failure, Option<User>> result = await repository.getCurrentUser();

        expect(result.isRight(), true);
        result.fold((f) => fail('Expected Right'), (option) {
          expect(option.isSome(), true);
          option.fold(() => fail('Expected Some'), (user) {
            expect(user.email, 'user@example.com');
          });
        });
      },
    );
  });
}
