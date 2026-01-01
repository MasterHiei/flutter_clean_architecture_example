import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response_dto.freezed.dart';
part 'login_response_dto.g.dart';

/// OAuth 2.0 login response with access and refresh tokens.
///
/// Field names match JSON keys directly (snake_case).
@Freezed(toJson: false)
abstract class LoginResponseDto with _$LoginResponseDto {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory LoginResponseDto({
    /// Access token for API authorization
    required String accessToken,

    /// Refresh token for obtaining new access tokens
    required String refreshToken,

    /// Token lifetime in seconds
    required int expiresIn,

    /// Token type (typically "Bearer")
    @Default('Bearer') String tokenType,
  }) = _LoginResponseDto;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) => _$LoginResponseDtoFromJson(json);
}
