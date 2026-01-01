import 'package:dio/dio.dart';

/// Interceptor to bypass Cloudflare blocking by mocking success/failure logic locally.
///
/// This acts as a "Local Mock Server" for development stability.
class BypassAuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path.contains('/login') && options.method == 'POST') {
      final Object? data = options.data;
      if (data is Map<String, dynamic>) {
        final email = data['email'] as String?;
        final password = data['password'] as String?;

        // Simulate Reqres logic
        if (email == 'eve.holt@reqres.in' && password == 'cityslicka') {
          // Success
          final Response<Map<String, String>> response = Response(
            requestOptions: options,
            data: {'token': 'QpwL5Tk4Pnpja7X4'},
            statusCode: 200,
          );
          handler.resolve(response);
          return;
        } else {
          // Failure
          final Response<Map<String, String>> response = Response(
            requestOptions: options,
            data: {
              'error': 'user not found', // Standard Reqres error message
            },
            statusCode: 400,
          );
          // For Dio to treat 400 as an error, we should reject purely or
          // resolve with a 400 response which Dio will then likely convert to DioException
          // depending on validateStatus.
          // However, typically Interceptors should use handler.reject for errors if they want
          // to interrupt the flow as an exception.
          // BUT, AuthRemoteDataSource might expect a Response object to parse,
          // or Dio naturally throws on 400.
          // Let's create a DioException to mimic a real network error response.

          handler.reject(
            DioException(
              requestOptions: options,
              response: response,
              type: DioExceptionType.badResponse,
              message: 'Http status error [400]',
            ),
            true, // Call following error interceptors
          );
          return;
        }
      }
    }
    handler.next(options);
  }
}
