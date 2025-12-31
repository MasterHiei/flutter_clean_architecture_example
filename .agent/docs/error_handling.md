# Error Handling Strategy

> Reference document for Flutter Clean Architecture. See also: [Core Prompt](../rules.md)

## Related API Documentation

| Package | Documentation | Usage |
|---------|---------------|-------|
| **fpdart** | [pub.dev/documentation/fpdart](https://pub.dev/documentation/fpdart/latest/) | Either<Failure, T> return type |
| **Freezed** | [pub.dev/documentation/freezed](https://pub.dev/documentation/freezed/latest/) | Failure sealed class definition |

---

## 1. Error Layer Design

~~~
┌─────────────────────────────────────────────────────────────────┐
│ Presentation Layer                                               │
│   ↓ Receives Failure, decides whether/how to display to user     │
├─────────────────────────────────────────────────────────────────┤
│ Application Layer                                                │
│   ↓ Receives Either<Failure, T>, converts to UI state            │
├─────────────────────────────────────────────────────────────────┤
│ Domain Layer                                                     │
│   ↓ Defines Failure types (Business semantic errors)             │
├─────────────────────────────────────────────────────────────────┤
│ Infrastructure Layer                                             │
│   ↑ Catches Exception, depends on Failure (converts to Failure)  │
└─────────────────────────────────────────────────────────────────┘
~~~

### Core Principles

- **Exception**: Technical errors in Infrastructure layer
- **Failure**: Business semantic errors passed across layers
- Errors must be converted to types understandable by the upper layer when crossing layer boundaries.

---

## 2. Error Types

### Exception (Technical Errors)

~~~dart
sealed class AppException implements Exception {
  const AppException([this.message]);
  final String? message;
}

class NetworkException extends AppException {
  const NetworkException([super.message]);
  factory NetworkException.timeout() => const NetworkException('Connection timeout');
  factory NetworkException.noInternet() => const NetworkException('No internet connection');
}

class CacheException extends AppException {
  const CacheException([super.message]);
}

class ServerException extends AppException {
  const ServerException(this.statusCode, [super.message]);
  final int statusCode;
}
~~~

### Failure (Business Semantics)

~~~dart
@freezed
sealed class Failure with _$Failure {
  const factory Failure.network({String? message}) = NetworkFailure;
  const factory Failure.server({int? code, String? message}) = ServerFailure;
  const factory Failure.cache({String? message}) = CacheFailure;
  const factory Failure.notFound({required String resource}) = NotFoundFailure;
  const factory Failure.validation(ValidationFailure details) = _ValidationFailure;
  const factory Failure.businessRule({required String rule, String? message}) = BusinessRuleFailure;
  const factory Failure.unexpected({Object? error, StackTrace? stackTrace}) = UnexpectedFailure;
}

@freezed
sealed class ValidationFailure with _$ValidationFailure {
  const factory ValidationFailure.emptyField(String field) = EmptyFieldFailure;
  const factory ValidationFailure.invalidFormat(String field) = InvalidFormatFailure;
  const factory ValidationFailure.tooLong(String field, int maxLength) = TooLongFailure;
  const factory ValidationFailure.tooShort(String field, int minLength) = TooShortFailure;
}
~~~

---

## 3. Layer Responsibilities

### Infrastructure Layer: Exception → Failure

~~~dart
class UserRepositoryImpl implements UserRepository {
  @override
  Future<Either<Failure, User>> findById(UserId id) async {
    try {
      final dto = await _remoteDataSource.getUser(id.value);
      return right(dto.toDomain());
    } on NetworkException catch (e) {
      return left(Failure.network(message: e.message));
    } on ServerException catch (e) {
      if (e.statusCode == 404) {
        return left(Failure.notFound(resource: 'User'));
      }
      return left(Failure.server(code: e.statusCode, message: e.message));
    } catch (e, st) {
      return left(Failure.unexpected(error: e, stackTrace: st));
    }
  }
}
~~~

### Application Layer: Handling Either

~~~dart
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

### Presentation Layer: Display Decisions

~~~dart
Widget _buildErrorWidget(BuildContext context, Failure failure) {
  return switch (failure) {
    NetworkFailure() => ErrorView(
        icon: Icons.wifi_off,
        title: context.l10n.networkErrorTitle,
        action: RetryButton(onPressed: _retry),
      ),
    NotFoundFailure(:final resource) => ErrorView(
        title: context.l10n.notFoundTitle,
        message: context.l10n.notFoundMessage(resource),
      ),
    _ => ErrorView(title: context.l10n.genericErrorTitle),
  };
}
~~~

---

## 4. Error Handling Decision Matrix

| Error Type | Show to User? | Handling Strategy |
|------------|---------------|-------------------|
| `NetworkFailure` | ✅ Yes | Show Retry button |
| `NotFoundFailure` | ✅ Yes | Show resource not found message |
| `ServerFailure(5xx)` | ⚠️ Partial | Show generic error, Log it |
| `ValidationFailure` | ✅ Yes | Field-level hint |
| `BusinessRuleFailure` | ✅ Yes | Show business rule violation message |
| `CacheFailure` | ❌ No | Silent downgrade, Log it |
| `UnexpectedFailure` | ⚠️ Partial | Show generic error, Report to monitoring |

---

## 5. Error Handling Pattern Selection

### Either vs Observer Pattern

| Pattern | Pros | Cons |
|---------|------|------|
| **Either (fpdart)** | Compile-time safe, Functional composition, No callback hell | Learning curve, Requires fpdart dependency |
| **Observer Callback** | No external dependency, Explicit callbacks | Easy to miss callbacks, Hard to compose |

### Why We Choose Either

1. **Compile-time Enforcement**: `Either` forces handling of both `Left` (Error) and `Right` (Success).
2. **Perfect with Dart 3 Pattern Matching**: Exhaustive checking with `switch` expressions.
3. **Chainable**: Combinators like `flatMap`, `map`, `getOrElse`.
4. **Works well with Riverpod `AsyncValue`**: `result.fold()` → `AsyncData` / `AsyncError`.

### Comparison Example

~~~dart
// ❌ Observer Pattern: Easy to miss callbacks
presenter.login(
  onSuccess: (user) => navigateToHome(),
  onError: (e) => showError(e),
  // Easy to forget onComplete
);

// ✅ Either Pattern: Compiler enforced
final result = await login(credentials);
result.fold(
  (failure) => showError(failure),  // Must handle
  (user) => navigateToHome(),       // Must handle
);

// ✅ Concise Pattern Matching
switch (result) {
  case Left(:final value) => showError(value),
  case Right(:final value) => navigateToHome(value),
}
~~~
