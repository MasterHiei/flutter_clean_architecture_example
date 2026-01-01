import 'package:dio/dio.dart';

import '../../../domain/entities/auth_tokens.dart';
import '../token_manager.dart';

/// Injects auth token into request headers.
///
/// Simple interceptor for adding Bearer token; for full OAuth
/// handling with refresh, use AuthInterceptor in parent directory.
final class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenManager);
  final TokenManager _tokenManager;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final AuthTokens? tokens = await _tokenManager.getTokens();
    if (tokens != null && !tokens.isExpired) {
      options.headers['Authorization'] = tokens.authorizationHeader;
    }
    handler.next(options);
  }
}
