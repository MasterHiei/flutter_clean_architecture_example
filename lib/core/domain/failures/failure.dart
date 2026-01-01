import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Business-level errors passed across architectural layers.
///
/// Use pattern matching to handle each case exhaustively.
@freezed
sealed class Failure with _$Failure {
  const factory Failure.network({String? message}) = NetworkFailure;
  const factory Failure.server({int? code, String? message}) = ServerFailure;
  const factory Failure.cache({String? message}) = CacheFailure;
  const factory Failure.notFound({required String resource}) = NotFoundFailure;
  const factory Failure.validation(ValidationFailure details) = _ValidationFailure;
  const factory Failure.device({required String reason}) = DeviceFailure;
  const factory Failure.unauthorized({String? message}) = UnauthorizedFailure;
  const factory Failure.unexpected({Object? error, StackTrace? stackTrace}) = UnexpectedFailure;
}

/// Validation-specific failures for form/input handling.
@freezed
sealed class ValidationFailure with _$ValidationFailure {
  const factory ValidationFailure.emptyField(String field) = EmptyFieldFailure;
  const factory ValidationFailure.invalidFormat(String field) = InvalidFormatFailure;
  const factory ValidationFailure.tooShort(String field, {required int min}) = TooShortFailure;
  const factory ValidationFailure.tooLong(String field, {required int max}) = TooLongFailure;
  const factory ValidationFailure.mismatch(String field) = MismatchFailure;
}
