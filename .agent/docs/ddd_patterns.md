# DDD Tactical Patterns

> Reference document for Flutter Clean Architecture. See also: [Core Prompt](../rules.md)
>
> Based on Eric Evans' "Domain-Driven Design" and Martin Fowler's authoritative definitions.

## Related API Documentation

| Package | Documentation | Usage |
|---------|---------------|-------|
| **Freezed** | [pub.dev/documentation/freezed](https://pub.dev/documentation/freezed/latest/) | Entity / Value Object definition |
| **fpdart** | [pub.dev/documentation/fpdart](https://pub.dev/documentation/fpdart/latest/) | Either / Option / TaskEither |

---

## 1. Entity vs Value Object

| Feature | Entity | Value Object |
|---------|--------|--------------|
| **Core Definition** | Business object with unique identity | Immutable object defined by its attributes |
| **Equality** | Based on Identity (ID) | Based on all attribute values |
| **Mutability** | Properties can change (Identity persists) | **Must be immutable** (Change means replacement) |
| **Lifecycle** | Independent, trackable | Bound to Entity, replaceable |
| **Examples** | `User`, `Order`, `Product` | `Email`, `Money`, `Address` |

### Decision Process

~~~
Question: Does this object need to be tracked?
│
├─ YES → Question: Are two objects different even if they have the same attributes?
│         ├─ YES → Entity (Needs unique ID)
│         └─ NO  → Value Object
│
└─ NO  → Question: Is the object defined solely by its attribute values?
          ├─ YES → Value Object
          └─ NO  → Revisit business requirements
~~~

---

## 2. Entity Implementation

~~~dart
@freezed
abstract class User with _$User {
  const factory User({
    required UserId id,          // Unique ID (Value Object)
    required UserName name,      // Mutable property
    required Email email,        // Mutable property
    required UserRole role,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _User;

  const User._();

  // Business Behavior
  bool get isNewUser => DateTime.now().difference(createdAt).inDays < 7;
  bool get isAdmin => role == UserRole.admin;

  // Modify Entity using copyWith to return new instance (Freezed generated)
  // user.copyWith(name: newName, updatedAt: DateTime.now())
}

// Entity equality is based on ID
extension UserEquality on User {
  bool isSameEntity(User other) => id == other.id;
}
~~~

---

## 3. Value Object Implementation

~~~dart
@freezed
abstract class Email with _$Email {
  @Assert('value.isNotEmpty', 'Email cannot be empty')
  const factory Email._({required String value}) = _Email;
  const Email._();

  // Smart Constructor - Returns Either indicating potential validation failure
  static Either<ValidationFailure, Email> create(String input) {
    final trimmed = input.trim().toLowerCase();
    if (trimmed.isEmpty) {
      return left(const ValidationFailure.emptyField('email'));
    }
    // Use regex or package like 'email_validator' for validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(trimmed)) {
      return left(const ValidationFailure.invalidFormat('email'));
    }
    return right(Email._(value: trimmed));
  }

  // Trusted Constructor - Only for already verified data (e.g. from DB)
  factory Email.fromTrustedSource(String value) => Email._(value: value);

  String get domain => value.split('@').last;
}
~~~

---

## 4. Compound Value Object Example

~~~dart
@freezed
abstract class Money with _$Money {
  const factory Money._({required int amountInCents, required Currency currency}) = _Money;
  const Money._();

  static Either<ValidationFailure, Money> create(int amountInCents, Currency currency) {
    if (amountInCents < 0) {
      return left(const ValidationFailure.negativeValue('amount'));
    }
    return right(Money._(amountInCents: amountInCents, currency: currency));
  }

  /// Value Objects can have behavior
  Money add(Money other) {
    assert(currency == other.currency, 'Currency mismatch');
    return Money._(amountInCents: amountInCents + other.amountInCents, currency: currency);
  }

  String get formatted => '${currency.symbol}${(amountInCents / 100).toStringAsFixed(2)}';
}
~~~

---

## 5. Other DDD Concepts

| Concept | Definition | Responsibility Boundary |
|---------|------------|-------------------------|
| **Repository** | Abstraction of Entity collection | Handles Entity persistence only, no business logic |
| **Use Case** | Application business operation | Coordinates Repository calls, contains app logic |
| **DTO** | Data Transfer Object | Used for cross-layer data transfer, no business logic |
| **Mapper** | Object Converter | DTO ↔ Entity conversion |
| **DataSource** | Data Source Abstraction | Encapsulates specific tech implementation (API, DB) |

### Repository Example

~~~dart
abstract interface class UserRepository {
  Future<Either<Failure, User>> findById(UserId id);
  Future<Either<Failure, List<User>>> findAll();
  Future<Either<Failure, Unit>> save(User user);
  Future<Either<Failure, Unit>> delete(UserId id);
  Stream<List<User>> watchAll();
}
~~~

### Use Case Example

~~~dart
class GetUserById {
  const GetUserById(this._repository);
  final UserRepository _repository;

  Future<Either<Failure, User>> call(UserId id) => _repository.findById(id);
}
~~~

### Mapper Example

~~~dart
// DTO → Entity
extension UserMapper on UserDto {
  User toDomain() => User(
    id: UserId.fromTrustedSource(id),
    name: UserName.fromTrustedSource(name),
    email: Email.fromTrustedSource(email),
    role: UserRole.values.byName(role),
    createdAt: DateTime.parse(createdAt),
    updatedAt: DateTime.parse(updatedAt),
  );
}

// Entity → DTO
extension UserDtoMapper on User {
  UserDto toDto() => UserDto(
    id: id.value,
    name: name.value,
    email: email.value,
    role: role.name,
    createdAt: createdAt.toIso8601String(),
    updatedAt: updatedAt.toIso8601String(),
  );
}
~~~

---

## 6. fpdart Core Types

### Either - Error Handling

~~~dart
// Either<L, R>: Left for Failure, Right for Success
Future<Either<Failure, User>> findById(UserId id);

// Handle results using fold
result.fold(
  (failure) => showError(failure),
  (user) => showUser(user),
);

// Provide default value using getOrElse
final user = result.getOrElse(() => User.empty());

// Chaining operations
result
  .map((user) => user.name)
  .flatMap((name) => validateName(name));
~~~

### Option - Nullable Values

~~~dart
// Option<T>: Some has value, None has no value
Option<User> findByEmail(String email);

// Create Option
final some = Option.of(value);      // Some(value) or None (if null)
final none = Option<User>.none();   // None

// Use Option
option.match(
  () => 'No user found',           // None case
  (user) => 'Found: ${user.name}', // Some case
);

// Convert to Either
option.toEither(() => Failure.notFound(resource: 'User'));
~~~

### TaskEither - Async Error Handling

~~~dart
// TaskEither wraps async operations, lazy execution
TaskEither<Failure, User> fetchUser(UserId id) {
  return TaskEither.tryCatch(
    () => _apiClient.getUser(id.value).then((dto) => dto.toDomain()),
    (error, stackTrace) => Failure.unexpected(error: error),
  );
}

// Chain multiple async operations
final result = await fetchUser(id)
  .flatMap((user) => updateLastLogin(user))
  .flatMap((user) => cacheUser(user))
  .run(); // Execute async operations, return Either
~~~
