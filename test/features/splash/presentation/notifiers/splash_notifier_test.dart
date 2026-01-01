import 'package:flutter_clean_architecture_example/core/domain/entities/auth_tokens.dart';
import 'package:flutter_clean_architecture_example/core/domain/failures/failure.dart';
import 'package:flutter_clean_architecture_example/core/infrastructure/network/token_manager.dart';
import 'package:flutter_clean_architecture_example/features/auth/domain/entities/user.dart';
import 'package:flutter_clean_architecture_example/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_clean_architecture_example/features/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:flutter_clean_architecture_example/features/splash/presentation/notifiers/splash_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockTokenManager extends Mock implements TokenManager {}

class MockAuthRepository extends Mock implements AuthRepository {}

class FakeAuthTokens extends Fake implements AuthTokens {}

void main() {
  late ProviderContainer container;
  late MockTokenManager mockTokenManager;
  late MockAuthRepository mockAuthRepo;

  setUpAll(() {
    registerFallbackValue(FakeAuthTokens());
  });

  setUp(() {
    mockTokenManager = MockTokenManager();
    mockAuthRepo = MockAuthRepository();

    container = ProviderContainer(
      overrides: [
        tokenManagerProvider.overrideWithValue(mockTokenManager),
        authRepositoryProvider.overrideWithValue(mockAuthRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('SplashNotifier', () {
    test('Given no stored tokens, When build is called, Then returns unauthenticated', () async {
      // Arrange
      when(() => mockTokenManager.getTokens()).thenAnswer((_) async => null);

      // Act
      final SplashAuthState result = await container.read(splashProvider.future);

      // Assert
      expect(result, equals(SplashAuthState.unauthenticated));
    });

    test(
      'Given valid non-expired tokens, When build is called, Then returns authenticated',
      () async {
        // Arrange
        final validTokens = AuthTokens(
          accessToken: 'access',
          refreshToken: 'refresh',
          expiresAt: DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch,
        );

        when(() => mockTokenManager.getTokens()).thenAnswer((_) async => validTokens);
        when(() => mockAuthRepo.getCurrentUser()).thenAnswer(
          (_) async => right(const Some(User(id: '1', email: 'user@example.com', token: 'access'))),
        );

        // Act
        final SplashAuthState result = await container.read(splashProvider.future);

        // Assert
        expect(result, equals(SplashAuthState.authenticated));
      },
    );

    test(
      'Given expired tokens and refresh succeeds, When build is called, Then returns authenticated',
      () async {
        // Arrange
        final expiredTokens = AuthTokens(
          accessToken: 'expired',
          refreshToken: 'refresh',
          expiresAt: DateTime.now().subtract(const Duration(hours: 1)).millisecondsSinceEpoch,
        );
        final newTokens = AuthTokens(
          accessToken: 'new_access',
          refreshToken: 'new_refresh',
          expiresAt: DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch,
        );

        when(() => mockTokenManager.getTokens()).thenAnswer((_) async => expiredTokens);
        when(() => mockAuthRepo.refreshTokens()).thenAnswer((_) async => right(newTokens));
        when(() => mockAuthRepo.getCurrentUser()).thenAnswer(
          (_) async =>
              right(const Some(User(id: '1', email: 'user@example.com', token: 'new_access'))),
        );

        // Act
        final SplashAuthState result = await container.read(splashProvider.future);

        // Assert
        expect(result, equals(SplashAuthState.authenticated));
      },
    );

    test(
      'Given expired tokens and refresh fails, When build is called, Then returns unauthenticated',
      () async {
        // Arrange
        final expiredTokens = AuthTokens(
          accessToken: 'expired',
          refreshToken: 'refresh',
          expiresAt: DateTime.now().subtract(const Duration(hours: 1)).millisecondsSinceEpoch,
        );

        when(() => mockTokenManager.getTokens()).thenAnswer((_) async => expiredTokens);
        when(
          () => mockAuthRepo.refreshTokens(),
        ).thenAnswer((_) async => left(const Failure.unauthorized()));

        // Act
        final SplashAuthState result = await container.read(splashProvider.future);

        // Assert
        expect(result, equals(SplashAuthState.unauthenticated));
      },
    );

    test(
      'Given tokens but no stored user, When build is called, Then returns unauthenticated',
      () async {
        // Arrange
        final validTokens = AuthTokens(
          accessToken: 'access',
          refreshToken: 'refresh',
          expiresAt: DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch,
        );

        when(() => mockTokenManager.getTokens()).thenAnswer((_) async => validTokens);
        when(() => mockAuthRepo.getCurrentUser()).thenAnswer((_) async => right(const None()));

        // Act
        final SplashAuthState result = await container.read(splashProvider.future);

        // Assert
        expect(result, equals(SplashAuthState.unauthenticated));
      },
    );

    test('Given exception during check, When build is called, Then returns error', () async {
      // Arrange
      when(() => mockTokenManager.getTokens()).thenThrow(Exception('Unexpected error'));

      // Act
      final SplashAuthState result = await container.read(splashProvider.future);

      // Assert
      expect(result, equals(SplashAuthState.error));
    });
  });
}
