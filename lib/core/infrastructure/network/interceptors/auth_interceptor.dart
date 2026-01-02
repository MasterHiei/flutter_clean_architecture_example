import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../domain/entities/auth_tokens.dart';
import '../../../domain/failures/failure.dart';
import '../../auth/auth_state_controller.dart';
import '../token_manager.dart';

/// Function type for refreshing tokens.
typedef RefreshTokensFunction = Future<Either<Failure, AuthTokens>> Function();

/// Interceptor that handles OAuth token injection and automatic refresh.
///
/// Features:
/// - Injects Bearer token into request headers (even if expired, let server decide)
/// - Handles 401 responses by attempting token refresh
/// - Queues concurrent requests during refresh (mutex pattern)
/// - Clears tokens and emits [AuthEvent.expired] on unrecoverable auth failure
final class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required TokenManager tokenManager,
    required RefreshTokensFunction refreshTokens,
    required AuthStateController authStateController,
  }) : _tokenManager = tokenManager,
       _refreshTokens = refreshTokens,
       _authStateController = authStateController;

  final TokenManager _tokenManager;
  final RefreshTokensFunction _refreshTokens;
  final AuthStateController _authStateController;

  /// Tracks if a refresh is currently in progress.
  bool _isRefreshing = false;

  /// Completer for pending requests waiting on refresh.
  Completer<Either<Failure, AuthTokens>>? _refreshCompleter;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final AuthTokens? tokens = await _tokenManager.getTokens();
    // Always send token if available, even if expired.
    // Let server return 401 to trigger refresh flow.
    // This ensures consistent error handling path.
    if (tokens != null) {
      options.headers['Authorization'] = tokens.authorizationHeader;
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only handle 401 Unauthorized
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    // Attempt token refresh
    final Either<Failure, AuthTokens> refreshResult = await _attemptRefresh();

    await refreshResult.fold(
      // Refresh failed - clear tokens, emit expired event, and reject
      (failure) async {
        // Clear tokens BEFORE emitting to prevent further requests with stale tokens
        await _tokenManager.clearTokens();
        _authStateController.emit(AuthEvent.expired);
        handler.reject(err);
      },
      // Refresh succeeded - retry original request
      (newTokens) async {
        try {
          final RequestOptions originalOptions = err.requestOptions;

          // Create properly configured Dio for retry
          // Inherit all settings from original request
          final retryDio = Dio(
            BaseOptions(
              baseUrl: originalOptions.baseUrl,
              connectTimeout: originalOptions.connectTimeout,
              receiveTimeout: originalOptions.receiveTimeout,
              sendTimeout: originalOptions.sendTimeout,
            ),
          );

          // Update auth header directly on original options
          originalOptions.headers['Authorization'] = newTokens.authorizationHeader;

          final Response<dynamic> response = await retryDio.fetch(originalOptions);
          handler.resolve(response);
        } catch (e) {
          handler.reject(DioException(requestOptions: err.requestOptions, error: e));
        }
      },
    );
  }

  /// Attempts to refresh tokens, coordinating concurrent requests.
  ///
  /// Uses a Completer-based mutex to ensure only one refresh happens
  /// at a time while all waiting requests receive the same result.
  Future<Either<Failure, AuthTokens>> _attemptRefresh() async {
    // If already refreshing, wait for the existing refresh to complete
    if (_isRefreshing) {
      // Must check _refreshCompleter after _isRefreshing to avoid race
      final Completer<Either<Failure, AuthTokens>>? completer = _refreshCompleter;
      if (completer != null) {
        return completer.future;
      }
    }

    // Acquire mutex
    _isRefreshing = true;
    final completer = Completer<Either<Failure, AuthTokens>>();
    _refreshCompleter = completer;

    try {
      final Either<Failure, AuthTokens> result = await _refreshTokens();
      completer.complete(result);
      return result;
    } catch (e, st) {
      final failure = Failure.unexpected(error: e, stackTrace: st);
      completer.complete(left(failure));
      return left(failure);
    } finally {
      // Release mutex AFTER completing, so all waiters have received result
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }
}
