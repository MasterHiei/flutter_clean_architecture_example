# Quick Reference

> Copy-paste code templates for common patterns.
>
> **⚠️ Note**: These are *templates*. Always check your project's `core/` directory for the actual base classes (e.g., `Failure`, `BaseRepository`) and adapt accordingly.

## Entity Template

> See [ddd_patterns.md](ddd_patterns.md) for Entity vs Value Object concepts.

~~~dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required UserId id,
    required UserName name,
    required Email email,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _User;

  const User._();

  // Business behavior methods
  bool get isNewUser => DateTime.now().difference(createdAt).inDays < 7;
}
~~~

---

## Value Object Template

> See [ddd_patterns.md](ddd_patterns.md) for validation patterns.

~~~dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fpdart/fpdart.dart';

part 'email.freezed.dart';

@freezed
abstract class Email with _$Email {
  const factory Email._({required String value}) = _Email;
  const Email._();

  /// Smart constructor with validation
  static Either<ValidationFailure, Email> create(String input) {
    final trimmed = input.trim().toLowerCase();
    if (trimmed.isEmpty) {
      return left(const ValidationFailure.emptyField('email'));
    }
    if (!EmailValidator.validate(trimmed)) {
      return left(const ValidationFailure.invalidFormat('email'));
    }
    return right(Email._(value: trimmed));
  }

  /// Trusted constructor for already-validated data (e.g., from database)
  factory Email.fromTrustedSource(String value) => Email._(value: value);
}
~~~

---

## Repository Interface Template

> See [architecture_principles.md](architecture_principles.md) for layer placement.

~~~dart
import 'package:fpdart/fpdart.dart';

abstract interface class UserRepository {
  Future<Either<Failure, User>> findById(UserId id);
  Future<Either<Failure, List<User>>> findAll();
  Future<Either<Failure, Unit>> save(User user);
  Future<Either<Failure, Unit>> delete(UserId id);
  Stream<List<User>> watchAll();
}
~~~

---

## Use Case Template

> See [architecture_principles.md](architecture_principles.md) for Use Case placement in Application layer.

~~~dart
class GetUserById {
  const GetUserById(this._repository);
  final UserRepository _repository;

  Future<Either<Failure, User>> call(UserId id) => _repository.findById(id);
}
~~~

---

## Notifier Template (Riverpod)

> See [technology_stack.md](technology_stack.md) for Notifier patterns.

~~~dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_detail_notifier.g.dart';

@riverpod
class UserDetailNotifier extends _$UserDetailNotifier {
  @override
  FutureOr<User?> build() => null;

  Future<void> loadUser(UserId id) async {
    state = const AsyncLoading();
    final result = await ref.read(userRepositoryProvider).findById(id);
    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (user) => AsyncData(user),
    );
  }
}
~~~

---

## DTO Template

> See [ddd_patterns.md](ddd_patterns.md) for Mapper patterns.

~~~dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
abstract class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String email,
    @Default('anonymous') String name,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);
}

// Mapper: DTO → Entity
extension UserDtoMapper on UserDto {
  User toDomain() => User(
    id: UserId.fromTrustedSource(id),
    name: UserName.fromTrustedSource(name),
    email: Email.fromTrustedSource(email),
    createdAt: DateTime.parse(createdAt),
    updatedAt: DateTime.now(),
  );
}
~~~

---

## Failure Definition Template

> See [error_handling.md](error_handling.md) for error handling strategy.

~~~dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.network({String? message}) = NetworkFailure;
  const factory Failure.server({int? code, String? message}) = ServerFailure;
  const factory Failure.cache({String? message}) = CacheFailure;
  const factory Failure.notFound({required String resource}) = NotFoundFailure;
  const factory Failure.validation(ValidationFailure details) = _ValidationFailure;
  const factory Failure.unexpected({Object? error, StackTrace? stackTrace}) = UnexpectedFailure;
}
~~~

---

## Provider Definition Template

> See [developer_experience.md](developer_experience.md) for DI patterns.

~~~dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
UserRepository userRepository(Ref ref) {
  return UserRepositoryImpl(
    ref.read(userRemoteDataSourceProvider),
    ref.read(userLocalDataSourceProvider),
  );
}

@riverpod
GetUserById getUserById(Ref ref) {
  return GetUserById(ref.read(userRepositoryProvider));
}
~~~
