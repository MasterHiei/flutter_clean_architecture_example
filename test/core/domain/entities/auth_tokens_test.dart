import 'package:flutter_clean_architecture_example/core/domain/entities/auth_tokens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthTokens', () {
    group('isExpired', () {
      test('Given token with past expiresAt, When isExpired is checked, Then returns true', () {
        // Arrange: Token expired 1 hour ago
        final tokens = AuthTokens(
          accessToken: 'access',
          refreshToken: 'refresh',
          expiresAt: DateTime.now().subtract(const Duration(hours: 1)).millisecondsSinceEpoch,
        );

        // Act & Assert
        expect(tokens.isExpired, isTrue);
      });

      test('Given token with future expiresAt, When isExpired is checked, Then returns false', () {
        // Arrange: Token expires in 1 hour
        final tokens = AuthTokens(
          accessToken: 'access',
          refreshToken: 'refresh',
          expiresAt: DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch,
        );

        // Act & Assert
        expect(tokens.isExpired, isFalse);
      });

      test('Given token just expired, When isExpired is checked, Then returns true', () {
        // Arrange: Token expired 1 second ago (boundary case)
        final tokens = AuthTokens(
          accessToken: 'access',
          refreshToken: 'refresh',
          expiresAt: DateTime.now().subtract(const Duration(seconds: 1)).millisecondsSinceEpoch,
        );

        // Act & Assert
        expect(tokens.isExpired, isTrue);
      });
    });

    group('willExpireIn', () {
      test(
        'Given token expiring soon, When willExpireIn with buffer is checked, Then returns true',
        () {
          // Arrange: Token expires in 1 minute, check with 2 minute buffer
          final tokens = AuthTokens(
            accessToken: 'access',
            refreshToken: 'refresh',
            expiresAt: DateTime.now().add(const Duration(minutes: 1)).millisecondsSinceEpoch,
          );

          // Act & Assert
          expect(tokens.willExpireIn(const Duration(minutes: 2)), isTrue);
        },
      );

      test(
        'Given token with plenty of time, When willExpireIn with buffer is checked, Then returns false',
        () {
          // Arrange: Token expires in 1 hour, check with 2 minute buffer
          final tokens = AuthTokens(
            accessToken: 'access',
            refreshToken: 'refresh',
            expiresAt: DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch,
          );

          // Act & Assert
          expect(tokens.willExpireIn(const Duration(minutes: 2)), isFalse);
        },
      );

      test(
        'Given token at exact buffer boundary, When willExpireIn is checked, Then returns true',
        () {
          // Arrange: Token expires in exactly 2 minutes, buffer is 2 minutes
          final tokens = AuthTokens(
            accessToken: 'access',
            refreshToken: 'refresh',
            expiresAt: DateTime.now().add(const Duration(minutes: 2)).millisecondsSinceEpoch,
          );

          // Act & Assert
          expect(tokens.willExpireIn(const Duration(minutes: 2)), isTrue);
        },
      );
    });

    group('fromOAuthResponse', () {
      test(
        'Given expiresInSeconds, When fromOAuthResponse is called, Then calculates correct expiresAt',
        () {
          // Arrange
          final beforeCreation = DateTime.now();

          // Act
          final tokens = AuthTokens.fromOAuthResponse(
            accessToken: 'access',
            refreshToken: 'refresh',
            expiresInSeconds: 900, // 15 minutes
          );

          final afterCreation = DateTime.now();

          // Assert: expiresAt should be roughly 15 minutes from now
          final int expectedMinMs = beforeCreation.millisecondsSinceEpoch + (900 * 1000);
          final int expectedMaxMs = afterCreation.millisecondsSinceEpoch + (900 * 1000);

          expect(tokens.expiresAt, greaterThanOrEqualTo(expectedMinMs));
          expect(tokens.expiresAt, lessThanOrEqualTo(expectedMaxMs));
        },
      );

      test('Given tokenType, When fromOAuthResponse is called, Then preserves tokenType', () {
        // Act
        final tokens = AuthTokens.fromOAuthResponse(
          accessToken: 'access',
          refreshToken: 'refresh',
          expiresInSeconds: 900,
          tokenType: 'CustomType',
        );

        // Assert
        expect(tokens.tokenType, equals('CustomType'));
      });

      test('Given no tokenType, When fromOAuthResponse is called, Then defaults to Bearer', () {
        // Act
        final tokens = AuthTokens.fromOAuthResponse(
          accessToken: 'access',
          refreshToken: 'refresh',
          expiresInSeconds: 900,
        );

        // Assert
        expect(tokens.tokenType, equals('Bearer'));
      });
    });

    group('authorizationHeader', () {
      test('Given Bearer token, When authorizationHeader is accessed, Then formats correctly', () {
        // Arrange
        final tokens = AuthTokens(
          accessToken: 'my_access_token',
          refreshToken: 'refresh',
          expiresAt: DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch,
        );

        // Act & Assert
        expect(tokens.authorizationHeader, equals('Bearer my_access_token'));
      });

      test(
        'Given custom token type, When authorizationHeader is accessed, Then uses custom type',
        () {
          // Arrange
          final tokens = AuthTokens(
            accessToken: 'my_access_token',
            refreshToken: 'refresh',
            expiresAt: DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch,
            tokenType: 'MAC',
          );

          // Act & Assert
          expect(tokens.authorizationHeader, equals('MAC my_access_token'));
        },
      );
    });
  });
}
