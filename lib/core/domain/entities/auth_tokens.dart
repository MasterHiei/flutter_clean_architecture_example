import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_tokens.freezed.dart';
part 'auth_tokens.g.dart';

/// OAuth 2.0 token pair with expiration tracking.
///
/// Industry standard: short-lived access token, long-lived refresh token.
@freezed
abstract class AuthTokens with _$AuthTokens {

  const factory AuthTokens({
    /// Bearer token for API authorization (short-lived: ~15 min)
    required String accessToken,

    /// Token used to obtain new access token (long-lived: ~7 days)
    required String refreshToken,

    /// Unix timestamp (milliseconds) when access token expires
    required int expiresAt,

    /// Token type, typically "Bearer"
    @Default('Bearer') String tokenType,
  }) = _AuthTokens;
  const AuthTokens._();

  factory AuthTokens.fromJson(Map<String, dynamic> json) => _$AuthTokensFromJson(json);

  /// Creates tokens from OAuth response with `expires_in` (seconds).
  factory AuthTokens.fromOAuthResponse({
    required String accessToken,
    required String refreshToken,
    required int expiresInSeconds,
    String tokenType = 'Bearer',
  }) {
    final int expiresAt = DateTime.now().millisecondsSinceEpoch + (expiresInSeconds * 1000);
    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
      tokenType: tokenType,
    );
  }

  /// Whether access token has expired.
  bool get isExpired => DateTime.now().millisecondsSinceEpoch >= expiresAt;

  /// Whether access token will expire within the given duration.
  ///
  /// Useful for proactive refresh before actual expiry.
  bool willExpireIn(Duration duration) {
    final int threshold = DateTime.now().millisecondsSinceEpoch + duration.inMilliseconds;
    return expiresAt <= threshold;
  }

  /// Returns authorization header value.
  String get authorizationHeader => '$tokenType $accessToken';
}
