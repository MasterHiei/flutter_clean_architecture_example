// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_token_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RefreshTokenResponseDto _$RefreshTokenResponseDtoFromJson(
  Map<String, dynamic> json,
) => _RefreshTokenResponseDto(
  accessToken: json['access_token'] as String,
  refreshToken: json['refresh_token'] as String,
  expiresIn: (json['expires_in'] as num).toInt(),
  tokenType: json['token_type'] as String? ?? 'Bearer',
);

Map<String, dynamic> _$RefreshTokenResponseDtoToJson(
  _RefreshTokenResponseDto instance,
) => <String, dynamic>{
  'access_token': instance.accessToken,
  'refresh_token': instance.refreshToken,
  'expires_in': instance.expiresIn,
  'token_type': instance.tokenType,
};
