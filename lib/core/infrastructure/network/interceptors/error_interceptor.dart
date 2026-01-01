import 'package:dio/dio.dart';

import '../../exceptions/app_exception.dart';

/// Converts DioException to AppException for centralized error handling.
final class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final int? statusCode = err.response?.statusCode;
    if (statusCode != null) {
      if (statusCode >= 500) {
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: ServerException(statusCode, 'Server error'),
            type: err.type,
          ),
        );
        return;
      }
      if (statusCode == 401 || statusCode == 403) {
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: ServerException(statusCode, 'Unauthorized'),
            type: err.type,
          ),
        );
        return;
      }
    }
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: const NetworkException.timeout(),
          type: err.type,
        ),
      );
      return;
    }
    handler.next(err);
  }
}
