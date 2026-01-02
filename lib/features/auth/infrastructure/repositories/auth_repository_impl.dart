import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/auth_tokens.dart';
import '../../../../core/domain/failures/failure.dart';
import '../../../../core/domain/services/biometric_service.dart';
import '../../../../core/infrastructure/device/biometric_service_impl.dart';
import '../../../../core/infrastructure/network/dio_provider.dart';
import '../../../../core/infrastructure/network/token_manager.dart';
import '../../../../core/infrastructure/storage/secure_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/mock_auth_datasource.dart';
import '../dtos/login_request_dto.dart';
import '../dtos/login_response_dto.dart';
import '../dtos/refresh_token_response_dto.dart';

part 'auth_repository_impl.g.dart';

const _emailKey = 'auth_email';

final class AuthRepositoryImpl implements AuthRepository, AuthRepositoryRef {
  AuthRepositoryImpl({
    required MockAuthDataSource mockDataSource,
    required SecureStorage secureStorage,
    required TokenManager tokenManager,
    required BiometricService biometricService,
  }) : _mockDataSource = mockDataSource,
       _storage = secureStorage,
       _tokenManager = tokenManager,
       _biometric = biometricService;

  final MockAuthDataSource _mockDataSource;
  final SecureStorage _storage;
  final TokenManager _tokenManager;
  final BiometricService _biometric;

  @override
  Future<Either<Failure, User>> loginWithCredentials({
    required String email,
    required String password,
  }) async {
    try {
      final LoginResponseDto response = await _mockDataSource.login(
        LoginRequestDto(email: email, password: password),
      );

      // Create and store OAuth tokens
      final tokens = AuthTokens.fromOAuthResponse(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        expiresInSeconds: response.expiresIn,
        tokenType: response.tokenType,
      );
      await _tokenManager.setTokens(tokens);
      await _storage.write(_emailKey, email);

      return right(User(id: email, email: email, token: response.accessToken));
    } on MockAuthException catch (e) {
      if (e.statusCode == 401) {
        return left(const Failure.unauthorized(message: 'Invalid credentials'));
      }
      return left(Failure.server(code: e.statusCode, message: e.message));
    } catch (e, st) {
      return left(Failure.unexpected(error: e, stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithBiometrics() async {
    final Either<Failure, bool> available = await _biometric.isAvailable();
    return available.fold(left, (isAvailable) async {
      if (!isAvailable) {
        return left(const Failure.device(reason: DeviceFailureReason.unavailable));
      }
      final Either<Failure, bool> authResult = await _biometric.authenticate(
        reason: 'Authenticate to login',
      );
      return authResult.fold(left, (success) async {
        if (!success) {
          return left(const Failure.unauthorized(message: 'Auth failed'));
        }

        // Check for valid stored tokens
        final AuthTokens? tokens = await _tokenManager.getTokens();
        final Either<Failure, String?> emailResult = await _storage.read(_emailKey);

        if (tokens == null) {
          return left(const Failure.unauthorized(message: 'No saved credentials'));
        }

        return emailResult.fold(left, (email) {
          if (email == null) {
            return left(const Failure.unauthorized(message: 'No saved credentials'));
          }
          return right(User(id: email, email: email, token: tokens.accessToken));
        });
      });
    });
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      // Get refresh token for server-side invalidation
      final AuthTokens? tokens = await _tokenManager.getTokens();
      if (tokens != null) {
        await _mockDataSource.logout(tokens.refreshToken);
      }

      // Clear local storage
      await _tokenManager.clearTokens();
      await _storage.delete(_emailKey);
      return right(unit);
    } catch (e, st) {
      // Still clear local tokens even on server error
      await _tokenManager.clearTokens();
      await _storage.delete(_emailKey);
      return left(Failure.unexpected(error: e, stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, Option<User>>> getCurrentUser() async {
    final AuthTokens? tokens = await _tokenManager.getTokens();
    final Either<Failure, String?> emailResult = await _storage.read(_emailKey);

    if (tokens == null) {
      return right(none());
    }

    return emailResult.fold(left, (email) {
      if (email == null) {
        return right(none());
      }
      return right(some(User(id: email, email: email, token: tokens.accessToken)));
    });
  }

  /// Refreshes tokens using stored refresh token.
  ///
  /// Called by AuthInterceptor on 401 or proactively before expiry.
  @override
  Future<Either<Failure, AuthTokens>> refreshTokens() async {
    try {
      final AuthTokens? currentTokens = await _tokenManager.getTokens();
      if (currentTokens == null) {
        return left(const Failure.unauthorized(message: 'No tokens to refresh'));
      }

      final RefreshTokenResponseDto response = await _mockDataSource.refreshToken(
        currentTokens.refreshToken,
      );

      final newTokens = AuthTokens.fromOAuthResponse(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        expiresInSeconds: response.expiresIn,
        tokenType: response.tokenType,
      );

      await _tokenManager.setTokens(newTokens);
      return right(newTokens);
    } on MockAuthException catch (e) {
      // If refresh failed (e.g. invalid grant), clear tokens so guards know we are logged out
      await _tokenManager.clearTokens();
      return left(Failure.unauthorized(message: e.message));
    } catch (e, st) {
      return left(Failure.unexpected(error: e, stackTrace: st));
    }
  }

  /// Checks if current tokens need refresh.
  Future<bool> needsTokenRefresh() => _tokenManager.needsRefresh();

  /// Returns true if user has valid (or refreshable) tokens.
  Future<bool> hasValidSession() async {
    final AuthTokens? tokens = await _tokenManager.getTokens();
    return tokens != null;
  }
}

@Riverpod(keepAlive: true)
MockAuthDataSource mockAuthDataSource(Ref ref) => MockAuthDataSource();

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => AuthRepositoryImpl(
  mockDataSource: ref.read(mockAuthDataSourceProvider),
  secureStorage: ref.read(secureStorageProvider),
  tokenManager: ref.read(tokenManagerProvider),
  biometricService: ref.read(biometricServiceProvider),
);
