import 'package:flutter_clean_architecture_example/core/domain/entities/auth_tokens.dart';
import 'package:flutter_clean_architecture_example/core/domain/failures/failure.dart';
import 'package:flutter_clean_architecture_example/core/infrastructure/network/token_manager.dart';
import 'package:flutter_clean_architecture_example/core/infrastructure/storage/secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  late TokenManagerImpl tokenManager;
  late MockSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockSecureStorage();
    tokenManager = TokenManagerImpl(mockStorage);
  });

  group('getTokens', () {
    test('Given no stored tokens, When getTokens is called, Then returns null', () async {
      // Arrange
      when(() => mockStorage.read(any())).thenAnswer((_) async => right(null));

      // Act
      final AuthTokens? result = await tokenManager.getTokens();

      // Assert
      expect(result, isNull);
    });

    test('Given all tokens stored, When getTokens is called, Then returns AuthTokens', () async {
      // Arrange
      final int expiresAt = DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch;

      when(
        () => mockStorage.read('auth_access_token'),
      ).thenAnswer((_) async => right('access_token'));
      when(
        () => mockStorage.read('auth_refresh_token'),
      ).thenAnswer((_) async => right('refresh_token'));
      when(
        () => mockStorage.read('auth_expires_at'),
      ).thenAnswer((_) async => right(expiresAt.toString()));
      when(() => mockStorage.read('auth_token_type')).thenAnswer((_) async => right('Bearer'));

      // Act
      final AuthTokens? result = await tokenManager.getTokens();

      // Assert
      expect(result, isNotNull);
      expect(result!.accessToken, equals('access_token'));
      expect(result.refreshToken, equals('refresh_token'));
      expect(result.expiresAt, equals(expiresAt));
      expect(result.tokenType, equals('Bearer'));
    });

    test('Given storage read fails, When getTokens is called, Then returns null', () async {
      // Arrange
      when(
        () => mockStorage.read(any()),
      ).thenAnswer((_) async => left(const Failure.unexpected(error: 'Storage error')));

      // Act
      final AuthTokens? result = await tokenManager.getTokens();

      // Assert
      expect(result, isNull);
    });

    test('Given invalid expiresAt format, When getTokens is called, Then returns null', () async {
      // Arrange
      when(() => mockStorage.read('auth_access_token')).thenAnswer((_) async => right('access'));
      when(() => mockStorage.read('auth_refresh_token')).thenAnswer((_) async => right('refresh'));
      when(
        () => mockStorage.read('auth_expires_at'),
      ).thenAnswer((_) async => right('not_a_number'));
      when(() => mockStorage.read('auth_token_type')).thenAnswer((_) async => right('Bearer'));

      // Act
      final AuthTokens? result = await tokenManager.getTokens();

      // Assert
      expect(result, isNull);
    });
  });

  group('setTokens', () {
    test('Given AuthTokens, When setTokens is called, Then stores all fields', () async {
      // Arrange
      const tokens = AuthTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
        expiresAt: 1234567890,
      );

      when(() => mockStorage.write(any(), any())).thenAnswer((_) async => right(unit));

      // Act
      await tokenManager.setTokens(tokens);

      // Assert
      verify(() => mockStorage.write('auth_access_token', 'access')).called(1);
      verify(() => mockStorage.write('auth_refresh_token', 'refresh')).called(1);
      verify(() => mockStorage.write('auth_expires_at', '1234567890')).called(1);
      verify(() => mockStorage.write('auth_token_type', 'Bearer')).called(1);
    });
  });

  group('clearTokens', () {
    test('Given stored tokens, When clearTokens is called, Then deletes all token keys', () async {
      // Arrange
      when(() => mockStorage.delete(any())).thenAnswer((_) async => right(unit));

      // Act
      await tokenManager.clearTokens();

      // Assert
      verify(() => mockStorage.delete('auth_access_token')).called(1);
      verify(() => mockStorage.delete('auth_refresh_token')).called(1);
      verify(() => mockStorage.delete('auth_expires_at')).called(1);
      verify(() => mockStorage.delete('auth_token_type')).called(1);
    });
  });

  group('needsRefresh', () {
    test('Given no stored tokens, When needsRefresh is called, Then returns false', () async {
      // Arrange
      when(() => mockStorage.read(any())).thenAnswer((_) async => right(null));

      // Act
      final bool result = await tokenManager.needsRefresh();

      // Assert
      expect(result, isFalse);
    });

    test('Given expired token, When needsRefresh is called, Then returns true', () async {
      // Arrange: Token expired 1 hour ago
      final int expiredAt = DateTime.now()
          .subtract(const Duration(hours: 1))
          .millisecondsSinceEpoch;

      when(() => mockStorage.read('auth_access_token')).thenAnswer((_) async => right('access'));
      when(() => mockStorage.read('auth_refresh_token')).thenAnswer((_) async => right('refresh'));
      when(
        () => mockStorage.read('auth_expires_at'),
      ).thenAnswer((_) async => right(expiredAt.toString()));
      when(() => mockStorage.read('auth_token_type')).thenAnswer((_) async => right('Bearer'));

      // Act
      final bool result = await tokenManager.needsRefresh();

      // Assert
      expect(result, isTrue);
    });

    test(
      'Given token expiring within 2 minutes, When needsRefresh is called, Then returns true',
      () async {
        // Arrange: Token expires in 1 minute (within 2 minute buffer)
        final int expiresAt = DateTime.now().add(const Duration(minutes: 1)).millisecondsSinceEpoch;

        when(() => mockStorage.read('auth_access_token')).thenAnswer((_) async => right('access'));
        when(
          () => mockStorage.read('auth_refresh_token'),
        ).thenAnswer((_) async => right('refresh'));
        when(
          () => mockStorage.read('auth_expires_at'),
        ).thenAnswer((_) async => right(expiresAt.toString()));
        when(() => mockStorage.read('auth_token_type')).thenAnswer((_) async => right('Bearer'));

        // Act
        final bool result = await tokenManager.needsRefresh();

        // Assert
        expect(result, isTrue);
      },
    );

    test('Given fresh token, When needsRefresh is called, Then returns false', () async {
      // Arrange: Token expires in 1 hour (fresh)
      final int expiresAt = DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch;

      when(() => mockStorage.read('auth_access_token')).thenAnswer((_) async => right('access'));
      when(() => mockStorage.read('auth_refresh_token')).thenAnswer((_) async => right('refresh'));
      when(
        () => mockStorage.read('auth_expires_at'),
      ).thenAnswer((_) async => right(expiresAt.toString()));
      when(() => mockStorage.read('auth_token_type')).thenAnswer((_) async => right('Bearer'));

      // Act
      final bool result = await tokenManager.needsRefresh();

      // Assert
      expect(result, isFalse);
    });
  });

  group('getValidAccessToken', () {
    test('Given no tokens, When getValidAccessToken is called, Then returns null', () async {
      // Arrange
      when(() => mockStorage.read(any())).thenAnswer((_) async => right(null));

      // Act
      final String? result = await tokenManager.getValidAccessToken();

      // Assert
      expect(result, isNull);
    });

    test('Given expired token, When getValidAccessToken is called, Then returns null', () async {
      // Arrange
      final int expiredAt = DateTime.now()
          .subtract(const Duration(hours: 1))
          .millisecondsSinceEpoch;

      when(
        () => mockStorage.read('auth_access_token'),
      ).thenAnswer((_) async => right('expired_access'));
      when(() => mockStorage.read('auth_refresh_token')).thenAnswer((_) async => right('refresh'));
      when(
        () => mockStorage.read('auth_expires_at'),
      ).thenAnswer((_) async => right(expiredAt.toString()));
      when(() => mockStorage.read('auth_token_type')).thenAnswer((_) async => right('Bearer'));

      // Act
      final String? result = await tokenManager.getValidAccessToken();

      // Assert
      expect(result, isNull);
    });

    test(
      'Given valid token, When getValidAccessToken is called, Then returns access token',
      () async {
        // Arrange
        final int expiresAt = DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch;

        when(
          () => mockStorage.read('auth_access_token'),
        ).thenAnswer((_) async => right('valid_access'));
        when(
          () => mockStorage.read('auth_refresh_token'),
        ).thenAnswer((_) async => right('refresh'));
        when(
          () => mockStorage.read('auth_expires_at'),
        ).thenAnswer((_) async => right(expiresAt.toString()));
        when(() => mockStorage.read('auth_token_type')).thenAnswer((_) async => right('Bearer'));

        // Act
        final String? result = await tokenManager.getValidAccessToken();

        // Assert
        expect(result, equals('valid_access'));
      },
    );
  });
}
