import 'package:freezed_annotation/freezed_annotation.dart';

part 'refresh_token_response_dto.freezed.dart';
part 'refresh_token_response_dto.g.dart';

/// OAuth 2.0 token refresh response.
///
/// Returns new access token and optionally rotates refresh token.
/// Field names match JSON keys directly (snake_case).
@Freezed(toJson: false)
abstract class RefreshTokenResponseDto with _$RefreshTokenResponseDto {
  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory RefreshTokenResponseDto({
    /// New access token
    required String accessToken,

    /// New refresh token (token rotation)
    required String refreshToken,

    /// New token lifetime in seconds
    required int expiresIn,

    /// Token type (typically "Bearer")
    @Default('Bearer') String tokenType,
  }) = _RefreshTokenResponseDto;

  factory RefreshTokenResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseDtoFromJson(json);
}
