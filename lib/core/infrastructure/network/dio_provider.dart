import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/auth_tokens.dart';
import '../../domain/failures/failure.dart';
import '../auth/auth_state_controller.dart';
import '../constants/env.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/bypass_auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/log_interceptor.dart';
import 'token_manager.dart';

part 'dio_provider.g.dart';

/// Provides configured [Dio] instance for network requests.
///
/// The [AuthInterceptor] is configured with:
/// - Token manager for header injection
/// - Refresh function for 401 handling
/// - Auth state controller for expired event broadcasting
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final TokenManager tokenManager = ref.read(tokenManagerProvider);
  final AuthStateController authStateController = ref.read(authStateControllerProvider);

  // Refresh function that calls AuthRepository.refreshTokens()
  // Uses late binding to avoid circular dependency
  Future<Either<Failure, AuthTokens>> refreshTokens() async {
    // Dynamically import to avoid circular dependency at build time
    final AuthRepositoryRef authRepoProvider = ref.read(authRepositoryProviderRef);
    return authRepoProvider.refreshTokens();
  }

  final dio = Dio(
    BaseOptions(
      baseUrl: Env.instance.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'User-Agent':
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Accept': 'application/json',
        'Accept-Language': 'en-US,en;q=0.9',
      },
    ),
  );

  dio.interceptors.addAll([
    AuthInterceptor(
      tokenManager: tokenManager,
      refreshTokens: refreshTokens,
      authStateController: authStateController,
    ),
    BypassAuthInterceptor(),
    AppLogInterceptor(),
    ErrorInterceptor(),
  ]);

  return dio;
}

/// Provider reference for AuthRepository to avoid circular import.
/// This is overriden in the app's ProviderScope with the actual implementation.
final authRepositoryProviderRef = Provider<AuthRepositoryRef>((ref) {
  throw UnimplementedError('authRepositoryProviderRef must be overriden in ProviderScope');
});

/// Abstract interface for auth repository refresh capability.
abstract interface class AuthRepositoryRef {
  Future<Either<Failure, AuthTokens>> refreshTokens();
}
