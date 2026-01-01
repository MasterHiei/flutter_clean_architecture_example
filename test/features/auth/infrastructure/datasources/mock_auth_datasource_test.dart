import 'package:flutter_clean_architecture_example/features/auth/infrastructure/datasources/mock_auth_datasource.dart';
import 'package:flutter_clean_architecture_example/features/auth/infrastructure/dtos/login_request_dto.dart';
import 'package:flutter_clean_architecture_example/features/auth/infrastructure/dtos/login_response_dto.dart';
import 'package:flutter_clean_architecture_example/features/auth/infrastructure/dtos/refresh_token_response_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MockAuthDataSource dataSource;

  setUp(() {
    dataSource = MockAuthDataSource();
  });

  group('login', () {
    test('Given valid credentials, When login is called, Then returns tokens', () async {
      // Arrange
      const request = LoginRequestDto(email: 'user@example.com', password: 'password123');

      // Act
      final LoginResponseDto result = await dataSource.login(request);

      // Assert
      expect(result.accessToken, isNotEmpty);
      expect(result.refreshToken, isNotEmpty);
      expect(result.expiresIn, equals(900)); // 15 minutes
      expect(result.tokenType, equals('Bearer'));
    });

    test('Given invalid email, When login is called, Then throws 401', () async {
      // Arrange
      const request = LoginRequestDto(email: 'wrong@example.com', password: 'password123');

      // Act & Assert
      expect(
        () => dataSource.login(request),
        throwsA(
          isA<MockAuthException>()
              .having((e) => e.statusCode, 'statusCode', 401)
              .having((e) => e.message, 'message', contains('Invalid')),
        ),
      );
    });

    test('Given invalid password, When login is called, Then throws 401', () async {
      // Arrange
      const request = LoginRequestDto(email: 'user@example.com', password: 'wrongpassword');

      // Act & Assert
      expect(
        () => dataSource.login(request),
        throwsA(
          isA<MockAuthException>()
              .having((e) => e.statusCode, 'statusCode', 401)
              .having((e) => e.message, 'message', contains('Invalid')),
        ),
      );
    });

    test('Given empty credentials, When login is called, Then throws 401', () async {
      // Arrange
      const request = LoginRequestDto(email: '', password: '');

      // Act & Assert
      expect(
        () => dataSource.login(request),
        throwsA(isA<MockAuthException>().having((e) => e.statusCode, 'statusCode', 401)),
      );
    });
  });

  group('refreshToken', () {
    test(
      'Given valid refresh token, When refreshToken is called, Then returns new tokens',
      () async {
        // Arrange: First login to get a valid refresh token
        const loginRequest = LoginRequestDto(email: 'user@example.com', password: 'password123');
        final LoginResponseDto loginResult = await dataSource.login(loginRequest);

        // Act
        final RefreshTokenResponseDto result = await dataSource.refreshToken(
          loginResult.refreshToken,
        );

        // Assert
        expect(result.accessToken, isNotEmpty);
        expect(result.refreshToken, isNotEmpty);
        expect(result.expiresIn, equals(900));
        // Token rotation: new refresh token should be different
        expect(result.refreshToken, isNot(equals(loginResult.refreshToken)));
      },
    );

    test('Given invalid refresh token, When refreshToken is called, Then throws 401', () async {
      // Act & Assert
      expect(
        () => dataSource.refreshToken('invalid_token'),
        throwsA(
          isA<MockAuthException>()
              .having((e) => e.statusCode, 'statusCode', 401)
              .having((e) => e.message, 'message', contains('Invalid')),
        ),
      );
    });

    test(
      'Given used refresh token after rotation, When refreshToken is called, Then throws 401',
      () async {
        // Arrange: Login and refresh once
        const loginRequest = LoginRequestDto(email: 'user@example.com', password: 'password123');
        final LoginResponseDto loginResult = await dataSource.login(loginRequest);
        await dataSource.refreshToken(loginResult.refreshToken);

        // Act & Assert: Try to use the old refresh token again
        expect(
          () => dataSource.refreshToken(loginResult.refreshToken),
          throwsA(isA<MockAuthException>()),
        );
      },
    );
  });

  group('logout', () {
    test('Given valid refresh token, When logout is called, Then invalidates token', () async {
      // Arrange: Login to get valid tokens
      const loginRequest = LoginRequestDto(email: 'user@example.com', password: 'password123');
      final LoginResponseDto loginResult = await dataSource.login(loginRequest);

      // Act
      await dataSource.logout(loginResult.refreshToken);

      // Assert: Refresh should fail now
      expect(
        () => dataSource.refreshToken(loginResult.refreshToken),
        throwsA(isA<MockAuthException>()),
      );
    });

    test(
      'Given invalid refresh token, When logout is called, Then completes without error',
      () async {
        // Act & Assert: Should not throw even with invalid token
        await expectLater(dataSource.logout('invalid_token'), completes);
      },
    );
  });

  group('token generation', () {
    test('Given multiple logins, When login is called, Then generates unique tokens', () async {
      // Arrange
      const request = LoginRequestDto(email: 'user@example.com', password: 'password123');

      // Act
      final LoginResponseDto result1 = await dataSource.login(request);
      final LoginResponseDto result2 = await dataSource.login(request);

      // Assert: Each login should generate unique tokens
      expect(result1.accessToken, isNot(equals(result2.accessToken)));
      expect(result1.refreshToken, isNot(equals(result2.refreshToken)));
    });
  });
}
