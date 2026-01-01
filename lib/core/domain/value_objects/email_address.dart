import 'package:email_validator/email_validator.dart' as validator;
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../failures/failure.dart';

part 'email_address.freezed.dart';

/// Email address value object with built-in validation.
@freezed
abstract class EmailAddress with _$EmailAddress {
  const factory EmailAddress({required String value}) = _EmailAddress;

  /// Creates from trusted source (e.g., database). Skips validation.
  factory EmailAddress.fromTrusted(String value) => EmailAddress(value: value);
  const EmailAddress._();

  /// Creates validated email. Returns [ValidationFailure] if invalid.
  static Either<ValidationFailure, EmailAddress> create(String input) {
    final String trimmed = input.trim().toLowerCase();
    if (trimmed.isEmpty) {
      return left(const ValidationFailure.emptyField('email'));
    }
    if (!validator.EmailValidator.validate(trimmed)) {
      return left(const ValidationFailure.invalidFormat('email'));
    }
    return right(EmailAddress(value: trimmed));
  }

  String get domain => value.split('@').last;
}
