import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

/// Authenticated user entity.
@freezed
abstract class User with _$User {
  const factory User({required String id, required String email, required String token}) = _User;
}
