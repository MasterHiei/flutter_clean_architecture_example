import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/auth_tokens.dart';
import '../../domain/failures/failure.dart';
import '../storage/secure_storage.dart';

part 'token_manager.g.dart';

const _accessTokenKey = 'auth_access_token';
const _refreshTokenKey = 'auth_refresh_token';
const _expiresAtKey = 'auth_expires_at';
const _tokenTypeKey = 'auth_token_type';

/// Refresh buffer: refresh tokens 2 minutes before expiry.
const _refreshBuffer = Duration(minutes: 2);

/// Manages OAuth 2.0 token storage and retrieval.
///
/// Stores access token, refresh token, and expiration in secure storage.
abstract interface class TokenManager {
  /// Gets stored tokens, returns null if not present or invalid.
  Future<AuthTokens?> getTokens();

  /// Stores OAuth tokens securely.
  Future<void> setTokens(AuthTokens tokens);

  /// Clears all stored tokens (logout).
  Future<void> clearTokens();

  /// Checks if access token needs refresh (expired or will expire soon).
  Future<bool> needsRefresh();

  /// Gets access token if valid, null otherwise.
  Future<String?> getValidAccessToken();
}

final class TokenManagerImpl implements TokenManager {
  TokenManagerImpl(this._storage);
  final SecureStorage _storage;

  @override
  Future<AuthTokens?> getTokens() async {
    try {
      final Either<Failure, String?> accessResult = await _storage.read(_accessTokenKey);
      final Either<Failure, String?> refreshResult = await _storage.read(_refreshTokenKey);
      final Either<Failure, String?> expiresResult = await _storage.read(_expiresAtKey);
      final Either<Failure, String?> typeResult = await _storage.read(_tokenTypeKey);

      final String? accessToken = accessResult.fold((_) => null, (v) => v);
      final String? refreshToken = refreshResult.fold((_) => null, (v) => v);
      final String? expiresAtStr = expiresResult.fold((_) => null, (v) => v);
      final String tokenType = typeResult.fold((_) => 'Bearer', (v) => v ?? 'Bearer');

      if (accessToken == null || refreshToken == null || expiresAtStr == null) {
        return null;
      }

      final int? expiresAt = int.tryParse(expiresAtStr);
      if (expiresAt == null) {
        return null;
      }

      return AuthTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresAt: expiresAt,
        tokenType: tokenType,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> setTokens(AuthTokens tokens) async {
    await _storage.write(_accessTokenKey, tokens.accessToken);
    await _storage.write(_refreshTokenKey, tokens.refreshToken);
    await _storage.write(_expiresAtKey, tokens.expiresAt.toString());
    await _storage.write(_tokenTypeKey, tokens.tokenType);
  }

  @override
  Future<void> clearTokens() async {
    await _storage.delete(_accessTokenKey);
    await _storage.delete(_refreshTokenKey);
    await _storage.delete(_expiresAtKey);
    await _storage.delete(_tokenTypeKey);
  }

  @override
  Future<bool> needsRefresh() async {
    final AuthTokens? tokens = await getTokens();
    if (tokens == null) {
      return false;
    }
    return tokens.isExpired || tokens.willExpireIn(_refreshBuffer);
  }

  @override
  Future<String?> getValidAccessToken() async {
    final AuthTokens? tokens = await getTokens();
    if (tokens == null || tokens.isExpired) {
      return null;
    }
    return tokens.accessToken;
  }
}

@Riverpod(keepAlive: true)
TokenManager tokenManager(Ref ref) => TokenManagerImpl(ref.read(secureStorageProvider));
