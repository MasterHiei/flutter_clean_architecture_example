import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../dtos/login_request_dto.dart';
import '../dtos/login_response_dto.dart';

part 'auth_remote_datasource.g.dart';

@RestApi(baseUrl: 'https://reqres.in/api')
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String? baseUrl}) = _AuthRemoteDataSource;

  @POST('/login')
  Future<LoginResponseDto> login(@Body() LoginRequestDto request);
}
