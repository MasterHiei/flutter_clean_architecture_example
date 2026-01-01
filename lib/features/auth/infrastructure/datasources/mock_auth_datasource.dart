import 'dart:math';

import '../dtos/login_request_dto.dart';
import '../dtos/login_response_dto.dart';
import '../dtos/refresh_token_response_dto.dart';

/// Mock authentication data source for OAuth 2.0 simulation.
///
/// Replaces reqres.in with local mock that implements complete OAuth flow:
/// - Login with credentials → access + refresh tokens
/// - Token refresh with rotation
/// - Configurable token lifetimes for testing
class MockAuthDataSource {
  MockAuthDataSource({
    this.accessTokenLifetimeSeconds = 900, // 15 minutes default
    this.refreshTokenLifetimeSeconds = 604800, // 7 days default
    this.simulatedNetworkDelayMs = 300,
  });

  /// Access token lifetime in seconds (default: 15 min)
  final int accessTokenLifetimeSeconds;

  /// Refresh token lifetime in seconds (default: 7 days)
  final int refreshTokenLifetimeSeconds;

  /// Simulated network delay in milliseconds
  final int simulatedNetworkDelayMs;

  /// Valid test credentials
  static const _validEmail = 'user@example.com';
  static const _validPassword = 'password123';

  /// Current valid refresh token (simulates server-side storage)
  String? _currentValidRefreshToken;

  /// Simulates login API call.
  ///
  /// Returns OAuth tokens on success, throws on invalid credentials.
  Future<LoginResponseDto> login(LoginRequestDto request) async {
    await _simulateNetworkDelay();

    // Validate credentials
    if (request.email != _validEmail || request.password != _validPassword) {
      throw const MockAuthException(statusCode: 401, message: 'Invalid email or password');
    }

    // Generate tokens
    final String accessToken = _generateToken('access');
    final String refreshToken = _generateToken('refresh');

    // Store valid refresh token (simulates server-side)
    _currentValidRefreshToken = refreshToken;

    return LoginResponseDto(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: accessTokenLifetimeSeconds,
    );
  }

  /// Simulates token refresh API call.
  ///
  /// Validates refresh token, rotates tokens on success.
  Future<RefreshTokenResponseDto> refreshToken(String refreshToken) async {
    await _simulateNetworkDelay();

    // Validate refresh token
    if (refreshToken != _currentValidRefreshToken) {
      throw const MockAuthException(statusCode: 401, message: 'Invalid or expired refresh token');
    }

    // Generate new tokens (rotation)
    final String newAccessToken = _generateToken('access');
    final String newRefreshToken = _generateToken('refresh');

    // Invalidate old refresh token, store new one
    _currentValidRefreshToken = newRefreshToken;

    return RefreshTokenResponseDto(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
      expiresIn: accessTokenLifetimeSeconds,
    );
  }

  /// Validates access token for API requests.
  ///
  /// Returns true if token format is valid (actual expiry is client-side).
  bool validateAccessToken(String accessToken) {
    return accessToken.startsWith('mock_access_');
  }

  /// Simulates logout (invalidates refresh token).
  Future<void> logout(String refreshToken) async {
    await _simulateNetworkDelay();
    if (refreshToken == _currentValidRefreshToken) {
      _currentValidRefreshToken = null;
    }
  }

  /// Generates a mock token with prefix and random suffix.
  String _generateToken(String prefix) {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    final String suffix = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return 'mock_${prefix}_$suffix';
  }

  Future<void> _simulateNetworkDelay() async {
    await Future<void>.delayed(Duration(milliseconds: simulatedNetworkDelayMs));
  }
}

/// Exception thrown by mock auth operations.
class MockAuthException implements Exception {
  const MockAuthException({required this.statusCode, required this.message});

  final int statusCode;
  final String message;

  @override
  String toString() => 'MockAuthException($statusCode): $message';
}
