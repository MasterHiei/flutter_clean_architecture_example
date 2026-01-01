import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/env.dart';

part 'dio_provider.g.dart';

/// Provides configured [Dio] instance for network requests.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  return Dio(
    BaseOptions(
      baseUrl: Env.instance.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );
}
