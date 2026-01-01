import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/env.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/bypass_auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/log_interceptor.dart';
import 'token_manager.dart';

part 'dio_provider.g.dart';

/// Provides configured [Dio] instance for network requests.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.instance.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        // Spoof User-Agent to bypass Cloudflare
        'User-Agent':
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Accept': 'application/json',
        'Accept-Language': 'en-US,en;q=0.9',
      },
    ),
  );

  dio.interceptors.addAll([
    AuthInterceptor(ref.read(tokenManagerProvider)),
    BypassAuthInterceptor(),
    AppLogInterceptor(),
    ErrorInterceptor(),
  ]);

  return dio;
}
